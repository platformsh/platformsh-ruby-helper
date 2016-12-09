require "platform_sh/version"
require "base64"
require 'json'
require 'open3'

class PlatformSH
  'use strict'
  # Reads Platform.sh configuration from environment and returns a single object
  def self.config
    conf = {}
    if platform_local_development?
      conf["relationships"] = JSON.parse(Base64.decode64(tunnel_info))
      return conf
    end
    if on_platform?
      conf["application"] = read_base64_json('PLATFORM_APPLICATION')
      conf["application_name"] =ENV["PLATFORM_APPLICATION_NAME"] || nil
      conf["app_dir"] =ENV["PLATFORM_APP_DIR"] || nil
      conf["project"] =ENV["PLATFORM_PROJECT"] || nil
      conf["document_root"] =ENV["PLATFORM_DOCUMENT_ROOT"] || nil
      if !is_build_environment?
        conf["environment"] =ENV["PLATFORM_ENVIRONMENT"] || nil
        conf["project_entropy"] =ENV["PLATFORM_PROJECT_ENTROPY"] || nil
        conf["port"] =ENV["PORT"] || nil
        conf["socket"] =ENV["SOCKET"] || nil
        conf["relationships"] = read_base64_json('PLATFORM_RELATIONSHIPS')
        conf["variables"] = read_base64_json('PLATFORM_VARIABLES')
      end
    else
      $stderr.puts "This is not running on platform.sh"
      return nil
    end
    conf
  end

  def self.on_platform?
    ENV.has_key? 'PLATFORM_PROJECT'
  end

  def self.is_build_environment?
    (!ENV.has_key?('PLATFORM_ENVIRONMENT') && ENV.has_key?('PLATFORM_PROJECT'))
  end

  def self.relationship rel_name, attr
    on_platform? ? config["relationships"][rel_name].first[attr] : nil
  end

  private
  def self.read_base64_json(var_name)
    begin
      return  (Base64.decode64(ENV[var_name]))
    rescue
      $stderr.puts "no " + var_name + " environment variable"
      return nil
    end
  end


  def self.read_app_config
    JSON.parse(File.read('/run/config.json'))
  end


  #Tries to guess relational database url
  def self.guess_database_url
    postgresql_url = self.guess_postgresql_url
    mysql_url = self.guess_mysql_url
    if !mysql_url.nil? && !postgresql_url.nil?
      $stderr.puts "More than one relational database, giving up, set configuration by hand"
      return nil
    end
    if (mysql_url.nil? && postgresql_url.nil?)
      $stderr.puts "Could not find a relational database"
      return nil
    end
    return mysql_url || postgresql_url
  end

  def self.guess_url(service_type, platform_scheme, url_template)
    services = PlatformSH::config["relationships"].select {|k,v| v[0]["scheme"]==platform_scheme}
    case services.length
    when 0
      $stderr.puts "Could not find an #{service_type}"
      return nil
    when 1
      service = services.first[1][0]
      service =  service.each_with_object({}){|(k,v), h| h[k.to_sym] = v} #keys need to be symbols
      return url_template % service
    else
      $stderr.puts "More than one #{service_type}, giving up, set configuration by hand"
    end
  end

  def self.guess_elasticsearch_url
    self.guess_url("elasticsearch", "http", "http://%{host}:%{port}")
  end

  def self.guess_redis_url
    self.guess_url("redis", "redis", "redis://%{host}:%{port}")
  end

  def self.guess_mongodb_url
    self.guess_url("mongodb", "mongodb", "mongodb://%{username}:%{password}@%{host}:%{port}/%{path}")
  end

  def self.guess_solr_url
    self.guess_url("solr", "solr", "http://%{host}:%{port}/%{path}")
  end

  def self.guess_mysql_url
    #fallback to mysql url if mysql2 gem is not loaded
    if Gem::Specification::find_all_by_name("mysql2").empty?
      template = "mysql://%{username}:%{password}@%{host}:%{port}/%{path}"
    else
      template = "mysql2://%{username}:%{password}@%{host}:%{port}/%{path}"
    end
    self.guess_url("mysql", "mysql",template)
  end

  def self.guess_rabbitmq_url
    self.guess_url("rabbitmq", "amqp","amqp://%{username}:%{password}@%{host}:%{port}")
  end

  def self.guess_postgresql_url
    self.guess_url("postgresql", "pgsql","postgresql://%{username}:%{password}@%{host}:%{port}")
  end

  def self.export_services_urls
    if (on_platform? || platform_local_development?) && !is_build_environment?
      ENV['DATABASE_URL']=PlatformSH::guess_database_url
      ENV['MONGODB_URL']=PlatformSH::guess_mongodb_url
      ENV['REDIS_URL']=PlatformSH::guess_redis_url
      ENV['ELASTICSEARCH_URL']=PlatformSH::guess_elasticsearch_url
      ENV['RABBITMQ_URL']=PlatformSH::guess_rabbitmq_url
      ENV['SOLR_URL']=PlatformSH::guess_solr_url
    else
      $stderr.puts "Can not guess URLS when not on platform"
    end
  end

  def self.platform_local_development?
    dev_environment = ENV["RACK_ENV"] != "production" && ENV["RAILS_ENV"] != "production"
    dev_environment && cli_installed? && !on_platform?
  end

  def self.cli_installed?
    cli_installed = !(`platform --version --yes`.match "^Platform.sh CLI.*").nil?
    $stderr.puts "No Platform.sh CLI found; Check your path" if !cli_installed 
    cli_installed
  end

  def self.tunnel_open?
    Open3.popen3("platform --yes tunnel:info") do |stdin, stdout, stderr, wait_thr|
      err = stderr.gets
      return !(!err.nil? && err.start_with?("No tunnels found"))
    end
  end

  def self.tunnel_info
    %x(platform tunnel:info -c --yes)
  end

  def self.tunnel_open
    %x(platform tunnel:open --yes >/dev/null)
  end

  def self.tunnel_close
    %x(platform tunnel:close --yes >/dev/null)
  end
  
  def self.local_tunnel_env  
    # Signal catching
    def shut_down
      puts "\nShutting down gracefully..."
      sleep 1
    end

    puts "I have PID #{Process.pid}"
    %w(INT TERM USR1 USR2 TTIN).each do |sig|
          begin
            trap sig do
              puts("got #{sig}")
            end
          rescue ArgumentError
            puts "Signal #{sig} not supported"
          end
        end
        
    command = ARGV[1]
    if command.nil?
      $stderr.puts "You must supply an executable to run"
      return nil
    end
    if !tunnel_open?
      puts tunnel_open
    end
    export_services_urls
    puts "********\nRemeber to close the tunnel using platform tunnel:close\n********\n"
    `bundle exec "#{command}"`
  end
end
require "platform_sh/version"
require "base64"
require 'json'

class PlatformSH
  'use strict'
  # Reads Platform.sh configuration from environment and returns a single object
  def self.config
    if on_platform?
      conf = {}
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
      return JSON.parse(Base64.decode64(ENV[var_name]))
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
    ENV['DATABASE_URL']=PlatformSH::guess_database_url
    ENV['MONGODB_URL']=PlatformSH::guess_mongodb_url
    ENV['REDIS_URL']=PlatformSH::guess_redis_url
    ENV['ELASTICSEARCH_URL']=PlatformSH::guess_elasticsearch_url
    ENV['RABBITMQ_URL']=PlatformSH::guess_rabbitmq_url
    ENV['SOLR_URL']=PlatformSH::guess_solr_url
  end
  
end
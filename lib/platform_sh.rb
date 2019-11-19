require "platform_sh/version"
require "base64"
require 'json'
require 'logger'
require 'uri'

$logger = Logger.new(STDOUT)
# Default to Log level DEBUG unless the env variable is presnet, then set it to
# WARN
$logger.level = ENV['DEBUG'] || $DEBUG ?  Logger::DEBUG : Logger::WARN

class PlatformSH
  'use strict'
  # Reads Platform.sh configuration from environment and returns a single object
  def self.config
    if !on_platform?
      $logger.info "This is not running on platform.sh"
      return nil
    end
    conf = {}
    conf["application"] = read_base64_json('PLATFORM_APPLICATION')
    conf["routes"] = read_base64_json('PLATFORM_ROUTES')
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
      $logger.error "no " + var_name + " environment variable"
      return nil
    end
  end


  def self.read_app_config
    if !on_platform?
      $logger.info "This is not running on platform.sh"
      return nil
    end
    #FIXME we should be able to get 
    JSON.parse(File.read('/run/config.json'))
  end
  
  #Tries to guess the hostname it takes the first upstream
  def self.guess_hostname
    if !on_platform?
      $logger.info "This is not running on platform.sh"
      return nil
    end
    if is_build_environment?
      $logger.info "No hostname in build environment"
      return nil
    end
    
    upstreams = PlatformSH::config["routes"].select {|k,v| v["type"]=="upstream"}
    begin 
    if upstreams.length > 1
      $logger.info "More than one upstream. Picking first in list."
    end
    if upstreams.length > 0
      return URI.parse(upstreams.keys[0]).host
    else
      $logger.error "Found no upstreams in PLATFORM_ROUTES"
      return nil
    end
    rescue Exception => e
      $logger.error "Error encountered while guessing hostname. #{e.message}"
      return nil
    end
  end  
  
  #Tries to guess relational database url
  def self.guess_database_url
    if !on_platform?
      $logger.info "This is not running on platform.sh"
      return nil
    end
    if is_build_environment?
      $logger.info "No relationships in build environment"
      return nil
    end
    postgresql_url = self.guess_postgresql_url
    mysql_url = self.guess_mysql_url
    if !mysql_url.nil? && !postgresql_url.nil?
      $logger.info "More than one relational database, giving up, set configuration by hand"
      return nil
    end
    if (mysql_url.nil? && postgresql_url.nil?)
      $logger.info "Could not find a relational database"
      return nil
    end
    return mysql_url || postgresql_url
  end

  def self.guess_url(scheme, url_template, port=nil)
    if !on_platform?
      $logger.info "This is not running on platform.sh"
      return nil
    end
    if is_build_environment?
      $logger.info "No relationships in build environment"
      return nil
    end
    services = PlatformSH::config["relationships"].select {|k,v| v[0]["scheme"]==scheme && (!port || v[0]["port"].to_s==port.to_s )} #For ElasticSearch and InfluxDB both on HTTP we also look at the port
    case services.length
      when 0
        $logger.info "Could not find an #{scheme}"
        return nil
      when 1
        service = services.first[1][0]
        service =  service.each_with_object({}){|(k,v), h| h[k.to_sym] = v} #keys need to be symbols
        return url_template % service
      else
        $logger.warn "More than one #{scheme}, giving up, set configuration by hand"
        return nil
    end
  end
  
  def self.guess_elasticsearch_url
    self.guess_url("http", "http://%{host}:%{port}",9200)
  end
  
  def self.guess_redis_url
    self.guess_url("redis", "redis://%{host}:%{port}")
  end
  
  def self.guess_mongodb_url
    self.guess_url("mongodb", "mongodb://%{username}:%{password}@%{host}:%{port}/%{path}")
  end
  
  def self.guess_solr_url
    self.guess_url( "solr", "http://%{host}:%{port}/%{path}")
  end
  
  def self.guess_mysql_url
    #fallback to mysql url if mysql2 gem is not loaded
    if Gem::Specification::find_all_by_name("mysql2").empty?
      template = "mysql://%{username}:%{password}@%{host}:%{port}/%{path}"
    else
      template = "mysql2://%{username}:%{password}@%{host}:%{port}/%{path}"
    end
    self.guess_url("mysql", template)
  end
  
  def self.guess_rabbitmq_url
    self.guess_url("amqp","amqp://%{username}:%{password}@%{host}:%{port}")
  end
  
  def self.guess_postgresql_url
    self.guess_url("pgsql","postgresql://%{username}:%{password}@%{host}:%{port}")
  end
  
  def self.guess_influxdb_url
    self.guess_url("http","http://%{host}:%{port}", 8086)
  end
  
  def self.guess_kafka_url
    self.guess_url("kafka","%{host}:%{port}")
  end
  
  def self.export_services_urls
    ENV['DATABASE_URL']||=PlatformSH::guess_database_url
    ENV['MONGODB_URL']||=PlatformSH::guess_mongodb_url
    ENV['REDIS_URL']||=PlatformSH::guess_redis_url
    ENV['ELASTICSEARCH_URL']||=PlatformSH::guess_elasticsearch_url
    ENV['RABBITMQ_URL']||=PlatformSH::guess_rabbitmq_url
    ENV['SOLR_URL']||=PlatformSH::guess_solr_url
    ENV['INFLUXDB_URL']||=PlatformSH::guess_influxdb_url
    ENV['KAFKA_URL']||=PlatformSH::guess_kafka_url
    ENV['HOSTNAME']||=PlatformSH::guess_hostname
  end
  
end
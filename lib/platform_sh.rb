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
    databases = PlatformSH::config["relationships"].select {|k,v| v[0]["scheme"]=="mysql" || v[0]["scheme"]=="postgresql"}
    case databases.length
    when 0
      $stderr.puts "Could not find a relational database"
      return nil
    when 1
      database = databases.first[1][0]
      database_url = "#{database['scheme']}://#{database['username']}:#{database['password']}@#{database['host']}:#{database['port']}/#{database['path']}"
      return database_url
    else
      $stderr.puts "More than one database, giving up, set configuration by hand"
    end
  end

end

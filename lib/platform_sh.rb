require "platform_sh/version"
require "base64"
require 'json'

class PlatformSH
  'use strict';
   # Reads Platform.sh configuration from environment and returns a single object
   def self.config
      if ENV.has_key? "PLATFORM_PROJECT" then
        conf = {}
        conf["application"] = read_base64_json('PLATFORM_APPLICATION')
        conf["relationships"] = read_base64_json('PLATFORM_RELATIONSHIPS')
        conf["variables"] = read_base64_json('PLATFORM_VARIABLES')
        conf["application_name"] =ENV["PLATFORM_APPLICATION_NAME"] || nil
        conf["app_dir"] =ENV["PLATFORM_APP_DIR"] || nil
        conf["document_root"] =ENV["PLATFORM_DOCUMENT_ROOT"] || nil
        conf["environment"] =ENV["PLATFORM_ENVIRONMENT"] || nil
        conf["project_entropy"] =ENV["PLATFORM_PROJECT_ENTROPY"] || nil
        conf["project"] =ENV["PLATFORM_PROJECT"] || nil
        conf["port"] =ENV["PORT"] || nil
        conf["socket"] =ENV["SOCKET"] || nil
      else
        $stderr.puts "This is not running on platform.sh"
        return nil
      end
      return conf;
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
  
end

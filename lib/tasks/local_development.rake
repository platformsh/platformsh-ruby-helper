require 'rake'
require "platform_sh"

task :default => [:local_tunnel_env]

namespace :platform_sh do
  desc 'Open Tunnels, set services env variables to remote Platform.sh services and runs a command with the env'
  task :local_tunnel_env do
    PlatformSH::local_tunnel_env
  end
end
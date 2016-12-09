require 'rake'
require "platform_sh"

task :default => [:local_tunnel_env]

namespace :platform_sh do
  desc 'Open Tunnels and set services env variables to remote Platform.sh services'
  task :local_tunnel_env do
    PlatformSH::local_tunnel_env
  end
end
require 'rake'
require "platform_sh"
namespace :platform_sh do
  desc 'Open Tunnels and set services env variables to remote Platform.sh services'
  task :local_tunnel_env do
    PlatformSH::tunnel_open_export_env_and_run
  end
end
load 'basefile.rb'

app_name = ENV['APP_NAME']

namespace :unicorn do
  task :environment do
    set :unicorn_pid, "/tmp/unicorn_#{app_name}.pid"
    set :unicorn_config, "#{current_path}/config/unicorn.rb"
  end

  def start_unicorn
    within current_path do
      execute :bundle, :exec, :unicorn, "-c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)} -D"
    end
  end

  def reload_pid
    # なぜかlオプションつけないと上手く行かなかった。。capistranoでbash -cが走るからとりあえずこれで
    execute "echo `pgrep -lf 'unicorn master' | grep -v pgrep` | cut -d ' ' -f 1 > #{fetch(:unicorn_pid)}"
  end

  def stop_unicorn
    execute :kill, "-s QUIT $(< #{fetch(:unicorn_pid)})"
  end

  def reload_unicorn
    execute :kill, "-s USR2 $(< #{fetch(:unicorn_pid)})"
  end

  def force_stop_unicorn
    execute :kill, "$(< #{fetch(:unicorn_pid)})"
  end

  desc "Start unicorn server"
  task :start => :environment do
    on roles(:web) do
      start_unicorn
    end
  end

  desc "Stop unicorn server gracefully"
  task :stop => :environment do
    on roles(:web) do
      stop_unicorn
    end
  end

  desc "Restart unicorn server gracefully"
  task :restart => :environment do
    on roles(:web) do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        reload_unicorn
      else
        start_unicorn
      end
    end
  end

  desc "Stop unicorn server immediately"
  task :force_stop => :environment do
    on roles(:web) do
      force_stop_unicorn
    end
  end

  desc "reload pid"
  task :reload_pid => :environment do
    on roles(:web) do
      reload_pid
    end
  end

end

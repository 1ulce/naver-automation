require 'slack-notifier'
load "app/models/constant.rb"
load "app/apis/slack_api.rb"
load 'basefile.rb'

# config valid only for Capistrano 3.3.3
lock '3.3.3'

set :application, ENV['APP_NAME']
set :repo_url, "git@github.com:pocketpairjp/#{ENV['GIT_APP_NAME']}.git"
set :deploy_to, "/var/www/#{fetch(:application)}"

# for bundler with rbenv
set :rbenv_ruby, '2.2.2'
set :rbenv_custom_path, '/usr/local/rbenv'

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/sitemaps}
# Default value for keep_releases is 5
# set :keep_releases, 5
application = ENV['APP_NAME']
shared_path = "/var/www/#{application}/shared"
current_path = "/srv/www/#{application}/current"
set :unicorn_pid, "/tmp/unicorn_#{application}.pid"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"


set :assets_roles, [:web, :app]

# for capistrano
# 20151221 webでも回したいcronはある。例えばlogrotation
set :whenever_roles, [:web, :job]

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web) do
      invoke 'unicorn:restart'
    end
    on roles(:job) do
      invoke 'delayed_job:restart'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:web) do
      invoke 'unicorn:stop'
    end
    on roles(:job) do
      invoke 'delayed_job:stop'
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app) do
      invoke 'unicorn:start'
    end
    on roles(:job) do
      invoke 'delayed_job:start'
    end
  end

  desc "Check current branch is on target branch"
  task :check_branch do
    puts "run 'git fetch'"
    `git fetch`
    current_commit = `git rev-parse HEAD`
    target_commit = `git rev-parse origin/#{fetch(:branch)}`
    if current_commit != target_commit
      raise "現在のブランチが origin/#{fetch(:branch)} と一致していません。"
    end
  end

  desc "Check current files doesn't have change"
  task :check_changed_files do
    cmd = "git status --porcelain"
    puts "run command '#{cmd}'"
    res = `#{cmd}`
    if !res.empty?
      if ENV["DEPLOY_FORCE"]
        puts "変更されたファイルが有ります。しかしこのまま実行します"
        puts res
      else
        raise "変更されたファイルが有ります。このままではdeployできません。\nこのままdeployするには DEPLOY_FORCE=true と環境変数を設定して下さい\n"
      end
    end
  end

  desc "Notify finishing deploy"
  task :notify_finish do
    puts "DEPLOY COMPLETED"
    SlackApi.say ("#{ENV['SLACK_APP_NAME']}deployしたよ!")
  end

  desc 'create symlink'
  task :create_symlink do
    invoke 'sitemap_symlink:create'
  end

  after :publishing, :restart
  before :starting, :check_branch
  before :starting, :check_changed_files
  # after :finished, :create_symlink
  after :finished, :notify_finish

#   the command for testing
#   on roles(:web) do
#     execute "/usr/bin/env > /tmp/test"
#   end
end

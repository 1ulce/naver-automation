load 'basefile.rb'

set :stage, :production
set :branch, :production
set :rails_env, :production
set :log_level, :info

front_ip = "pp-developer-#{ENV['APP_NAME']}-prod.ap-northeast-1c"

server front_ip, user: 'ec2-user', roles: %w(web app db)
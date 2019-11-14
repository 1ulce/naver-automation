load 'basefile.rb'

app_name = ENV['APP_NAME']
# Learn more: http://github.com/javan/whenever
set :output, "/var/www/#{app_name}/shared/log/whenever.log"
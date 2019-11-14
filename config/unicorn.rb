load 'basefile.rb'

application = ENV['APP_NAME']

listen "/tmp/unicorn_#{application}.sock"
pid "/tmp/unicorn_#{application}.pid"

# ログ
# if ENV['RAILS_ENV'] == 'production'
# if ENV["RAILS_ENV"] == "production"
  # capistrano 用に RAILS_ROOT を指定
worker_processes 3
working_directory "/var/www/#{application}/current"
shared_path = "/var/www/#{application}/shared"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"
# end

timeout 120

# ダウンタイムなくす
preload_app true

before_fork do |server, worker|
  # workerの数が1以上ならTTOUを送ってworkerを減らす
  # workerの数が1なら古いmasterをkillする
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "/var/www/#{application}/current/Gemfile"
  # 20160127 .envの更新処理を入れる。
  # https://github.com/bkeepers/dotenv/issues/176
  # https://github.com/bkeepers/dotenv/pull/61#issuecomment-31462380
  # http://t-cyrill.hatenablog.jp/entry/2015/03/25/024625
  # girlsclubではdotenv使ってないので、更新すら入れないでいいんじゃないの
  # ENV.update Dotenv::Environment.new('.env')
end
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end

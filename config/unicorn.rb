rails_env = ENV['RACK_ENV'] || 'development'

listen '/tmp/community.socket', backlog: 8192
before_fork do |server, worker|
  FileUtils.touch('/tmp/app-initialized')
end

worker_processes (ENV['UNICORN_WORKER_PROCESSES'] || 3).to_i
timeout 30

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined? ActiveRecord::Base
end

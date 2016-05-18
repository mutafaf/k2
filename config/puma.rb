workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads 1, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 9899
environment ENV['RACK_ENV'] || 'production'
stdout_redirect 'log/puma.log', 'log/puma_error.log', true
on_worker_boot do
  require "active_record"
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection
end
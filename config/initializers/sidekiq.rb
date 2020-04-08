Sidekiq.logger.level = Logger::DEBUG
app_name = Rails.application.class.module_parent.to_s

Sidekiq.configure_server do |config|
  config.redis = {url: "redis://#{ENV['REDIS_HOST']}:6379", namespace: app_name}
end

Sidekiq.configure_client do |config|
  config.redis = {url: "redis://#{ENV['REDIS_HOST']}:6379", namespace: app_name}
end

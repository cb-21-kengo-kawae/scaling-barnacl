Fs::Zeldalogging.configure do |config|
  config.enable_lograge = Settings.lograge.enable
  config.service_name   = Settings.service_name
  config.ignore_actions = ['InformationsController#health_check']
  config.shift_age      = 10
  config.shift_size     = 1024 * 1024 * 512 # 500MB
  config.enable_sentry  = true
  config.sentry_dsn     = Settings.sentry.dsn
  config.sentry_environments = %w[integration staging production]
end

if Rails.env.development?
  Fs::Zeldalogging.logger.extend ActiveSupport::Logger.broadcast(ActiveSupport::Logger.new(STDOUT))
end

Rails.application.config.after_initialize do
  Fs::Zeldalogging.define_logging_controller(
    AccountRecordController, Fs::Zeldalogging.client_logger
  )
end

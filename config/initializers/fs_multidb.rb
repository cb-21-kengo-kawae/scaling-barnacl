Fs::Multidb.configure do |config|
  config.env = Rails.env
  config.short_env = Rails.configuration.short_env
  config.service_name = Settings.service_name
end

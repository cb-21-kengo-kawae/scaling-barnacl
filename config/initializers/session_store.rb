# Be sure to restart your server when you modify this file.

if Rails.env.test?
  Rails.application.config.session_store(
    :cookie_store, key: "_#{Settings.service_name}_#{Rails.configuration.short_env}_session_id"
  )
else
  Rails.application.config.session_store(
    :redis_store,
    key: "_#{Settings.service_name}_#{Rails.configuration.short_env}_session_id",
    servers: {
      host: Settings.redis.session.host,
      port: Settings.redis.session.port,
      db: Settings.redis.session.db,
      password: Settings.redis.session.password,
      namespace: "_#{Settings.service_name}_#{Rails.configuration.short_env}:session"
    },
    expire_after: 60.minutes,
    tld_length: 2
  )
end

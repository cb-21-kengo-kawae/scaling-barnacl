if !Rails.env.development? && !Rails.env.test?
  Rails.application.config.cache_store = :redis_cache_store, {
    host: Settings.redis.cache.host,
    port: Settings.redis.cache.port,
    db: Settings.redis.cache.db,
    password: Settings.redis.cache.password,
    namespace: [
      Settings.service_name,
      Rails.configuration.short_env,
      Settings.version_id,            # Git のコミットハッシュを含める
      '__app__',                      # 衝突を回避する
      'cache'
    ].join('/'),
    expire_after: 10.days             # 1 Sprint
  }

  Rails.cache = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)
end

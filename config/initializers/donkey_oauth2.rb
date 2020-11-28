Donkey::OAuth2.setup do |config|
  config.app_name                   = Settings.service_name
  config.app_id                     = Settings.auth.app_id
  config.app_secret                 = Settings.auth.app_secret
  config.app_redirect_uri           = Settings.auth.app_redirect_uri
  config.app_scopes                 = Settings.auth.app_scopes
  config.api_version                = Settings.services.auth.api_version
  config.relative_url_root          = Settings.services.auth.relative_url_root
  config.private_url                = Settings.private_url
  config.public_url                 = Settings.public_url
  config.platform_relative_url_root = Settings.services.platform.relative_url_root
end

# 動的パラメータ変更の設定ファイルの読み込み
Settings.add_source!(Rails.root.join('config', 'oauth_configs.yml').to_s)
Settings.reload!

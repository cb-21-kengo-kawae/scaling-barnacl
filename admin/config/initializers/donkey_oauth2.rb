Donkey::OAuth2.admin_setup do |config|
  config.app_name          = Settings.service_name
  config.app_id            = Settings.admin.auth.app_id
  config.app_secret        = Settings.admin.auth.app_secret
  config.app_redirect_uri  = Settings.admin.auth.app_redirect_uri
  config.app_scopes        = Settings.admin.auth.app_scopes
  config.relative_url_root = Settings.services.admin.relative_url_root
  config.private_url       = Settings.admin.auth.private_url
  config.public_url        = Settings.admin.auth.public_url
end

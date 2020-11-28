module OauthServiceConfigs
  # DonkeyAuthのサービス情報の切り替えを行うクラス
  class OauthConfigService
    # Settings情報からデフォルトの設定値を生成uthServiceConfigs
    DEFAULT_CONFIG = {
      public_url: Settings.public_url,
      app_id: Settings.auth.app_id,
      app_secret: Settings.auth.app_secret,
      app_redirect_uri: Settings.auth.app_redirect_uri
    }.freeze

    # @params requested_host [String] リクエスト元のホスト名
    def initialize(requested_host)
      @requested_host = requested_host
    end

    # Donkey::OAuth2パラメータを設定
    def set_config
      oauth_config = Settings.oauth_configs.try(:find) { |conf| conf.host == @requested_host }
      oauth_config = DEFAULT_CONFIG if oauth_config.blank?

      # Donkey::OAuth2のパラメータを動的に変更
      Donkey::OAuth2.setup do |config|
        config.public_url = oauth_config[:public_url]
        config.app_id = oauth_config[:app_id]
        config.app_secret = oauth_config[:app_secret]
        config.app_redirect_uri = oauth_config[:app_redirect_uri]
      end
    end
  end
end

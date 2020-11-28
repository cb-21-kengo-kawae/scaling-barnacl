# base controller
class ApplicationController < ActionController::Base
  include LocalizationControllerSupport
  include OauthControllerSupport
  # include Donkey::OAuth2::Controllers::Helpersの前に必要
  before_action :set_auth_config
  include Donkey::OAuth2::Controllers::Helpers
  include Fs::Zeldalogging::Controllers::ExtraLoggable

  protect_from_forgery with: :exception

  rescue_from ActionController::InvalidAuthenticityToken, with: :token_invalid

  before_action :set_locale
  before_action :set_donkey_auth_api_token

  protected

  def set_auth_config
    OauthServiceConfigs::OauthConfigService.new(request.host).set_config
  end

  private

  # セッション認証期限切れなどを含む、未認証のセッションからのアクセスがあった場合、ログイン画面に遷移させる
  #
  # @return [Boolean]
  def handle_unverified_request
    super
  rescue ActionController::InvalidAuthenticityToken => e
    # 通常利用の範囲内で起こる事象のためinfoで設定
    logger.info e
    # リダイレクトする
    return redirect_to Settings.app.after_unverified_request_path \
      if Settings.app.after_unverified_request_path.present?

    raise e
  end

  # ロガー。存在しなければ新規に呼び出す。
  #
  # @return [Fs::Zeldalogging.logger] 共通ロガー
  def logger
    @logger ||= Fs::Zeldalogging.logger
  end
end

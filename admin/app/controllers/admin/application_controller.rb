module Admin
  # ApplicationController for Admin
  class ApplicationController < ActionController::Base
    include LocalizationControllerSupport
    include AdminOauthControllerSupport
    include Donkey::OAuth2::Controllers::AdminHelpers
    include Fs::Zeldalogging::Controllers::ExtraLoggable

    protect_from_forgery with: :exception

    before_action :set_locale

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
      return redirect_to Settings.app.after_unverified_request_auth_path \
        if Settings.app.after_unverified_request_auth_path.present?

      raise e
    end

    # ロガー。存在しなければ新規に呼び出す。
    #
    # @return [Fs::Zeldalogging.logger] 共通ロガー
    def logger
      @logger ||= Fs::Zeldalogging.logger
    end
  end
end

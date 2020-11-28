# LocalizationController Support
module LocalizationControllerSupport
  extend ActiveSupport::Concern
  include ActionController::Cookies

  private

  def set_locale
    cookies[:language] = params[:lang] if params[:lang] && Rails.application.config.i18n.available_locales.member?(params[:lang])

    if cookies[:language]
      I18n.locale = cookies[:language]
      return
    end

    I18n.locale = http_accept_language.compatible_language_from(Rails.application.config.i18n.available_locales)
  end
end

module Ajax
  # Super Class for API
  class ApplicationApiController < ActionController::API
    include ActionController::Cookies
    include OauthControllerSupport
    # include Donkey::OAuth2::Controllers::Helpersの前に必要
    before_action :set_auth_config
    include Donkey::OAuth2::Controllers::Helpers
    include Fs::Zeldalogging::Controllers::ExtraLoggable

    before_action :set_donkey_auth_api_token

    helper_method :operator

    rescue_from Exception, with: :internal_server_error
    rescue_from Donkey::OAuth2::OAuthUnauthorizedError, with: :authorization_required
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def internal_server_error(object = nil)
      render_json(500, object, :fatal)
    end

    def bad_request(object = nil)
      render_json(400, object)
    end

    def not_found(object = nil)
      render_json(404, object)
    end

    def authorization_required(object = nil)
      render_json(401, object)
    end

    # JSONレンダリング
    #
    # @param [Integer] status
    # @param [Object] object
    # @param [Symbol] loglevel
    def render_json(status, object = nil, loglevel = :debug)
      return render_nothing status if object.is_a?(NilClass)
      return render_error status, object, loglevel if Exception >= object.class

      render json: object, status: status
    end

    # エラーレンダリング
    #
    # @param [Integer] status
    # @param [Exception] ex
    # @param [Symbol] loglevel
    def render_error(status, ex, loglevel = :debug)
      Fs::Zeldalogging.logger.send(loglevel, "#{ex.inspect}: [#{ex.backtrace.join('", "')}]")
      render json: { error: ex.class.name, message: ex.message }, status: status
    end

    # Bodyなしレンダリング
    #
    # @param [Integer] status
    def render_nothing(status)
      render nothing: true, status: status
    end

    def set_auth_config
      OauthServiceConfigs::OauthConfigService.new(request.host).set_config
    end
  end
end

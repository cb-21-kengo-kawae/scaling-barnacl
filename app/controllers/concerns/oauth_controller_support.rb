# donkey-oauth2 に関わるヘルパー
module OauthControllerSupport
  extend ActiveSupport::Concern

  included do
    helper_method :operator
  end

  private

  # @return [Struct]
  def operator
    raise NotImplementedError, 'require #current_user_info from donkey-oauth2' unless defined?(current_user_info)

    @operator ||= HashBasedStruct.instance(current_user_info)
  end

  def set_donkey_auth_api_token
    RequestStore.store[:donkey_auth_api_token] = current_token.token
  end
end

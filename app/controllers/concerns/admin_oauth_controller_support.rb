# donkey-oauth2 に関わるヘルパー
module AdminOauthControllerSupport
  extend ActiveSupport::Concern

  included do
    helper_method :admin_operator
  end

  private

  # @return [Struct]
  def admin_operator
    raise NotImplementedError, 'require #current_admin_info from donkey-oauth2' unless defined?(current_admin_info)

    @admin_operator ||= HashBasedStruct.instance(current_admin_info)
  end
end

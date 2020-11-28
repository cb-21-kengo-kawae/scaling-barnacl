module Api
  # Outer API default module
  module Authorizable
    extend ActiveSupport::Concern
    include Donkey::OAuth2::API::GrapeTokenAuth
    include ConnectedAccountRecord
    include ErrorHandling

    included do
      before do
        connect_account_db(current_account_id)
      end

      helpers do
        # 認証ユーザのアカウントIDを返す
        #
        # @return [Integer] data_view_id
        def current_account_id
          current_resource_owner[:current_account_id].presence || nil
        end

        # 認証ユーザのDataViewIDを返す
        #
        # @return [Integer] data_view_id
        def current_view_id
          current_resource_owner[:current_view_id].presence || nil
        end
      end

      rescue_from Donkey::OAuth2::OAuthUnauthorizedError, Donkey::OAuth2::ExpiredTokenError,
                  Donkey::OAuth2::InternalAccessRequired, Donkey::OAuth2::InvalidScopeError do |ex|
        trace_response(ex, 401)
      end
    end
  end
end

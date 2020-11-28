module Ajax
  # AccountRecordAjaxController
  class AccountRecordAjaxController < ApplicationApiController
    include AccountDbConnections::Controllers::Helpers
    include IpRestrictControllerSupport
    include PolicyControllerSupport
    include LocalizationControllerSupport
    include Fs::Resourcekeeper::Helpers::DbConnection

    before_action :set_locale
    before_action :require_authentication
    before_action :connect_account_db
    before_action :restrict_ip_address
    after_action :disconnect_account_db

    rescue_from PolicyControllerSupport::NotAuthorizedError, with: :authorization_required
    rescue_from IpRestrictControllerSupport::NotAuthorizedError, with: :authorization_required
    rescue_from Fs::Multidb::Exceptions::NoDatabaseError, ActiveRecord::NoDatabaseError, with: :multi_db_not_found

    private

    def multi_db_not_found
      reset_current_token
      render json: {}, status: :not_found
    end

    def connect_resourcekeeper_db
      super AccountRecord.account_id
    end
  end
end

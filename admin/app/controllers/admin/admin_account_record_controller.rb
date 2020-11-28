module Admin
  # Super Class to use AccountRecord for Controllers
  class AdminAccountRecordController < BaseController
    include ::Admin::AccountDbConnections::Controllers::Helpers

    before_action :connect_account_db
    after_action :disconnect_account_db

    rescue_from Fs::Multidb::Exceptions::NoDatabaseError, ActiveRecord::NoDatabaseError, with: :multi_db_not_found

    def account_id
      params[:account_id].to_i
    end

    private

    def multi_db_not_found
      redirect_to admin.root_path, alert: 'Database not found.'
    end
  end
end

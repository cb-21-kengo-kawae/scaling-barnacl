# Super Class to use AccountRecord for Controllers
class AccountRecordController < ApplicationController
  include AccountDbConnections::Controllers::Helpers
  include IpRestrictControllerSupport
  include TimezoneControllerSupport
  include PolicyControllerSupport
  include Fs::Resourcekeeper::Helpers::DbConnection

  before_action :require_authentication
  before_action :connect_account_db
  before_action :restrict_ip_address
  around_action :with_time_zone
  after_action :disconnect_account_db

  layout :select_layout

  rescue_from PolicyControllerSupport::NotAuthorizedError, with: :user_not_authorized
  rescue_from IpRestrictControllerSupport::NotAuthorizedError, with: :restrict_access
  rescue_from Fs::Multidb::Exceptions::NoDatabaseError, ActiveRecord::NoDatabaseError, with: :multi_db_not_found

  def connect_resourcekeeper_db
    super current_donkey_user[:current_account_id]
  end

  private

  def current_user_info=(userinfo)
    session[:user_info] = userinfo
    refresh_user_info_key
    session[:user_info]
  end

  def refresh_user_info_key
    cookies[:user_info_key] = { value: SecureRandom.hex(16) }
  end

  def user_not_authorized
    render layout: 'application', template: 'error_pages/page404'
  end

  def restrict_access
    render layout: 'application', template: 'error_pages/page403'
  end

  def render_internal_server_error(exception)
    @exception = exception
    render layout: 'application', template: 'error_pages/page500'
  end

  def multi_db_not_found
    reset_current_token
    head :not_found
  end
end

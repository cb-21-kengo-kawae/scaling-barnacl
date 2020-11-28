# vue application controller
class VueApplicationController < ApplicationController
  include IpRestrictControllerSupport
  include TimezoneControllerSupport
  include PolicyControllerSupport

  before_action :require_authentication
  before_action :restrict_ip_address

  around_action :with_time_zone

  rescue_from PolicyControllerSupport::NotAuthorizedError, with: :user_not_authorized
  rescue_from IpRestrictControllerSupport::NotAuthorizedError, with: :restrict_access
  rescue_from Fs::Multidb::Exceptions::NoDatabaseError, ActiveRecord::NoDatabaseError, with: :multi_db_not_found

  def index; end

  private

  def user_not_authorized
    render layout: 'application', template: 'error_pages/page404', status: :not_found
  end

  def restrict_access
    render layout: 'application', template: 'error_pages/page403', status: :forbidden
  end

  def multi_db_not_found
    reset_current_token
    head :not_found
  end
end

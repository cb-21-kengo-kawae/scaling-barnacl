require_dependency 'admin/application_controller'

module Admin
  # BaseController for Admin
  class BaseController < ApplicationController
    include Pundit
    before_action :require_admin_authentication

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def pundit_user
      admin_operator
    end

    private

    def user_not_authorized
      redirect_to admin.root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end

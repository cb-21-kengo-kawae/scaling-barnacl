require_dependency 'admin/application_controller'

module Admin
  # SessionsController for Admin
  class SessionsController < BaseController
    def destroy
      admin_unauthenticate!
      redirect_to admin_unauthorize_path, notice: 'Logout successfully.'
    end
  end
end

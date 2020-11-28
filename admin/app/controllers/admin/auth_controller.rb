require_dependency 'admin/application_controller'

module Admin
  # AuthController for Admin
  class AuthController < ApplicationController
    def callback
      store_admin_token
      redirect_to stored_admin_location || dashboard_index_path, notice: 'login successfully'
      session[:admin_return_to] = nil
    end
  end
end

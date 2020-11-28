require_dependency 'admin/application_controller'

module Admin
  # DashboardController for Admin
  class DashboardController < BaseController
    def index
      authorize :dashboard, :index?
    end
  end
end

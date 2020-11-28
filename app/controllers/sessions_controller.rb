# controller for session
class SessionsController < ApplicationController
  before_action :require_authentication

  def destroy
    unauthenticate!

    if request.xhr?
      render status: :ok, json: { redirect_url: unauthorize_path }
    else
      redirect_to unauthorize_path, notice: 'Logout successfully.'
    end
  end
end

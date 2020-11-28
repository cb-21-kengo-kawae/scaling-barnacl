# controller for authorization
class AuthController < ApplicationController
  def callback
    store_token
    redirect_to stored_location || loggedin_path, notice: 'login successfully'
    session[:user_return_to] = nil
  end
end

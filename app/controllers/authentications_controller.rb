class AuthenticationsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    @authentication = Authentication.new
    @authentication.user_id = current_user.id
    @authentication.provider = auth["provider"]
    @authentication.uid = auth["uid"]
    @authentication.save  
  end
    
end

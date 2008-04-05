class PublicController < ApplicationController
  skip_before_filter :login_required
  
  def index
    # check if user should be logged in
    if !session[:user_id].nil?
      redirect_to home_path
    elsif !cookies[:user_id].nil? and !cookies[:password_hash].nil?
      user = User.find(cookies[:user_id])
      if user.password_hash != cookies[:password_hash]
        user = nil
      else
        redirect_to home_path
      end
    end
  end
  
  def screencast
  end
  
end

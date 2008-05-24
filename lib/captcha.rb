module Captcha
  def self.included(base)
    base.send :helper_method, :set_captcha, :clear_captcha, :captcha_passed?
  end
  
  protected
  
  # Handle the captcha on user login
  def set_captcha
    session[:captcha] = rand(10) + 20
    @captcha = rand(session[:captcha])
  end
  
  def clear_captcha
    session[:captcha] = nil
  end
  
  def captcha_passed?
    return false if session[:captcha].nil? or params[:captcha].nil?
    params[:captcha].to_i == session[:captcha]
  end
  
end
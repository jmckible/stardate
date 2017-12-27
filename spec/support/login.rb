def login_as(name)
  @current_user = users(name)
  @request.session[:user_id] = @current_user.id
  cookie :user_id, @current_user.id
  cookie :password_hash, @current_user.password_hash
end

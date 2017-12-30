def login_as(name)
  @current_user = users(name)

  if @request # controller
    @request.session[:user_id] = @current_user.id
    cookie :user_id, @current_user.id
    cookie :password_hash, @current_user.password_hash
  else # request
    post sessions_url, params: { email: @current_user.email, password: 'test' }
    expect(response).to redirect_to(root_url)
    follow_redirect!
  end
end

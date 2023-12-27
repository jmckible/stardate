def login_as(name)
  @current_user = users(name)

  post sessions_url, params: { email: @current_user.email, password: 'test' }
  expect(response).to redirect_to(root_url)
  follow_redirect!
end

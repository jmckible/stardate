def cookie(name, value)
  @request.cookies[name.to_s] = CGI::Cookie.new name.to_s, value.to_s
end

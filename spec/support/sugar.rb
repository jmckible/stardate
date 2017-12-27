def running(&block)
  lambda &block
end

# I do no like how params: is a required keyword argument
def gt(action, params = {})
  get url_for(action), params: params
end

def pst(action, params = {})
  post url_for(action), params: params
end

def ptch(action, params = {})
  patch url_for(action), params: params
end

def del(action, params = {})
  delete url_for(action), params: params
end

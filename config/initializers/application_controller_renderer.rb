ActiveSupport::Reloader.to_prepare do

  case Rails.env
  when 'production'
    options = { http_host: 'stardate.herokuapp.com', https: true }
  else
    options = { http_host: 'stardate.test', https: true }
  end

  ApplicationController.renderer.defaults.merge! options
  Rails.application.routes.default_url_options[:host] = options[:http_host]
  Rails.application.routes.default_url_options[:protocol] = 'https'

end

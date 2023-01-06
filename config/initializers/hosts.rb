case Rails.env
when 'development'
  Rails.application.config.hosts << 'stardate.test' # iPhone
when 'test'
  Rails.application.config.hosts << 'www.example.com'
  Rails.application.config.hosts << 'stardate.test'
when 'production'
  Rails.application.config.hosts << 'stardate.fly.dev'
end

# Rails.application.config.hosts = nil

# Webpacker::Compiler.env['ORIGIN'] = "https://#{Rails.application.config.hosts.last}"

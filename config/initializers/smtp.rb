begin
  require 'smtp_tls'

  mail_yml = YAML.load_file(RAILS_ROOT+'/config/mail.yml')
  mail_env = mail_yml[ENV['RAILS_ENV']]

  ActionMailer::Base.smtp_settings = {
    :authentication => mail_env['authentication'],
    :address        => mail_env['address'],
    :port           => mail_env['port'],
    :user_name      => mail_env['user_name'],
    :password       => mail_env['password']
  }

rescue Errno::ENOENT
  $stderr.puts '[WARN] Missing config/mail.yml. Mail will not be sent.'
end
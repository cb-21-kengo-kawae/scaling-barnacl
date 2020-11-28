env_upcase = Rails.env.upcase

conf_name = ['CONF', env_upcase].join('_')
service_conf_name = [
  'CONF', Settings.service_name.upcase, env_upcase
].join('_')

[conf_name, service_conf_name].each do |conf_name|
  additional_env = ENV[conf_name]
  next unless additional_env

  Settings.merge!(JSON.parse additional_env)
end

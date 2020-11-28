if Rails.env.development? || Rails.env.test?
  Aws.config[:s3] = { endpoint: Settings.s3.endpoint, force_path_style: true }
end

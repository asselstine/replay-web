if Rails.env.development? || Rails.env.production?
  Aws.config.update(
      region: Figaro.env.aws_region,
      credentials: Aws::Credentials.new(Figaro.env.aws_access_key_id, 
                                        Figaro.env.aws_secret_access_key)
  )
end

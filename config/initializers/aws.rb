if Rails.env.development? || Rails.env.production?
  AWS.config(access_key_id: Figaro.env.aws_access_key_id, 
             secret_access_key: Figaro.env.aws_secret_access_key)
end

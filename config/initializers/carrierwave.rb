CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
        provider: 'AWS',
        region: Figaro.env.aws_region,
        aws_access_key_id: Figaro.env.aws_access_key_id,
        aws_secret_access_key: Figaro.env.aws_secret_access_key
    }
    config.fog_public = false
    config.fog_directory = Figaro.env.aws_s3_bucket
    config.fog_authenticated_url_expiration = 86400
    # config.asset_host = 'http://d17qcvydnnr06b.cloudfront.net'
  else
    config.storage = :file
  end
  if Rails.env.test?
    Fog.mock!
  end
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end

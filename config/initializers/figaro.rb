Figaro.require_keys(%w(google_maps_browser_key
                       aws_access_key_id
                       aws_secret_access_key
                       aws_region
                       aws_s3_bucket))
if Rails.env.production?
  Figaro.require_keys(%w(strava_client_id
                         strava_api_key
                         aws_et_pipeline_id
                         aws_et_sns_topic_arn
                         rollbar_server_access_token
                         rollbar_client_access_token
                         host))
end

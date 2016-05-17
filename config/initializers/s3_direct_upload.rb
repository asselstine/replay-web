S3DirectUpload.config do |c|
  c.access_key_id = Figaro.env.aws_access_key_id
  c.secret_access_key = Figaro.env.aws_secret_access_key
  c.bucket = Figaro.env.aws_s3_bucket
  # c.region = Figaro.env.aws_region
  # c.url = "https://#{c.bucket}.s3.amazonaws.com"
end

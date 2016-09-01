module S3
  def key_to_url(key)
    'https://s3.amazonaws.com/'\
    "#{Figaro.env.aws_s3_bucket}/#{key}"
  end
end

module S3
  def self.get(key, filepath)
    s3 = Aws::S3::Client.new
    File.open(filepath, 'wb') do |file|
     s3.get_object({bucket: Figaro.env.aws_s3_bucket, key: key}, target: file)
    end 
  end
  def self.upload(filepath, key)
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(bucket).object(key) 
    obj.upload_file(filepath)
  end
  def self.url(key)
    "https://s3.amazonaws.com/#{Figaro.env.aws_s3_bucket}/#{key}"
  end
  def self.bucket
    Figaro.env.aws_s3_bucket
  end
end


module ElasticTranscoder
  def self.client
    Aws::ElasticTranscoder::Client.new(region: Figaro.env.aws_region)
  end
end

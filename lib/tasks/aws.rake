desc 'AWS Services'
namespace :aws do
  desc 'Elastic Transcoder'
  namespace :et do
    desc 'Subscribe'
    task subscribe: :environment do
      topic = Aws::SNS::Topic.new(Figaro.env.aws_et_sns_topic_arn)
      sns_endpoint = Rails.application.routes.url_helpers.sns_url
      protocol = /https?/.match(sns_endpoint)[0]
      msg = <<-STRING
          Subscribing to SNS ARN #{Figaro.env.aws_et_sns_topic_arn}
          with protocol: #{protocol}
          with endpoint: #{sns_endpoint}")
      STRING
      Rails.logger.debug msg
      puts msg
      response = topic.subscribe(protocol: protocol, endpoint: sns_endpoint)
      msg = <<-STRING
        Response: #{response.inspect}
      STRING
      Rails.logger.debug msg
      puts msg
    end
    task update_all: :environment do
      Video.update_et_all
    end
  end
end

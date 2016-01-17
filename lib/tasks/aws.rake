desc 'AWS Services'
namespace :aws do
  desc 'Elastic Transcoder'
  namespace :et do
    desc 'Subscribe'
    task subscribe: :environment do
      sns_endpoint = Rails.application.routes.url_helpers.sns_url
      topic = AWS::SNS::Topic.new( Figaro.env.aws_et_sns_topic_arn )
      topic.subscribe(sns_endpoint)
      Rails.logger.debug("Subscribing to SNS ARN #{Figaro.env.aws_et_sns_topic_arn} with endpoint: #{sns_endpoint}")
    end
    task update_all: :environment do
      Video.update_et_all
    end
  end
end

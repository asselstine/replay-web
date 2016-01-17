class SnsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def message 
    msg = ::AWS::SNS::Message.new(request.body.read)
    if msg.authentic?
      logger.debug("SNS: Received message: #{msg.message}")
      if msg.subscribe_url && msg.token
        topic = ::AWS::SNS::Topic.new(Figaro.env.aws_et_sns_topic_arn)
        response = topic.confirm_subscription(msg.token)
        logger.debug("SNS: Confirmed subscription for topic: #{Figaro.env.aws_et_sns_topic_arn}: #{response}")
      else
        json = JSON.parse(msg.message)
        logger.debug("SNS: Message is for job: #{json['jobId']} with state #{json['state']}")
        video = Video.where(job_id: json['jobId']).first
        if video
          video.update_et
        else
          logger.debug("No Video for job id #{json['jobId']}")
        end
      end
    end 
    render nothing: true, status: 200, content_type: 'text/html'
  end
end

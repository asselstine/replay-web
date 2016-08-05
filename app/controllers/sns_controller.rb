class SnsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/LineLength
  # rubocop:disable Metrics/AbcSize
  def message
    body = request.body.read
    if Aws::SNS::MessageVerifier.new.authentic?(body)
      json = JSON.parse(body)
      Rails.logger.debug("SNS: Received message: #{json}")
      if json['Token']
        topic = ::Aws::SNS::Topic.new(Figaro.env.aws_et_sns_topic_arn)
        response = topic.confirm_subscription(token: json['Token'])
        Rails.logger.debug("SNS: Confirmed subscription for topic: #{Figaro.env.aws_et_sns_topic_arn}: #{response}")
      else
        msg = JSON.parse(json['Message'])
        Rails.logger.debug("SNS: Message is for job: #{msg['jobId']} with state #{msg['state']}")
        video = Video.where(job_id: msg['jobId']).first
        if video
          video.update_et
        else
          Rails.logger.debug("No Video for job id #{msg['jobId']}")
        end
      end
    end
    render nothing: true, status: 200, content_type: 'text/html'
  end
end

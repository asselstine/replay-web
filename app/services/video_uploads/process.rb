module VideoUploads
  class Process
    include Service
    include Virtus.model

    attribute :video_upload, VideoUpload

    def call
      video = @video_upload.create_video!(
        user: @video_upload.user,
        filename: @video_upload.filename,
        file: self.class.url_to_s3_key(@video_upload.url)
      )
      @video_upload.save
      job = video.jobs.create!(output_type: :web)
      Jobs::Start.call(job: job) if job.persisted?
    end

    def self.url_to_s3_key(url)
      uri = URI(url)
      uri.path.gsub("/#{Figaro.env.aws_s3_bucket}/", '')
    end
  end
end

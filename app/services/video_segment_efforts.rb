class VideoSegmentEfforts
  include Virtus.model
  include Service

  attribute :video_upload, VideoUpload

  def call
    ActiveRecord::Base.transaction do
      # gather all the activities during the video upload
      selectors.each do |selector|
        Edit::FrameSeries.call(
          processor: video_processor(selector),
          start_at: video_upload.video.start_at,
          end_at: video_upload.video.end_at
        )
      end
      @video_processor.video_drafts.each(&:save)
    end
  end

  def video_processor(selector)
    @video_processor ||= Edit::FrameProcessors::VideoProcessor.new(
      video_drafting_strategy: strategy
    )
    @video_processor.selector = selector
    @video_processor
  end

  def strategy
    @strategy ||= Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy.new
  end

  def selectors
    VideoUploadSelectors.call(video_upload: video_upload)
  end
end

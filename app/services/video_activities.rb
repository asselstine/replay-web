class VideoSegmentEfforts
  include Virtus.model
  include Service

  attribute :video_upload, VideoUpload

  def call
    processor = video_processor
    ActiveRecord::Base.transaction do
      # gather all the activities during the video upload
      selectors.each do |selector|
        processor.selector = selector
        Edit::FrameSeries.call(
          processor: processor,
          start_at: video_upload.video.start_at,
          end_at: video_upload.video.end_at
        )
      end
      processor.video_drafts.each(&:save!)
    end
    processor.video_drafts
  end

  def video_processor
    Edit::FrameProcessors::VideoProcessor.new(
      video_drafting_strategy: strategy
    )
  end

  def strategy
    Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy.new
  end

  def selectors
    Edit::VideoUploadSegmentSelectors.call(video_upload: video_upload)
  end
end

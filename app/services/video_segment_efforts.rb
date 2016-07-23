class VideoSegmentEfforts
  include Virtus.model
  include Service

  attribute :video_upload, VideoUpload

  def call
    ActiveRecord::Base.transaction do
      
    end
  end
end

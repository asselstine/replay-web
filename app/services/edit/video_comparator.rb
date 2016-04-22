# rubocop:disable Style/ClassAndModuleChildren
class Edit::VideoComparator < Edit::Comparator
  attribute :upload, Upload

  def compute_strength(frame)
    @strength = if upload_during_frame?(frame)
                  distance_strength(frame)
                else
                  0
                end
  end

  protected

  def upload_during_frame?(frame)
    @upload = setup.uploads_during(frame).first
    @upload.present?
  end
end

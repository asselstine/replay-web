class Video < ActiveRecord::Base
  include QuasiCarrierWave

  belongs_to :thumbnail, class_name: Photo
  belongs_to :user
  belongs_to :source_video, class_name: 'Video'

  has_many :videos, inverse_of: :source_video
  has_many :video_drafts
  has_many :scrub_images

  has_many :playlists,
           -> { merge(Job.complete).order(created_at: :desc) },
           through: :jobs
  has_many :jobs

  has_many :web_jobs, -> { merge(Job.web) }, class_name: 'Job'
  has_many :web_outputs,
           -> { merge(Job.complete) },
           through: :web_jobs, source: :outputs, class_name: 'Output'

  validates_presence_of :file
  validates_presence_of :user

  scope :during, (lambda do |start_at, end_at|
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order(start_at: :asc)
  end)

  def source_filename_no_ext
    File.basename(source_key, File.extname(source_key))
  end

  def file_url
    return "/#{source_key}" if Rails.env.test?
    fog_file_from_key(source_key).public_url
  end

  def uploader_class
    DirectUploader
  end

  def vertical_resolution
    720 # resolution.split('x').last.to_i
  end

  def source_key
    file.sub(%r{^\/}, '')
  end

  def duration
    return 0 unless start_at && end_at
    end_at - start_at
  end
end

class Video < ActiveRecord::Base 

  STATUS_SUBMITTED = 'Submitted'
  STATUS_PROGRESSING = 'Progressing'
  STATUS_CANCELED = 'Canceled'
  STATUS_ERROR = 'Error'
  STATUS_COMPLETE = 'Complete'

  scope :incomplete, -> {
    where.not(:status => [STATUS_COMPLETE, STATUS_ERROR, STATUS_CANCELED])
  }

  validates_presence_of :source_key
  validate :normalize_source_key

  belongs_to :camera, inverse_of: :videos

  before_create :queue_et_job, unless: 'Rails.env.test?' 

  def complete?
    self.status == STATUS_COMPLETE
  end

  def self.during(start_at, end_at)
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order('start_at ASC')
  end

  def self.containing(start_at, end_at = start_at)
    where('start_at <= ? AND end_at >= ?', start_at, end_at)
  end

  def self.update_et_all
    Video.incomplete_jobs.each do |vu|
      vu.update_et
    end
  end

  def normalize_source_key
    source_key.sub!(/^\//, '')
  end

  def copy_to(file)
  end

  def update_et
    transcoder_client = et_client 
    response = transcoder_client.read_job( { id: job_id } )
    data = response.data
    attrs = {
        :status => data[:job][:output][:status],
        :duration_ms => (data[:job][:output][:duration] || 0).to_i * 1000,
        :message => data[:job][:output][:status_detail]
    }
    update_attributes(attrs)
  end

  def key_to_url(key)
    "https://s3.amazonaws.com/#{Figaro.env.aws_s3_bucket}/#{output_key_prefix}#{key}"
  end

  def webm
    "#{output_key_prefix}#{webm_key}"
  end

  def webm_key
    'webm/' + output_key + ".webm"
  end

  def mp4
    "#{output_key_prefix}#{mp4_key}"
  end

  def mp4_key
    'mp4/' + output_key + ".mp4"
  end

  def output_key_prefix
    'et/'
  end

  def output_key 
    Digest::SHA256.hexdigest(source_key.encode('UTF-8'))
  end

  def queue_et_job 
    transcoder_client = et_client
    outputs = [
        {
          key: webm_key,
          preset_id: '1351620000001-100240',
        },
        {
            key: mp4_key,
            preset_id: '1351620000001-100070'
        }
    ]
    response = transcoder_client.create_job(
        pipeline_id: Figaro.env.aws_et_pipeline_id,
        input: { key: source_key },
        output_key_prefix: output_key_prefix,
        outputs: outputs)
    self.job_id = response[:job][:id]
    self.webm_url = key_to_url(webm_key)
    self.mp4_url = key_to_url(mp4_key) 
  end

  protected

  def et_client
    @_et_client ||= Aws::ElasticTranscoder::Client.new(region: Figaro.env.aws_region)
  end
end

module Outputs
  class BuildWeb
    include Service
    include Virtus.model

    attribute :job, Job

    def call
      job.outputs.build(
        key: 'generic_720p.mp4',
        preset_id: '1351620000001-000010',
        container_format: 'mp4',
        thumbnail_pattern: 'thumb-{count}',
        thumbnail_interval_s: 60,
        thumbnail_format: 'png'
      )
    end
  end
end

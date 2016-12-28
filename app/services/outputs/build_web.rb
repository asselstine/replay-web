module Outputs
  class BuildWeb
    include Service
    include Virtus.model

    attribute :job, Job

    def call
      job.outputs.build(
        key: 'generic_720p',
        preset_id: '1351620000001-000010'
      )
    end
  end
end

require 'rails_helper'

RSpec.describe ProcessUploadJob do
  describe '#url_to_s3_key' do
    it 'should strip the url down to the key' do
      url = "http://alsdfkj.com/#{Figaro.env.aws_s3_bucket}/asdf/qwer"
      expect(ProcessUploadJob.url_to_s3_key(url)).to eq('asdf/qwer')
    end
  end
end

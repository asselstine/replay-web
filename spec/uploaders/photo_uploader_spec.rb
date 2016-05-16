require 'rails_helper'

describe PhotoUploader do
  subject { PhotoUploader.new }

  describe '#set_exif_data' do
    let(:file) { double('Unknown') }
    let(:model) { double(Photo) }
    let(:filepath) { Rails.root.join('spec/fixtures/1x1_gps.jpg') }
    it do
      expect(file).to receive(:to_file).and_return(File.new(filepath)).exactly(2).times
      expect(subject).to receive(:file).and_return(file).exactly(2).times
      expect(subject).to receive(:model).and_return(model)
      expect(subject).to receive(:current_path).and_return(filepath)
      expect(model).to receive(:filename=).with('1x1_gps.jpg')
      expect(model).to receive(:timestamp)
      expect(model).to receive(:timestamp=)
      expect(model).to receive(:exif_latitude=).with(50.860361)
      expect(model).to receive(:exif_longitude=).with(14.273586)
      subject.send(:set_exif_data)
    end
  end
end

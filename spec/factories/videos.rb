FactoryGirl.define do 
  factory :video do
    start_at DateTime.now
    end_at {
      start_at.since(1)
    }
    source_key 'uploads/to_here.mp3'
  end
end


FactoryGirl.define do 
  factory :video do
    start_at DateTime.now
    end_at {
      start_at.since(1)
    }
  end
end


Before '@chrome' do
  Capybara.javascript_driver = :chrome
end

Before '@poltergeist' do
  Capybara.javascript_driver = :poltergeist
end

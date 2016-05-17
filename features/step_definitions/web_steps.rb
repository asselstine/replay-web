Given %(I've been somewhere) do
  @activity = create(:activity,
                     user: @user,
                     timestamps: Array.new(10) { |i| Time.zone.now.since(i) },
                     latitudes: Array.new(10) { |i| i / 100.0 },
                     longitudes: Array.new(10) { |i| i / 100.0 })
end

When %(pry) do
  binding.pry
end

When %(I go to settings) do
  click_link 'Settings'
end

Given %(I'm logged in) do
  @user ||= create(:user)
  visit new_user_session_path
  fill_in :user_email, with: @user.email
  fill_in :user_password, with: 'password'
  click_link_or_button 'Log in'
  expect(page).to have_content 'Sign Out'
end

Then %(the record should have been updated) do
  expect(page).to have_content(I18n.t('flash.activerecord.update.success'))
end

Then %(the record should have been created) do
  expect(page).to have_content(I18n.t('flash.activerecord.create.success'))
end

When %(I see the success message "$message") do |message|
  within 'ul.messenger .success' do
    expect(page).to have_content(message)
    find('button.messenger-close').click
  end
end

# rubocop:disable Metrics/AbcSize
def react_select(selector, label)
  within selector do
    find('.Select-control').click
    find('input').set label
    expect(page).to have_css('.Select-option', text: label)
    find('.Select-option', text: label).hover
    expect(page).to have_css('.Select-option', text: label)
    find('.Select-option', text: label).click
    expect(page).to have_css('.Select-value-label', text: label)
  end
end

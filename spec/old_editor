require 'rails_helper'

RSpec.describe 'ShotStrategy' do

  def given_there_are_two_cameras
    given_there_is_a_camera
    @camera2 = create(:camera)
  end

  def given_there_is_a_camera
    @camera1 = create(:camera)
  end

  def and_i_am_closer_to_the_first_camera
    @lat = @camera1.lat - (@camera1.lat - @camera2.lat) * 0.3
    @long = @camear1.long - (@camera1.long - @camera2.long) * 0.3
  end

  def then_the_first_camera_shot_should_be_stronger_than_the_second
    expect(@camera1.strength(@lat,@long)).to be < @camera2.strength(@lat, @long)
  end

  def when_i_am_very_far_away_from_the_camera
    @lat = @camera1.lat + 90.0
    @long = @camera1.long + 160.0
  end

  def then_there_should_still_be_shot_strength
    expect(@camera1.strength(@lat,@long)).to be > 0
  end

  describe 'Position' do
    it 'should be stronger for cameras that are closer' do
      given_there_are_two_cameras
      and_i_am_closer_to_the_first_camera
      then_the_first_camera_shot_should_be_stronger_than_the_second
    end
    it 'should have an infinite distance' do
      given_there_is_a_camera
      when_i_am_very_far_away_from_the_camera
      then_there_should_still_be_shot_strength
    end
  end
end

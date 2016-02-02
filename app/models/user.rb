class User < ActiveRecord::Base
  include Trackable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :edits
  has_many :photos
  has_many :rides
  has_many :locations, through: :rides
  has_many :recording_sessions
  has_one :strava_account

  accepts_nested_attributes_for :photos

  def feed_photos
    photos = []
    return photos if feed_start_at.nil? || feed_end_at.nil?
    context = Context.new(start_at: feed_start_at,
                          end_at: feed_end_at,
                          user: self)
    loop do
      photos += feed_photos_during(context)
      break unless context.next!
    end
    photos
  end

  def feed_photos_during(context)
    photos = []
    user_eval = evaluator(context)
    Camera.all.each do |camera|
      if camera.evaluator(context).strength(user_eval) >= Camera::MIN_STRENGTH
        photos += camera.photos.during(context.cut_start_at, context.cut_end_at)
      end
    end
    photos
  end

  def feed_start_at
    locations.with_timestamp.order(timestamp: :asc).first.try(:timestamp)
  end

  def feed_end_at
    locations.with_timestamp.order(timestamp: :desc).first.try(:timestamp)
  end

  def evaluator(context = Context.new)
    UserEvaluator.new(user: self, context: context)
  end
end

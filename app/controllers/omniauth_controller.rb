class OmniauthController < Devise::OmniauthCallbacksController
  def strava
    oauth = request.env['omniauth.auth']
    uid = oauth['uid']
    strava = StravaAccount.where(uid: uid).first_or_create({
      uid: uid,
      token: oauth['credentials']['token'],
      username: oauth['extra']['raw_info']['username'],
      user: current_user
    })
    if strava.persisted?
      set_flash_message :notice, :success, :kind => 'Strava' if is_navigational_format?
      redirect_to settings_path
    else
      flash[:error] = "Could not connect to Strava"
      redirect_to :back 
    end
  end

  def dropbox_oauth2

    email = request.env['omniauth.auth']['info']['email']

    user = User.where(:email => email).first_or_create do |user|
      user.email = email
      user.password = Devise.friendly_token[0,20]
      user.access_token = request.env['omniauth.auth']['credentials']['token']
      user.save
    end

    if user.persisted?
      set_flash_message :notice, :success, :kind => 'Dropbox' if is_navigational_format?
      sign_in_and_redirect user, :event => :authentication
    else
      flash[:error] = "Could not login to Dropbox"
      redirect_to '/'
    end

  end
end

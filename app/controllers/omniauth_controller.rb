class OmniauthController < Devise::OmniauthCallbacksController
  def strava
    strava = find_or_create_strava_account(request.env['omniauth.auth'])
    if user_signed_in?
      complete_strava_connect(strava)
    else
      complete_strava_sign_in(strava)
    end
  end
  #
  # def dropbox_oauth2
  #   email = request.env['omniauth.auth']['info']['email']
  #   new_user = User.where(email: email).first_or_create do |user|
  #     user.email = email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.access_token = request.env['omniauth.auth']['credentials']['token']
  #     user.save
  #   end
  #   if new_user.persisted?
  #     set_flash_message :notice, :success,
  #                       kind: 'Dropbox' if is_navigational_format?
  #     sign_in_and_redirect new_user, event: :authentication
  #   else
  #     flash[:error] = 'Could not login to Dropbox'
  #     redirect_to '/'
  #   end
  # end

  def find_or_create_strava_account(oauth)
    StravaAccount.where(uid: oauth['uid']).first_or_create(
      uid: oauth['uid'],
      token: oauth['credentials']['token'],
      username: oauth['extra']['raw_info']['username'],
      user: find_or_create_user(oauth)
    )
  end

  def find_or_create_user(oauth)
    if user_signed_in?
      current_user
    else
      generated_password = Devise.friendly_token.first(8)
      User.where(email: oauth['info']['email']).first_or_create(
        email: oauth['info']['email'],
        password: generated_password,
        password_confirmation: generated_password
      )
    end
  end

  private

  def complete_strava_connect(strava)
    set_flash_message :notice, :success,
                      kind: 'Strava' if is_navigational_format?
    SynchronizeJob.perform_later user_id: strava.user.id
    redirect_to settings_path
  end

  def complete_strava_sign_in(strava)
    set_flash_message :notice, :success,
                      kind: 'Strava' if is_navigational_format?
    sign_in_and_redirect strava.user, event: :authentication
  end
end

class OmniauthController < Devise::OmniauthCallbacksController
  def dropbox_oauth2

    email = request.env['omniauth.auth']['info']['email']

    user = User.where(:email => email).first_or_create do |user|
      user.email = email
      user.password = Devise.friendly_token[0,20]
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

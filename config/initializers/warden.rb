Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  Synchronize.call(user: user)
end

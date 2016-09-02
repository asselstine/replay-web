Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  SynchronizeJob.perform_later user_id: user.id
end

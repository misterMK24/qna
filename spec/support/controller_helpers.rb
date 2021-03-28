module ControllerHelpers
  # for Devise
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user] # for Warden
    sign_in(user)
  end
end

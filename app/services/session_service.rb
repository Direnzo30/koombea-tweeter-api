class SessionService < BaseService

  def initialize(current_user = nil)
    super(current_user)
  end

  def signup(params)
    flat_endpoint do
      user = User.new(params)
      raise ActiveRecord::RecordInvalid.new(user) unless user.valid?
      user.save!
      { content: { user_id: user.id }}
    end
  end

  def signin(params)
    flat_endpoint do
      raise RequiredParamExecption.new("username") unless params[:username].present?
      raise RequiredParamExecption.new("password") unless params[:password].present?
      logged_user = User.find_by("lower(username) = ?", params[:username].squish.downcase)
      raise PersonalizedException.new("Credentials are not valid", :bad_request) unless logged_user.present?
      raise PersonalizedException.new("Credentials are not valid", :bad_request) unless logged_user.authenticate(params[:password]).present?
      logged_user.assign_auth_token!
      { content: logged_user }
    end
  end

  def signout
    flat_endpoint do
      @current_user.authorization_token = nil
      @current_user.token_lifetime = nil
      @current_user.save!
      { content: { success: true } }
    end
  end

end
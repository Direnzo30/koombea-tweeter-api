# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  authorization_token :string
#  email               :string           not null
#  first_name          :string           not null
#  last_name           :string           not null
#  password_digest     :string           not null
#  token_lifetime      :datetime
#  username            :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_authorization_token  (authorization_token)
#  index_users_on_email                (email) UNIQUE
#  index_users_on_username             (username) UNIQUE
#
class User < ApplicationRecord

  TOKEN_LENGTH = 32
  TOKEN_EXPIRACY = 30.days

  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :authorization_token, allow_blank: true, uniqueness: { case_sensitive: false }

  include EndpointsHandler

  def self.signup(params)
    flat_endpoint do
      user = User.new(params)
      raise ActiveRecord::RecordInvalid.new(user) unless user.valid?
      user.save!
      { content: { user_id: user.id }}
    end
  end

  def self.signin(params)
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

  def self.signout(user)
    flat_endpoint do
      user.authorization_token = nil
      user.token_lifetime = nil
      user.save!
      { content: { success: true } }
    end
  end

  def assign_auth_token!
    # Make sure token is unique
    while true
      self.authorization_token = SecureRandom.base64(TOKEN_LENGTH)
      self.token_lifetime = Time.now().utc() + TOKEN_EXPIRACY
      break if self.valid? 
    end
    self.save!
  end
end

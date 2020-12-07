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

  has_many :tweets
  has_many :followed_users,  :class_name => "Follow", :foreign_key => "user_id"
  has_many :following_users, :class_name => "Follow", :foreign_key => "followed_id"

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

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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe "ActiveModel Validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to have_secure_password }
  end

  describe "ActiveRecord Validations" do
    it { is_expected.to have_many(:tweets) }
    it { is_expected.to have_many(:followed_users) }
    it { is_expected.to have_many(:following_users) }
    it { is_expected.to have_db_column(:authorization_token).of_type(:string) }
    it { is_expected.to have_db_index(:authorization_token) }
    it { is_expected.to have_db_column(:token_lifetime).of_type(:datetime) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to have_db_index(:username).unique }
  end

end

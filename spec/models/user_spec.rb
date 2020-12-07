require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  let(:signup_params) { 
    {
      first_name: Faker::Name.first_name,
      last_name:  Faker::Name.last_name,
      username:   Faker::Internet.username,
      email:      Faker::Internet.safe_email,
      password:   Faker::Internet.password 
    }
  }

  let(:wrong_signup_params) {
    {
      first_name: "",
      last_name:  "",
      username:   "",
      email:      "",
      password:   "" 
    }
  }

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

  describe '::signup' do
    context "when some parameters are not valid" do
      it "doesn't sign up" do
        response, code = User.signup(wrong_signup_params)
        expect(code).to eq(:unprocessable_entity)
        expect(response[:content]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end

    context "when all parameters are valid" do
      it "signs up" do
        response, code = User.signup(signup_params)
        expect(code).to eq(:ok)
        expect(response[:error]).to be_nil
        expect(response[:content][:user_id]).not_to be_nil
      end
    end

    context "when email already exists" do
      it "doesn't sign up" do
        signup_params[:email] = subject.email
        response, code = User.signup(signup_params)
        expect(code).to eq(:unprocessable_entity)
        expect(response[:content]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end

    context "when username already exists" do
      it "doesn't sign up" do
        signup_params[:username] = subject.username
        response, code = User.signup(signup_params)
        expect(code).to eq(:unprocessable_entity)
        expect(response[:content]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end

  end

end

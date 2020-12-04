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

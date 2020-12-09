require 'rails_helper'

RSpec.describe SessionService do

  subject { described_class.new(create(:user)) }
  
  describe '::signup' do
    let(:result) { subject.signup(*parameters) }
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

    context "when some parameters are not valid" do
      let(:parameters) { [wrong_signup_params] }
      it_behaves_like "an unprocessable response"
    end

    context "when all parameters are valid" do
      let(:parameters) { [signup_params] }
      it_behaves_like "a valid response"
    end

    context "when email already exists" do
      let(:parameters) do 
        signup_params[:email] = subject.current_user.email
        [signup_params]
      end
      it_behaves_like "an unprocessable response"
    end

    context "when username already exists" do
      let(:parameters) do 
        signup_params[:username] = subject.current_user.username
        [signup_params]
      end
      it_behaves_like "an unprocessable response"
    end

  end

  describe "::signin" do
    let(:result) { subject.signin(*parameters) }
    let(:random_password) { Faker::Internet.password }
    let(:random_username) { Faker::Internet.username }

    context "when signin parameters are missing" do
      let(:parameters) { [{ username: nil, password: random_password }] }
      it_behaves_like "a bad request response"
    end

    context "When credentials are not valid" do
      let(:parameters) { [{ username: random_username, password: random_password }] }
      it_behaves_like "a bad request response"
    end

    context "When credentials are valid" do
      let(:parameters) { [{ username: subject.current_user.username, password: subject.current_user.password }] }

      it_behaves_like "a valid response"

      it "signs in" do
        expect(result.first[:content].authorization_token).not_to be_nil
      end
    end
  
  end

  describe "::signout" do
    let(:result) { subject.signout() }

    it_behaves_like "a valid response"
    
    it "signs out" do
      subject.current_user.authorization_token = Faker::Internet.uuid
      subject.current_user.token_lifetime = Time.now
      expect(result.first[:content][:success]).to eq(true)
      expect(subject.current_user.authorization_token).to eq(nil)
      expect(subject.current_user.token_lifetime).to eq(nil)
    end
  end

end
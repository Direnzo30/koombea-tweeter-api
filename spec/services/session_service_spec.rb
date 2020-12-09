require 'rails_helper'
require_relative '../shared_contexts/init_service.rb'
require_relative '../shared_examples/valid_response.rb'
require_relative '../shared_examples/unprocessable_response.rb'
require_relative '../shared_examples/bad_request_response.rb'

RSpec.describe SessionService do

  include_context "init_service"
  
  describe '::signup' do
    let(:fn) { subject.method(:signup) }
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
      let(:parameters) { wrong_signup_params }
      it_behaves_like "an unprocessable response"
    end

    context "when all parameters are valid" do
      let(:parameters) { signup_params }
      it_behaves_like "a valid response"
    end

    context "when email already exists" do
      let(:parameters) do 
        signup_params[:email] = subject.current_user.email
        signup_params
      end
      it_behaves_like "an unprocessable response"
    end

    context "when username already exists" do
      let(:parameters) do 
        signup_params[:username] = subject.current_user.username
        signup_params
      end
      it_behaves_like "an unprocessable response"
    end

  end

  describe "::signin" do
    let(:fn) { subject.method(:signin) }
    let(:random_password) { Faker::Internet.password }
    let(:random_username) { Faker::Internet.username }

    context "when signin parameters are missing" do
      let(:call_function_hook) { false }
      it "doesn't sign in" do
        response, code = fn.call({ username: nil, password: random_password })
        expect(code).to eq(:bad_request)
        expect(response[:error]).to eq("Param username is required and cannot be blank")
        expect(response[:content]).to be_nil
        response, code = fn.call({ username: random_username, password: nil })
        expect(code).to eq(:bad_request)
        expect(response[:error]).to eq("Param password is required and cannot be blank")
        expect(response[:content]).to be_nil
      end
    end

    context "When credentials are not valid" do
      let(:parameters) { { username: random_username, password: random_password } }
      it_behaves_like "a bad request response"
    end

    context "When credentials are valid" do
      let(:parameters) { { username: subject.current_user.username, password: subject.current_user.password } }
      it_behaves_like "a valid response"
      it "signs in" do
        expect(@response[:content].authorization_token).not_to be_nil
      end
    end
  end

  describe "::signout" do
    let(:fn) { subject.method(:signout) }
    let(:dummy) do
      subject.current_user.authorization_token = Faker::Internet.uuid
      subject.current_user.token_lifetime = Time.now
      nil
    end
    it_behaves_like "a valid response"
    it "signs out" do
      expect(@response[:content][:success]).to eq(true)
      expect(subject.current_user.authorization_token).to eq(nil)
      expect(subject.current_user.token_lifetime).to eq(nil)
    end
  end

end
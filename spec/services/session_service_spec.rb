require 'rails_helper'
RSpec.describe SessionService do

  subject { described_class.new(create(:user)) }
  
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
      it "doesn't sign up" do
        response, code = fn.call(wrong_signup_params)
        expect(code).to eq(:unprocessable_entity)
        expect(response[:content]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end

    context "when all parameters are valid" do
      it "signs up" do
        response, code = fn.call(signup_params)
        expect(code).to eq(:ok)
        expect(response[:error]).to be_nil
        expect(response[:content][:user_id]).not_to be_nil
      end
    end

    context "when email already exists" do
      it "doesn't sign up" do
        signup_params[:email] = subject.current_user.email
        response, code = fn.call(signup_params)
        expect(code).to eq(:unprocessable_entity)
        expect(response[:content]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end

    context "when username already exists" do
      it "doesn't sign up" do
        signup_params[:username] = subject.current_user.username
        response, code = fn.call(signup_params)
        expect(code).to eq(:unprocessable_entity)
        expect(response[:content]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end

  end

  describe "::signin" do
    let(:fn) { subject.method(:signin) }
    let(:random_password) { Faker::Internet.password }
    let(:random_username) { Faker::Internet.username }

    context "when signin parameters are missing" do
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
      it "doesn't sign in" do
        response, code = fn.call({ username: random_username, password: random_password })
        expect(code).to eq(:bad_request)
        expect(response[:error]).to eq("Credentials are not valid")
        expect(response[:content]).to be_nil
      end
    end

    context "When credentials are valid" do
      it "signs in" do
        response, code = fn.call({ username: subject.current_user.username, password: subject.current_user.password })
        expect(code).to eq(:ok)
        expect(response[:error]).to be_nil
        expect(response[:content].authorization_token).not_to be_nil
      end
    end
  end

  describe "::signout" do
    let(:fn) { subject.method(:signout) }
    it "signs out" do
      subject.current_user.authorization_token = Faker::Internet.uuid
      subject.current_user.token_lifetime = Time.now
      response, code = fn.call()
      expect(code).to eq(:ok)
      expect(response[:error]).to be_nil
      expect(response[:content][:success]).to eq(true)
      expect(subject.current_user.authorization_token).to eq(nil)
      expect(subject.current_user.token_lifetime).to eq(nil)
    end
  end

  # describe "::basic_profile" do
  #   context "when the requested profile doesn't exist" do
  #     it "doesn't retrieve a profile" do
  #       response, code = User.basic_profile(subject, { id: 0 })
  #       expect(code).to eq(:unprocessable_entity)
  #       expect(response[:error]).not_to be_nil
  #       expect(response[:content]).to be_nil
  #     end
  #   end

  #   context "when the requested profile exists" do
  #     include_context "user_with_relations"
  #     it "retrieves the profile" do
  #       response, code = User.basic_profile(subject, { id: @user_with_relations.id })
  #       expect(code).to eq(:ok)
  #       expect(response[:error]).to be_nil
  #       expect(response[:content]).not_to be_nil
  #       expect(response[:content].username).to eq(@user_with_relations.username)
  #       expect(response[:content].attributes["total_followed"]).to eq(@follwed_by_user.size)
  #       expect(response[:content].attributes["total_followers"]).to eq(@following_the_user.size)
  #     end
  #   end
  # end

  # describe "::get_followed_by_the_user" do
  #   context "when the requested user doesn't exist" do
  #     it "doesn't retrieve the followed users" do
  #       response, code = User.get_followed_by_the_user(subject, { id: 0, page: 1, per_page: 10 })
  #       expect(code).to eq(:unprocessable_entity)
  #       expect(response[:error]).not_to be_nil
  #       expect(response[:content]).to be_nil
  #     end
  #   end

  #   context "when the requested user exists" do
  #     context "when the user doesn't have followed users" do
  #       it "retrieves zero followers" do
  #         user = create(:user)
  #         response, code = User.get_followed_by_the_user(subject, { id: user.id, page: 1, per_page: 10 })
  #         expect(code).to eq(:ok)
  #         expect(response[:error]).to be_nil
  #         expect(response[:content].size).to eq(0)
  #         expect(response[:metadata][:username]).to eq(user.username)
  #       end
  #     end

  #     context "when the user have followed users" do
  #       include_context "user_with_relations"
  #       it "retrieves the user's followed users with pagination" do
  #         response, code = User.get_followed_by_the_user(subject, { id: @user_with_relations.id, page: 1, per_page: 10 })
  #         expect(code).to eq(:ok)
  #         expect(response[:error]).to be_nil
  #         expect(response[:content].size).to eq(@follwed_by_user.size)
  #         expect(response[:content].map(&:id).sort).to eq(@follwed_by_user)
  #         expect(response[:metadata][:username]).to eq(@user_with_relations.username)
  #       end
  #     end
  #   end
  # end

end
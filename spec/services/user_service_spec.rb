require 'rails_helper'

RSpec.describe UserService do

  subject { described_class.new(create(:user)) }

  describe "::basic_profile" do
    let(:result) { subject.basic_profile(*parameters) }

    context "when the requested profile doesn't exist" do
      let(:parameters) { [{ id: 0 }] }
      it_behaves_like "an unprocessable response" 
    end

    context "when the requested profile exists" do
      include_context "user_with_relations"
      let(:parameters) { [{ id: @user_with_relations.id }] }

      it_behaves_like "a valid response"

      it "retrieves the profile" do
        content = result.first[:content]
        expect(content.username).to eq(@user_with_relations.username)
        expect(content.attributes["total_followed"]).to eq(@follwed_by_user.size)
        expect(content.attributes["total_followers"]).to eq(@following_the_user.size)
      end
    end
  end

  describe "::followed_by_the_user" do
    let(:result) { subject.followed_by_the_user(*parameters) }

    context "when the requested user doesn't exist" do
      let(:parameters) { [{ id: 0, page: 1, per_page: 10 }] }
      it_behaves_like "an unprocessable response"
    end

    context "when the requested user exists" do
      context "when the user doesn't have followed users" do
        let(:user) { create(:user) }
        let(:parameters) { [id: user.id, page: 1, per_page: 10] }

        it_behaves_like "a valid response"

        it "retrieves zero followed users" do
          response = result.first
          expect(response[:content].size).to eq(0)
          expect(response[:metadata][:username]).to eq(user.username)
        end
      end

      context "when the user have followed users" do
        include_context "user_with_relations"
        let(:parameters) { [id: @user_with_relations.id, page: 1, per_page: 10] }

        it_behaves_like "a valid response"

        it "retrieves the user's followed users with pagination" do
          response = result.first
          expect(response[:content].size).to eq(@follwed_by_user.size)
          expect(response[:content].map(&:id).sort).to eq(@follwed_by_user)
          expect(response[:metadata][:username]).to eq(@user_with_relations.username)
        end
      end
    end
  end

  describe "::following_the_user" do
    let(:result) { subject.following_the_user(*parameters) }

    context "when the requested user doesn't exist" do
      let(:parameters) { [{ id: 0, page: 1, per_page: 10 }] }
      it_behaves_like "an unprocessable response"
    end

    context "when the requested user exists" do
      context "when the user doesn't have followers" do
        let(:user) { create(:user) }
        let(:parameters) { [id: user.id, page: 1, per_page: 10] }

        it_behaves_like "a valid response"

        it "retrieves zero followers" do
          response = result.first
          expect(response[:content].size).to eq(0)
          expect(response[:metadata][:username]).to eq(user.username)
        end
      end

      context "when the user have followers" do
        include_context "user_with_relations"
        let(:parameters) { [id: @user_with_relations.id, page: 1, per_page: 10] }

        it_behaves_like "a valid response"

        it "retrieves the user's followers with pagination" do
          response = result.first
          expect(response[:content].size).to eq(@following_the_user.size)
          expect(response[:content].map(&:id).sort).to eq(@following_the_user)
          expect(response[:metadata][:username]).to eq(@user_with_relations.username)
        end
      end
    end

  end

end
require 'rails_helper'

RSpec.describe FollowService do
  let(:follow) { create(:follow) }
  subject { described_class.new(follow.user) }

  describe "::generate_follow" do
    let(:result) { subject.generate_follow(*parameters) }

    context "when user tries to follow himself" do
      let(:parameters) { [{followed_id: subject.current_user.id}] }
      it_behaves_like "a bad request response"
    end

    context "when user tries to follow an already followed user" do
      let(:parameters) { [{followed_id: follow.followed_id}] }
      it_behaves_like "a bad request response"
    end

    context "when user generates a valid follow" do
      let(:parameters) { [{followed_id: create(:user).id}] }
      it_behaves_like "a valid response"
      it "follows the target user" do
        expect(result.first[:content][:follow_id]).not_to be_nil
      end
    end
  end
end
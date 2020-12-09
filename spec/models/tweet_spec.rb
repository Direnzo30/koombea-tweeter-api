require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:user) { create(:user) }
  subject { create(:tweet, user: user) }

  describe "ActiveModel Validations" do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content) }
  end

  describe "ActiveRecord Validations" do
    it { is_expected.to belong_to(:user) }
  end

end
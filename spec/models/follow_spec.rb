# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_follows_on_followed_id  (followed_id)
#  index_follows_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (followed_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user) { create(:user) }
  let(:followed) { create(:user) }
  subject { create(:follow, user: user, followed: followed) }

  describe "ActiveModel Validations" do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:followed_id) }
  end

  describe "ActiveRecord Validations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:followed) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:followed_id) }
  end
end

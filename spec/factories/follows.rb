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
FactoryBot.define do
  factory :follow do
    association :user, factory: :user
    association :followed, factory: :user
  end
end

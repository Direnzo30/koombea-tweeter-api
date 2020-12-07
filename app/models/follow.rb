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
class Follow < ApplicationRecord

  validates :user_id, presence: true
  validates :followed_id, presence: true
  
  belongs_to :user, :class_name => "User"
  belongs_to :followed, :class_name => "User"

end

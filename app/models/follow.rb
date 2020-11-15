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

  include EndpointsHandler

  def self.generate_follow(user, params)
    flat_endpoint do
      follow_params = {user_id: user.id}.merge(params)
      follow = self.new(follow_params)
      raise ActiveRecord::RecordInvalid.new(follow) unless follow.valid?
      raise PersonalizedException.new("User cannot follows itself", :bad_request) if user.id == params[:followed_id]
      raise PersonalizedException.new("User has been already followed", :bad_request) if self.exists?(follow_params).present?
      follow.save!
      { content: { follow_id: follow.id } }
    end
  end
end

class FollowService < BaseService

  def initialize(current_user = nil)
    super(current_user)
  end

  def generate_follow(params)
    flat_endpoint do
      follow_params = {user_id: @current_user.id}.merge(params)
      follow = Follow.new(follow_params)
      raise ActiveRecord::RecordInvalid.new(follow) unless follow.valid?
      raise PersonalizedException.new("User cannot follows itself", :bad_request) if @current_user.id == params[:followed_id]
      raise PersonalizedException.new("User has been already followed", :bad_request) if self.exists?(follow_params).present?
      follow.save!
      { content: { follow_id: follow.id } }
    end
  end

end

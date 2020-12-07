class UserService < BaseService

  def initialize(current_user)
    super(current_user)
  end

  # Get the contact that are following the selected user
  def following_the_user(params)
    flat_endpoint do
      requested_user = User.select(:username).find(params[:id])
      followed_users = User.joins("INNER JOIN follows F ON users.id = F.user_id")
                           .where("F.followed_id = ?", params[:id])
      metadata = page_metadata(params, followed_users)
      # Needs to check if selected users are followed by current user
      followed_users = followed_users.select("users.*, (F.user_id IN (SELECT U.followed_id from follows U where U.user_id = #{@current_user.id})) AS followed")
                                     .order("first_name ASC, last_name ASC")
                                     .paginate(metadata)
      { content: followed_users, metadata: metadata.merge(username: requested_user.username) }
    end
  end

  # Get the contacts that the selected user follows
  def followed_by_the_user(params)
    flat_endpoint do
      requested_user =  User.select(:username).find(params[:id])
      followed_users = User.joins("INNER JOIN follows F ON users.id = F.followed_id")
                           .where("F.user_id = ?", params[:id])
      metadata = page_metadata(params, followed_users)
      # Needs to check if selected users are followed by current user
      followed_users = followed_users.select("users.*, (F.followed_id IN (SELECT U.followed_id from follows U where U.user_id = #{@current_user.id})) AS followed")
                                     .order("first_name ASC, last_name ASC")
                                     .paginate(metadata)
      { content: followed_users, metadata: metadata.merge(username: requested_user.username) }
    end
  end

  # Get counters
  def basic_profile(params)
    flat_endpoint do
      cleaned_id = params[:id].to_i
      requested_user = User.select("users.*, "\
                                   "(SELECT COUNT(id) FROM follows F WHERE F.user_id = #{cleaned_id}) AS total_followed, "\
                                   "(SELECT COUNT(id) FROM follows F WHERE F.followed_id = #{cleaned_id}) AS total_followers, "\
                                   "(users.id = #{@current_user.id} OR (users.id IN (SELECT U.followed_id from follows U where U.user_id = #{@current_user.id}))) AS followed")
                            .find(cleaned_id)
      { content: requested_user }
    end
  end

end
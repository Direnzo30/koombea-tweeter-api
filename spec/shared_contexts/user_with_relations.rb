RSpec.shared_context "user_with_relations" do
  before(:example) do
    @user_with_relations = create(:user)
    @follwed_by_user = []
    @following_the_user = []
    top_limit = rand(5..8)
    (0..top_limit).each do |i|
      u = create(:user)
      if i.even?
        Follow.create({ user_id: @user_with_relations.id, followed_id: u.id })
        @follwed_by_user << u.id
      else
        Follow.create({ user_id: u.id, followed_id: @user_with_relations.id })
        @following_the_user << u.id
      end
    end
  end
end
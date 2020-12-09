class BaseService

  include EndpointsHandler
  include PaginationUtils

  attr_accessor :current_user

  def initialize(current_user = nil)
    @current_user = current_user
  end

end
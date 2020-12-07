class BaseService

  include EndpointsHandler
  include PaginationUtils

  def initialize(current_user = nil)
    @current_user = current_user
  end

end
require_relative 'personalized_exception'

class UnauthorizedException < PersonalizedException
  # Can handle parameters since status_code may be not_found for redirect proporses
  def initialize(status_code = :unauthorized)
    msg = "Unauthorized user for action"
    super(msg, status_code)
  end
end
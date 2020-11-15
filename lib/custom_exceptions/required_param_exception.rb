require_relative 'personalized_exception'

class RequiredParamExecption < PersonalizedException
  def initialize(required_param)
    msg = "Param #{required_param} is required and cannot be blank"
    super(msg, :bad_request)
  end
end
class PersonalizedException < StandardError
  attr_reader :status_code

  def initialize(msg, status_code)
    @status_code = status_code
    super(msg)
  end
end
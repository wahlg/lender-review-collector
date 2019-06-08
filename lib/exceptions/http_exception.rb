class Exceptions::HttpException < StandardError
  attr_reader :status

  def initialize(message, status = nil)
    super(message)
    @status = status
  end
end

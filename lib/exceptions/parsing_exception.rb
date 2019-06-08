class Exceptions::ParsingException < StandardError
  def initialize(message)
    super(message)
  end
end

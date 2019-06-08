class MockResponse
  attr_reader :body, :code

  def initialize(body, code = 200)
    @body = body
    @code = code
  end
end

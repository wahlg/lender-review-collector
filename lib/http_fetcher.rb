module HttpFetcher
  class << self
    def fetch(url)
      response = HTTParty.get(url)
      unless response.code == 200
        raise Exceptions::HttpException.new("Requested resource returned HTTP status: #{response.code}", response.code)
      end
      response
    rescue SocketError => e
      raise Exceptions::HttpException.new('Unable to reach specified URL')
    end
  end
end

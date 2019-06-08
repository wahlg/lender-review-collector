class UrlValidators::LendingTreeUrlValidator
  class << self
    LENDING_TREE_HOST = 'www.lendingtree.com'.freeze
    REVIEW_PATH = '/reviews'.freeze

    def validate!(parsed_uri)
      if parsed_uri.host != LENDING_TREE_HOST
        raise Exceptions::UrlValidationException.new("Provided URL is not a valid Lending Tree URL: '#{parsed_uri.to_s}'")
      elsif !parsed_uri.path.match(REVIEW_PATH)
        raise Exceptions::UrlValidationException.new("Provided URL is not under path '#{REVIEW_PATH}': '#{parsed_uri.to_s}'",)
      end
    end
  end
end

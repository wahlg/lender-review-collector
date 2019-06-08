class Api::V1::ReviewsController < Api::ApiController
  before_action :get_permitted_params, :only => [:show]
  before_action :require_url!, :only => [:show]
  before_action :validate_url!, :only => [:show]
  before_action :validate_domain_specific_url!, :only => [:show]

  def show
    response = HttpFetcher.fetch(@url)
    review_data = Parsers::LendingTreeParser.parse!(response.body)
    render_json(:body => review_data)
  rescue Exceptions::HttpException => e
    render_json_error(e.message, :status => :unprocessable_entity)
  rescue Exceptions::ParsingException => e
    render_json_error(e.message, :status => :unprocessable_entity)
  end

  private

  def get_permitted_params
    @permitted_params = params.permit(:url)
  end

  def require_url!
    @permitted_params.require(:url)
    @url = params[:url]
  end

  def validate_url!
    @parsed_uri = nil
    error = "Malformed URL provided: '#{@url}'"
    begin
      @parsed_uri = URI.parse(@url)
    rescue URI::InvalidURIError
      render_json_error(error, :status => :bad_request)
      return
    end
    unless @parsed_uri.is_a?(URI::HTTP) && @parsed_uri.host.present?
      render_json_error(error, :status => :bad_request)
    end
  end

  def validate_domain_specific_url!
    UrlValidators::LendingTreeUrlValidator.validate!(@parsed_uri)
  rescue Exceptions::UrlValidationException => e
    render_json_error(e.message, :status => :bad_request)
  end
end

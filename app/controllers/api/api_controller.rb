class Api::ApiController < ApplicationController
  DEFAULT_JSON_ERROR_MESSAGE = "An error occurred and your request could not be processed".freeze

  rescue_from ActionController::ParameterMissing do |e|
    render_json_error(e.message, :status => :unprocessable_entity)
  end

  def render_json(body: nil, status: :ok, error: nil)
    render(:json => { :result => body, :error => error }, :status => status)
  end

  def render_json_error(message = DEFAULT_JSON_ERROR_MESSAGE, status: :internal_server_error)
    render_json(:error => message, :status => status)
  end
end

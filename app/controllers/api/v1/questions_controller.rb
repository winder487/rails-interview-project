class Api::V1::QuestionsController < ApplicationController

  before_action :authenticate
  after_action :track_api_request

  def index
    render json: Question.not_private.to_json(include: :answers)
  end

  private

  def authenticate
    return unless validate_parameters

    api_key = http_api_key(request.headers)
    unauthorized_error('Missing API Key') and return unless api_key
    real_api = Tenant.find(params[:tenantId]).api_key
    puts real_api
    authorized = Tenant.find(params[:tenantId]).api_key == api_key
    unauthorized_error('Invalid API Key') and return unless authorized
  rescue ActiveRecord::RecordNotFound => error
    render json: { error: error.message }, status: :unauthorized
  end

  def validate_parameters
    params.require(:tenantId)
  rescue ActionController::ParameterMissing => error
    render json: { error: error.message }, status: :bad_request
    false
  end

  def unauthorized_error(error)
    render json: { error: error }, status: :unauthorized
  end

  def http_api_key(headers = {})
    if headers['X-API-Key'].present?
      headers['X-API-Key']
    else
      nil
    end
  end

  def track_api_request
    Tenant.find(params[:tenantId]).track_tenant_request
  end

end
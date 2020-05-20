class Api::V1::QuestionsController < ApplicationController

  before_action :authenticate
  after_action :track_api_request

  def index
    render json: Question.not_private.to_json(
    # we want to include the names of our askers and answerers
    include: [
      # so we include the user attributed to our question (asker)
      {
        user: {
          only: [:id, :name]
        }
      },
      # and the user attributed to each answer (answerer)
      # which means we need to include the answers in the first place
      {
        answers: {
          include: {
            user: {
              only: [:id, :name]
            }
          # this seeks to remove the redundant user_id field
          # since we're already pulling the user id and name in a pair (for answers)
          }, except: :user_id
        }
      }
    # this seeks to remove the redundant user_id field but for questions
    ], except: :user_id)
  end

  private

  # pretty much all of this authentication stuff should be in a helper class so it can be reused
  def authenticate
    return unless validate_parameters

    api_key = http_api_key(request.headers)
    unauthorized_error('Missing API Key') and return unless api_key
    real_api = Tenant.find(params[:tenantId]).api_key
    authorized = Tenant.find(params[:tenantId]).api_key == api_key
    unauthorized_error('Invalid API Key') and return unless authorized
  rescue ActiveRecord::RecordNotFound => error
    render json: { error: error.message }, status: :not_found
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
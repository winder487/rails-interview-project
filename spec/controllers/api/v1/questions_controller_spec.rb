require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  it 'requires requests to contain a tenant id' do
    get :index
    assert_response :bad_request
    expect(@response.body).to eq({
      error: 'param is missing or the value is empty: tenantId'
    }.to_json)
  end

  it 'handles when a tenant is not found' do
    @request.headers['X-API-Key'] = 'foo'
    get :index, tenantId: 'fantasy'
    assert_response :not_found
    expect(@response.body).to eq({
      error: "Couldn't find Tenant with 'id'=fantasy"
    }.to_json)
  end

  context 'when the api key is missing or malformed' do
    it 'requires requests to contain an API key' do
      create(:tenant, id: 1)

      # no X-API-Key header
      get :index, tenantId: 1
      assert_response :unauthorized
      expect(@response.body).to eq({
        error: 'Missing API Key'
      }.to_json)
    end

    it 'the API key must be valid' do
      create(:tenant, id: 1)

      # malformed API key
      @request.headers['X-API-Key'] = 'invalid'
      get :index, tenantId: 1
      assert_response :unauthorized
      expect(@response.body).to eq({
        error: 'Invalid API Key'
      }.to_json)
    end
  end

  context 'when authorized' do
    it 'returns a response that is valid JSON' do
      tenant = create(:tenant, id: 1)
      3.times do
        create(:question)
      end

      @request.headers['X-API-Key'] = tenant.api_key
      get :index, tenantId: 1
      assert_response :ok

      questions = JSON.parse(@response.body)
      expect(questions.count).to eq(Question.count)
    end

    subject { get :index, tenantId: 1 }

    it 'tracks tenant API request counts' do
      tenant = create(:tenant, id: 1)
      @request.headers['X-API-Key'] = tenant.api_key

      expect {subject}.to change { Tenant.first.api_requests }.by(1)
    end

    it 'returns questions that contain answers' do
      3.times do
        answer = create(:answer)
        create(:question, answers: [answer])
      end

      tenant = create(:tenant, id: 1)
      @request.headers['X-API-Key'] = tenant.api_key
      get :index, tenantId: 1
      assert_response :ok

      questions = JSON.parse(@response.body)
      expect(questions.first['answers'].present?)
    end

    it 'returns a response with the id and name of the question user' do
      3.times do
        user = create(:user)
        answer = create(:answer, user_id: user.id)
        create(:question, answers: [answer], user_id: user.id)
      end

      tenant = create(:tenant, id: 1)
      @request.headers['X-API-Key'] = tenant.api_key
      get :index, tenantId: 1
      assert_response :ok

      user_info = JSON.parse(@response.body).first['user']
      expect(user_info['id'].present?)
      expect(user_info['name'].present?)
    end

    it 'returns a response with the id and name of the answer user' do
      3.times do
        user = create(:user)
        answer = create(:answer, user_id: user.id)
        create(:question, answers: [answer], user_id: user.id)
      end

      tenant = create(:tenant, id: 1)
      @request.headers['X-API-Key'] = tenant.api_key
      get :index, tenantId: 1
      assert_response :ok

      user_info = JSON.parse(@response.body).first['answers'].first['user']
      expect(user_info['id'].present?)
      expect(user_info['name'].present?)
    end
  end
end
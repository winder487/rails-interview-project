require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  it 'should pass down counts' do
    get :index
    expect(assigns(:user_count)).to eq(User.count)
    expect(assigns(:question_count)).to eq(Question.count)
    expect(assigns(:answer_count)).to eq(Answer.count)
    expect(assigns(:tenants)).to eq(Tenant.all)
  end
end
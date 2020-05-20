class WelcomeController < ApplicationController
  def index
    @user_count = User.count
    @question_count = Question.count
    @answer_count = Answer.count
    @tenants = Tenant.all
  end
end

require 'rails_helper'

# Test suite for the question model
RSpec.describe Question, type: :model do
  it { should have_many(:answers)}

  it { should belong_to(:user)}

  describe 'scope not_private' do
    it 'does not return private questions' do
      question = Question.not_private
      expect(question.none? {|q| q.private}).to be(true)
    end
  end
end
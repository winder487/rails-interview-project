require 'rails_helper'

# Test suite for the question model
RSpec.describe Question, type: :model do
  it { should have_many(:answers)}

  it { should belong_to(:user)}

  describe 'scope not_private' do
    before do
      # creating instances of a test object with FactoryBot to test the scope
      # one public
      create(:question)
      # the other private
      create(:question, private: true)
    end

    it 'does not return questions marked private' do
      expect(Question.not_private.none? {|q| q.private}).to be(true)
    end
  end
end
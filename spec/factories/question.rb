require 'ffaker'

FactoryBot.define do
  factory :question do
    title { FFaker::HipsterIpsum.sentence.gsub(/\.$/, "?") }
    user_id { rand(20) }
    answers {[create(:answer)]}
    private {false}
  end
end
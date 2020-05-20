require 'ffaker'

FactoryBot.define do
  factory :answer do
    body { FFaker::HipsterIpsum.sentence }
    question_id { rand(20) }
    user_id { rand(20) }
  end
end
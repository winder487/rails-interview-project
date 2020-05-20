require 'ffaker'

FactoryBot.define do
  factory :tenant do
    name { FFaker::Name.name }
    api_key { SecureRandom.hex(16) }
    api_requests { 0 }
  end
end
require 'ffaker'

FactoryBot.define do
  factory :user do
    name {FFaker::Name.name}
  end
end
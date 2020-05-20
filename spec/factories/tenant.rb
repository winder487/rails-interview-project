FactoryBot.define do
    factory :tenant do
      api_key {SecureRandom.hex(16)}
    end
end
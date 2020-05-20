require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe '#track_tenant_request' do
    it 'should record the instance of a new api request for the tenant' do
      # creating an instance of a mocked object with FactoryBot that has no database access 
      tenant = build_stubbed(:tenant)
      expect(tenant.api_requests).to be(0)

      # mocking out a real call to the database
      allow(tenant).to receive(:save!).once
      tenant.track_tenant_request
      expect(tenant.api_requests).to be(1)
    end
  end
end
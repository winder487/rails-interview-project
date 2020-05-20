class Tenant < ActiveRecord::Base

  before_create :generate_api_key

  def track_tenant_request
    self.api_requests += 1
    save!
  end
  
  private

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end

end

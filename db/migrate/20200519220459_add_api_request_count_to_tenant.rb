class AddApiRequestCountToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :api_requests, :integer, default: 0
  end
end

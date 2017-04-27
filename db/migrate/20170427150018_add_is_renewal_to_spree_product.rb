class AddIsRenewalToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :is_renewal, :boolean
    add_column :spree_products, :existing_subscription_id, :integer
    add_index  :spree_products, :existing_subscription_id
  end
end


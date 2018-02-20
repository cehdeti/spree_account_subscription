class AddExtendedSubscriptionCouponToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :should_extend_subscription, :boolean, default: false, null: false
  end
end

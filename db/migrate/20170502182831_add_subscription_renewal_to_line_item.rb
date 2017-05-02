class AddSubscriptionRenewalToLineItem < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :renewing_subscription_id, :integer
    add_index  :spree_line_items, :renewing_subscription_id
  end
end

class AddIsRenewalToAccountSubscription < ActiveRecord::Migration
  def change

    add_column :spree_account_subscriptions, :is_renewal, :boolean
    add_column :spree_account_subscriptions, :renewing_subscription_id, :integer
    add_index  :spree_account_subscriptions, :renewing_subscription_id

  end
end

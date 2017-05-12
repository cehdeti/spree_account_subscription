class AddRenewalDateToSpreeAccountSubscription < ActiveRecord::Migration
  def change
    add_column :spree_account_subscriptions, :renewal_date, :date, :default => false
    remove_column :spree_account_subscriptions, :renewing_subscription_id
  end
end


class AddSubscriptionSeat < ActiveRecord::Migration
  def change
    create_table :spree_subscription_seats do |t|
      t.references :user, index: true
      t.references :account_subscription, index: true
    end
  end
end

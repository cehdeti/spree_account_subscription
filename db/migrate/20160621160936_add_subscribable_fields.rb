class AddSubscribableFields < ActiveRecord::Migration
  def change
    change_table :spree_products do |t|
      t.references :existing_subscription, reference: :spree_account_subscriptions, index: true
      t.boolean :subscribable, default: false
      t.boolean :is_renewal
    end

    change_table :spree_variants do |t|
      t.integer :subscription_length
      t.boolean :is_renewal
    end

    change_table :spree_line_items do |t|
      t.references :renewing_subscription, reference: :spree_account_subscriptions, index: true
      t.integer :is_spinoff
    end

    change_table :spree_orders do |t|
      t.boolean :should_extend_subscription, default: false, null: false
    end
  end
end

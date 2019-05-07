class RemoveSeatsFromSubscriptionModel < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      # remove seat reference from line_items
      dir.up do
        next unless column_exists?(:spree_line_items, :renewal_seat_id)
        remove_column(:spree_line_items, :renewal_seat_id)
      end
      dir.down {}
    end

    # drop the seats table
    drop_table :spree_subscription_seats do |t|
      t.references :user, index: true
      t.references :account_subscription, index: true
    end
  end
end

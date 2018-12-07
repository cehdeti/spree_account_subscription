class RemoveSeatsFromSubscriptionModel < ActiveRecord::Migration[5.2]
  def change
    # remove seat reference from line_items
    remove_column :spree_line_items, :renewal_seat_id

    # drop the seats table
    drop_table :spree_subscription_seats
  end
end

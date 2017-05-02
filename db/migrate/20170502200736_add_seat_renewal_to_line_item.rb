class AddSeatRenewalToLineItem < ActiveRecord::Migration
  def change

    add_column :spree_line_items, :renewing_seat_id, :integer
    add_index  :spree_line_items, :renewing_seat_id

  end
end

class AddIsSpinoffToLineItem < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :is_spinoff, :boolean
  end
end

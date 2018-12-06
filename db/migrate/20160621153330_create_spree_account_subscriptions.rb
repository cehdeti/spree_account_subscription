class CreateSpreeAccountSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_account_subscriptions do |t|
      t.references :product, index: true
      t.references :order, index: true
      t.references :user, index: true
      t.string :email
      t.string :state
      t.integer :num_seats, default: 1
      t.string :token
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.boolean :is_renewal
      t.date :renewal_date, default: false
      t.timestamps null: false
    end
  end
end


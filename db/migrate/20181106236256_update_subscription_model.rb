class UpdateSubscriptionModel < ActiveRecord::Migration[5.2]
  def change

    # create_table :spree_subscriptions do |t|
    #   t.references :product, index: true
    #   t.references :order, index: true
    #   t.references :user, index: true

    #   t.integer :licenses, default: 1
    #   t.datetime :start_at
    #   t.datetime :expire_at

    #   t.string :email
    #   t.string :state
    #   t.string :token
    #   t.timestamps null: false
    # end

    remove_column :spree_account_subscriptions, :is_renewal
    remove_column :spree_account_subscriptions, :renewal_date
    rename_column :spree_account_subscriptions, :num_seats, :licenses
    rename_column :spree_account_subscriptions, :start_datetime, :start_at
    rename_column :spree_account_subscriptions, :end_datetime, :expire_at

    # remove unused product columns
    remove_column :spree_products, :is_renewal
    remove_column :spree_variants, :is_renewal
  end
end

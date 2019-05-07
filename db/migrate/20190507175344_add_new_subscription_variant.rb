class AddNewSubscriptionVariant < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_variants, :new_subscription_variant, :boolean, default: false
    rename_column :spree_variants, :is_renewal, :renewal_subscription_variant

    reversible do |dir|
      dir.up do
        execute %Q(
          UPDATE spree_variants SET renewal_subscription_variant = FALSE
          WHERE renewal_subscription_variant IS NULL
        )
        execute %Q(
          UPDATE spree_variants AS v SET new_subscription_variant = (
            (NOT renewal_subscription_variant) AND (p.subscribable)
          )
          FROM spree_products AS p
          WHERE v.product_id = p.id
        )
      end
      dir.down {}
    end

    change_column_null :spree_variants, :new_subscription_variant, false
  end
end

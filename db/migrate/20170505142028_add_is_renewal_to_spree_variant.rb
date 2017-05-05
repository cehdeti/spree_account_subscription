class AddIsRenewalToSpreeVariant < ActiveRecord::Migration
  def change
    add_column :spree_variants, :is_renewal, :boolean
  end
end

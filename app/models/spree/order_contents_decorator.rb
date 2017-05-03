Spree::OrderContents.class_eval do


  def add_to_line_item(variant, quantity, options = {})
    line_item = grab_line_item_by_variant(variant, false, options)

    puts("ORDER CONTENTS ADD TO LINE ITEM: #{options}")
    if line_item
      line_item.quantity += quantity.to_i
      line_item.currency = currency unless currency.nil?
    else
      opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
          permit(Spree::PermittedAttributes.line_item_attributes)

      puts("not adding to line item, using options: #{opts}")

      line_item = order.line_items.new(quantity: quantity,
                                       variant: variant,
                                       options: opts)
    end
    line_item.target_shipment = options[:shipment] if options.has_key? :shipment
    line_item.save!
    line_item
  end


  def grab_line_item_by_variant(variant, raise_error = false, options = {})
    line_item = order.find_line_item_by_variant(variant, options)

    if !line_item.present? && raise_error
      raise ActiveRecord::RecordNotFound, "Line item not found for variant #{variant.sku}"
    end

    line_item
  end
end
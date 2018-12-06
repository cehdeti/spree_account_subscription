Deface::Override.new(
  virtual_path: "spree/shared/_order_details",
  name: "add_token_to_order_show",
  insert_bottom: "td[data-hook='order_item_description']",
  partial: 'spree/shared/add_token_to_order_show'
)
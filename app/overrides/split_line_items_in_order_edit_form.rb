Deface::Override.new(
  virtual_path: "spree/orders/_form",
  name: "split_subscribable_line_items_in_order_edit",
  replace_contents: "[data-hook='cart-detail-table']",
  partial: "spree/orders/split_form"
)
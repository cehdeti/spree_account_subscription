Deface::Override.new(
  virtual_path: "spree/products/_cart_form",
  name: "use_subscribe_locale_instead_of_add_to_cart",
  replace: "erb[loud]:contains(\"Spree.t(:add_to_cart)\")",
  text: "<%= @product.subscribable? ? Spree.t(:subscribe_call_to_action) : Spree.t(:add_to_cart) %>"
)

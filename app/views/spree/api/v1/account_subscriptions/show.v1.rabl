object @account_subscription

node(:product) { |a| a.product.id }
node(:sku) { |a| a.product.sku }
node(:user) { |a| a.user.id }
node(:email) { |a| a.email }
node(:state) { |a| a.state }
node(:start) { |a| a.start_datetime}
node(:end) { |a| a.end_datetime}
node(:token) { |a| a.token }
node(:is_renewal) { |a| a.is_renewal }
node(:renewal_date) { |a| a.renewal_date }

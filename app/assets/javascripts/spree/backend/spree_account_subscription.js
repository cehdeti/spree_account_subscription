var initExtendSubscriptionPromoActions = function() {
  $(document)
    .on('change', 'form.edit_promotion .promotion_action.extend_subscription .js-promo-action-extend-subscription-extension-policy',
      function(event) {
        var $element = $(event.target);
        var $container = $element.closest('.promotion_action.extend_subscription');
        var value = $element.val();
        var $to_show = $container.find('.js-promo-action-extend-subscription-' + value);

        $to_show
          .show()
          .siblings().hide();
      })
    .on('ajax:success', '#new_promotion_action_form', function(event) {
      updateExtendSubscriptionPromoActions();
      handle_date_picker_fields();
    });
};

var updateExtendSubscriptionPromoActions = function() {
  $('form.edit_promotion .promotion_action.extend_subscription .js-promo-action-extend-subscription-extension-policy').change();
};

$(document).ready(function () {
  initExtendSubscriptionPromoActions();
  updateExtendSubscriptionPromoActions();
});

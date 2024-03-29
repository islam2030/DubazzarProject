using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.Net.Http.Headers;
using Nop.Core;
using Nop.Core.Domain.Directory;
using Nop.Core.Domain.Orders;
using Nop.Core.Domain.Shipping;
using Nop.Core.Infrastructure;
using Nop.Core.Plugins;
using Nop.Services.Common;
using Nop.Services.Configuration;
using Nop.Services.Directory;
using Nop.Services.Localization;
using Nop.Services.Orders;
using Nop.Services.Payments;
using Nop.Services.Tax;

namespace Nop.Plugin.Payments.Aaib
{
    /// <summary>
    /// Aaib payment processor
    /// </summary>
    public class AaibPaymentProcessor : BasePlugin, IPaymentMethod
    {
        #region Fields

        private readonly IWorkContext _workContext = EngineContext.Current.Resolve<IWorkContext>();
        private readonly IStoreContext _storeContext = EngineContext.Current.Resolve<IStoreContext>();

        private readonly CurrencySettings _currencySettings;
        private readonly ICheckoutAttributeParser _checkoutAttributeParser;
        private readonly ICurrencyService _currencyService;
        private readonly IGenericAttributeService _genericAttributeService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILocalizationService _localizationService;
        private readonly IOrderTotalCalculationService _orderTotalCalculationService;
        private readonly ISettingService _settingService;
        private readonly ITaxService _taxService;
        private readonly IWebHelper _webHelper;
        private readonly AaibPaymentSettings _AaibPaymentSettings;

        #endregion

        #region Ctor

        public AaibPaymentProcessor(CurrencySettings currencySettings,
            ICheckoutAttributeParser checkoutAttributeParser,
            ICurrencyService currencyService,
            IGenericAttributeService genericAttributeService,
            IHttpContextAccessor httpContextAccessor,
            ILocalizationService localizationService,
            IOrderTotalCalculationService orderTotalCalculationService,
            ISettingService settingService,
            ITaxService taxService,
            IWebHelper webHelper,
            AaibPaymentSettings AaibPaymentSettings)
        {
            this._currencySettings = currencySettings;
            this._checkoutAttributeParser = checkoutAttributeParser;
            this._currencyService = currencyService;
            this._genericAttributeService = genericAttributeService;
            this._httpContextAccessor = httpContextAccessor;
            this._localizationService = localizationService;
            this._orderTotalCalculationService = orderTotalCalculationService;
            this._settingService = settingService;
            this._taxService = taxService;
            this._webHelper = webHelper;
            this._AaibPaymentSettings = AaibPaymentSettings;
        }

        #endregion

        #region Utilities

        /// <summary>
        /// Gets PayPal URL
        /// </summary>
        /// <returns></returns>
        private string GetPaypalUrl()
        {
            return _AaibPaymentSettings.UseSandbox ?
                 "https://www.sandbox.paypal.com/us/cgi-bin/webscr" :
              "https://www.paypal.com/us/cgi-bin/webscr";
        }

        /// <summary>
        /// Gets IPN PayPal URL
        /// </summary>
        /// <returns></returns>
        private string GetIpnPaypalUrl()
        {
            return _AaibPaymentSettings.UseSandbox ?
                "https://ipnpb.sandbox.paypal.com/cgi-bin/webscr" :
               "https://ipnpb.paypal.com/cgi-bin/webscr";
        }

        /// <summary>
        /// Gets PDT details
        /// </summary>
        /// <param name="tx">TX</param>
        /// <param name="values">Values</param>
        /// <param name="response">Response</param>
        /// <returns>Result</returns>
        public bool GetPdtDetails(string tx, out Dictionary<string, string> values, out string response)
        {
            var req = (HttpWebRequest)WebRequest.Create(GetPaypalUrl());
            req.Method = WebRequestMethods.Http.Post;
            req.ContentType = MimeTypes.ApplicationXWwwFormUrlencoded;
            //now Aaib requires user-agent. otherwise, we can get 403 error
            req.UserAgent = _httpContextAccessor.HttpContext.Request.Headers[HeaderNames.UserAgent];

            var formContent = $"cmd=_notify-synch&at={_AaibPaymentSettings.PdtToken}&tx={tx}";
            req.ContentLength = formContent.Length;
            
            using (var sw = new StreamWriter(req.GetRequestStream(), Encoding.ASCII))
                sw.Write(formContent);

            using (var sr = new StreamReader(req.GetResponse().GetResponseStream()))
                response = WebUtility.UrlDecode(sr.ReadToEnd());

            values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            bool firstLine = true, success = false;
            foreach (var l in response.Split('\n'))
            {
                var line = l.Trim();
                if (firstLine)
                {
                    success = line.Equals("SUCCESS", StringComparison.OrdinalIgnoreCase);
                    firstLine = false;
                }
                else
                {
                    var equalPox = line.IndexOf('=');
                    if (equalPox >= 0)
                        values.Add(line.Substring(0, equalPox), line.Substring(equalPox + 1));
                }
            }
            

            return success;
        }

        /// <summary>
        /// Verifies IPN
        /// </summary>
        /// <param name="formString">Form string</param>
        /// <param name="values">Values</param>
        /// <returns>Result</returns>
        public bool VerifyIpn(string formString, out Dictionary<string, string> values)
        {
            var req = (HttpWebRequest)WebRequest.Create(GetIpnPaypalUrl());
            req.Method = WebRequestMethods.Http.Post;
            req.ContentType = MimeTypes.ApplicationXWwwFormUrlencoded;
            //now PayPal requires user-agent. otherwise, we can get 403 error
            req.UserAgent = _httpContextAccessor.HttpContext.Request.Headers[HeaderNames.UserAgent];

            var formContent = $"cmd=_notify-validate&{formString}";
            req.ContentLength = formContent.Length;
            
            using (var sw = new StreamWriter(req.GetRequestStream(), Encoding.ASCII))
            {
                sw.Write(formContent);
            }

            string response;
            using (var sr = new StreamReader(req.GetResponse().GetResponseStream()))
            {
                response = WebUtility.UrlDecode(sr.ReadToEnd());
            }
            var success = response.Trim().Equals("VERIFIED", StringComparison.OrdinalIgnoreCase);

            values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (var l in formString.Split('&'))
            {
                var line = l.Trim();
                var equalPox = line.IndexOf('=');
                if (equalPox >= 0)
                    values.Add(line.Substring(0, equalPox), line.Substring(equalPox + 1));
            }

            return success;
        }

        /// <summary>
        /// Create common query parameters for the request
        /// </summary>
        /// <param name="postProcessPaymentRequest">Payment info required for an order processing</param>
        /// <returns>Created query parameters</returns>
        private IDictionary<string, string> CreateQueryParameters(PostProcessPaymentRequest postProcessPaymentRequest)
        {
            //get store location
            var storeLocation = _webHelper.GetStoreLocation();

            //create query parameters
            return new Dictionary<string, string>
            {
                //PayPal ID or an email address associated with your PayPal account
                ["business"] = _AaibPaymentSettings.BusinessEmail,

                //the character set and character encoding
                ["charset"] = "utf-8",

                //set return method to "2" (the customer redirected to the return URL by using the POST method, and all payment variables are included)
                ["rm"] = "2",

                ["bn"] = AaibHelper.NopCommercePartnerCode,
                ["currency_code"] = _currencyService.GetCurrencyById(_currencySettings.PrimaryStoreCurrencyId)?.CurrencyCode,

                //order identifier
                ["invoice"] = postProcessPaymentRequest.Order.CustomOrderNumber,
                ["custom"] = postProcessPaymentRequest.Order.OrderGuid.ToString(),

                //PDT, IPN and cancel URL
                ["return"] = $"{storeLocation}Plugins/PaymentAaib/PDTHandler",
                ["notify_url"] = $"{storeLocation}Plugins/PaymentAaib/IPNHandler",
                ["cancel_return"] = $"{storeLocation}Plugins/PaymentAaib/CancelOrder",

                //shipping address, if exists
                ["no_shipping"] = postProcessPaymentRequest.Order.ShippingStatus == ShippingStatus.ShippingNotRequired ? "1" : "2",
                ["address_override"] = postProcessPaymentRequest.Order.ShippingStatus == ShippingStatus.ShippingNotRequired ? "0" : "1",
                ["first_name"] = postProcessPaymentRequest.Order.ShippingAddress?.FirstName,
                ["last_name"] = postProcessPaymentRequest.Order.ShippingAddress?.LastName,
                ["address1"] = postProcessPaymentRequest.Order.ShippingAddress?.Address1,
                ["address2"] = postProcessPaymentRequest.Order.ShippingAddress?.Address2,
                ["city"] = postProcessPaymentRequest.Order.ShippingAddress?.City,
                ["state"] = postProcessPaymentRequest.Order.ShippingAddress?.StateProvince?.Abbreviation,
                ["country"] = postProcessPaymentRequest.Order.ShippingAddress?.Country?.TwoLetterIsoCode,
                ["zip"] = postProcessPaymentRequest.Order.ShippingAddress?.ZipPostalCode,
                ["email"] = postProcessPaymentRequest.Order.ShippingAddress?.Email
            };
        }

        /// <summary>
        /// Add order items to the request query parameters
        /// </summary>
        /// <param name="parameters">Query parameters</param>
        /// <param name="postProcessPaymentRequest">Payment info required for an order processing</param>
        private void AddItemsParameters(IDictionary<string, string> parameters, PostProcessPaymentRequest postProcessPaymentRequest)
        {
            //upload order items
            parameters.Add("cmd", "_cart");
            parameters.Add("upload", "1");

            var cartTotal = decimal.Zero;
            var roundedCartTotal = decimal.Zero;
            var itemCount = 1;

            //add shopping cart items
            foreach (var item in postProcessPaymentRequest.Order.OrderItems)
            {
                var roundedItemPrice = Math.Round(item.UnitPriceExclTax, 2);

                //add query parameters
                parameters.Add($"item_name_{itemCount}", item.Product.Name);
                parameters.Add($"amount_{itemCount}", roundedItemPrice.ToString("0.00", CultureInfo.InvariantCulture));
                parameters.Add($"quantity_{itemCount}", item.Quantity.ToString());

                cartTotal += item.PriceExclTax;
                roundedCartTotal += roundedItemPrice * item.Quantity;
                itemCount++;
            }

            //add checkout attributes as order items
            var checkoutAttributeValues = _checkoutAttributeParser.ParseCheckoutAttributeValues(postProcessPaymentRequest.Order.CheckoutAttributesXml);
            foreach (var attributeValue in checkoutAttributeValues)
            {
                var attributePrice = _taxService.GetCheckoutAttributePrice(attributeValue, false, postProcessPaymentRequest.Order.Customer);
                var roundedAttributePrice = Math.Round(attributePrice, 2);

                //add query parameters
                if (attributeValue.CheckoutAttribute != null)
                {
                    parameters.Add($"item_name_{itemCount}", attributeValue.CheckoutAttribute.Name);
                    parameters.Add($"amount_{itemCount}", roundedAttributePrice.ToString("0.00", CultureInfo.InvariantCulture));
                    parameters.Add($"quantity_{itemCount}", "1");

                    cartTotal += attributePrice;
                    roundedCartTotal += roundedAttributePrice;
                    itemCount++;
                }
            }

            //add shipping fee as a separate order item, if it has price
            var roundedShippingPrice = Math.Round(postProcessPaymentRequest.Order.OrderShippingExclTax, 2);
            if (roundedShippingPrice > decimal.Zero)
            {
                parameters.Add($"item_name_{itemCount}", "Shipping fee");
                parameters.Add($"amount_{itemCount}", roundedShippingPrice.ToString("0.00", CultureInfo.InvariantCulture));
                parameters.Add($"quantity_{itemCount}", "1");

                cartTotal += postProcessPaymentRequest.Order.OrderShippingExclTax;
                roundedCartTotal += roundedShippingPrice;
                itemCount++;
            }

            //add payment method additional fee as a separate order item, if it has price
            var roundedPaymentMethodPrice = Math.Round(postProcessPaymentRequest.Order.PaymentMethodAdditionalFeeExclTax, 2);
            if (roundedPaymentMethodPrice > decimal.Zero)
            {
                parameters.Add($"item_name_{itemCount}", "Payment method fee");
                parameters.Add($"amount_{itemCount}", roundedPaymentMethodPrice.ToString("0.00", CultureInfo.InvariantCulture));
                parameters.Add($"quantity_{itemCount}", "1");

                cartTotal += postProcessPaymentRequest.Order.PaymentMethodAdditionalFeeExclTax;
                roundedCartTotal += roundedPaymentMethodPrice;
                itemCount++;
            }

            //add tax as a separate order item, if it has positive amount
            var roundedTaxAmount = Math.Round(postProcessPaymentRequest.Order.OrderTax, 2);
            if (roundedTaxAmount > decimal.Zero)
            {
                parameters.Add($"item_name_{itemCount}", "Tax amount");
                parameters.Add($"amount_{itemCount}", roundedTaxAmount.ToString("0.00", CultureInfo.InvariantCulture));
                parameters.Add($"quantity_{itemCount}", "1");

                cartTotal += postProcessPaymentRequest.Order.OrderTax;
                roundedCartTotal += roundedTaxAmount;
                itemCount++;
            }

            if (cartTotal > postProcessPaymentRequest.Order.OrderTotal)
            {
                //get the difference between what the order total is and what it should be and use that as the "discount"
                var discountTotal = Math.Round(cartTotal - postProcessPaymentRequest.Order.OrderTotal, 2);
                roundedCartTotal -= discountTotal;

                //gift card or rewarded point amount applied to cart in nopCommerce - shows in Aaib as "discount"
                parameters.Add("discount_amount_cart", discountTotal.ToString("0.00", CultureInfo.InvariantCulture));
            }

            //save order total that actually sent to Aaib (used for PDT order total validation)
            _genericAttributeService.SaveAttribute(postProcessPaymentRequest.Order, AaibHelper.OrderTotalSentToPayPal, roundedCartTotal);
        }

        /// <summary>
        /// Add order total to the request query parameters
        /// </summary>
        /// <param name="parameters">Query parameters</param>
        /// <param name="postProcessPaymentRequest">Payment info required for an order processing</param>
        private void AddOrderTotalParameters(IDictionary<string, string> parameters, PostProcessPaymentRequest postProcessPaymentRequest)
        {
            //round order total
            var roundedOrderTotal = Math.Round(postProcessPaymentRequest.Order.OrderTotal, 2);

            parameters.Add("cmd", "_xclick");
            parameters.Add("item_name", $"Order Number {postProcessPaymentRequest.Order.CustomOrderNumber}");
            parameters.Add("amount", roundedOrderTotal.ToString("0.00", CultureInfo.InvariantCulture));

            //save order total that actually sent to PayPal (used for PDT order total validation)
            _genericAttributeService.SaveAttribute(postProcessPaymentRequest.Order, AaibHelper.OrderTotalSentToPayPal, roundedOrderTotal);
        }

        #endregion

        #region Methods

        /// <summary>
        /// Process a payment
        /// </summary>
        /// <param name="processPaymentRequest">Payment info required for an order processing</param>
        /// <returns>Process payment result</returns>
        public ProcessPaymentResult ProcessPayment(ProcessPaymentRequest processPaymentRequest)
        {
            return new ProcessPaymentResult();
        }

        /// <summary>
        /// Post process payment (used by payment gateways that require redirecting to a third-party URL)
        /// </summary>
        /// <param name="postProcessPaymentRequest">Payment info required for an order processing</param>
        public void PostProcessPayment(PostProcessPaymentRequest postProcessPaymentRequest)
        {
            //create common query parameters for the request
            var queryParameters = CreateQueryParameters(postProcessPaymentRequest);

            //whether to include order items in a transaction
            if (_AaibPaymentSettings.PassProductNamesAndTotals)
            {




                //add order items query parameters to the request
                var parameters = new Dictionary<string, string>(queryParameters);
                AddItemsParameters(parameters, postProcessPaymentRequest);

                //remove null values from parameters
                parameters = parameters.Where(parameter => !string.IsNullOrEmpty(parameter.Value))
                    .ToDictionary(parameter => parameter.Key, parameter => parameter.Value);

                //ensure redirect URL doesn't exceed 2K chars to avoid "too long URL" exception
                var redirectUrl = QueryHelpers.AddQueryString(GetPaypalUrl(), parameters);
                if (redirectUrl.Length <= 2048)
                {
                    //Aaib 26/11/2018
                    string Prod = postProcessPaymentRequest.Order.Id.ToString();
                    var webHelper = Nop.Core.Infrastructure.EngineContext.Current.Resolve<Nop.Core.IWebHelper>();
                    var storeUrl = webHelper.GetStoreLocation();

                    string PaymentServerURL = "https://migs.mastercard.com.au/vpcpay?";
                    string vpc_Version = "&vpc_Version=1";
                    string vpc_Command = "&vpc_Command=pay";
                    string vpc_Merchant = "&vpc_Merchant=" + _AaibPaymentSettings.vpc_Merchant;
                    string vpc_AccessCode = "vpc_AccessCode=" + _AaibPaymentSettings.vpc_AccessCode;
                    string SecureSecret = "&SecureSecret=" + _AaibPaymentSettings.SecureSecret;
                    string vpc_ReturnURL = "&vpc_ReturnURL=" + storeUrl + "/Plugins/PaymentAaib/PDTHandler";
                    string vpc_Currency = "&vpc_Currency=EGP";
                    string vpc_Locale = "&vpc_Locale=en_AU";
                    string vpc_SecureHash = "&vpc_SecureHash=58F895D840E488BD640613F672FCFD23AB2622353FF8649DC84BBB17D9C3578F";
                    string vpc_SecureHashType = "&vpc_SecureHashType=SHA256";


                    string ipnUrl1 = PaymentServerURL +
                                      vpc_AccessCode +
                                      vpc_Command +
                                      vpc_Currency +
                                      vpc_Locale +
                                      vpc_Merchant +
                                      vpc_ReturnURL +
                                      vpc_Version +
                                      vpc_SecureHash +
                                      vpc_SecureHashType;


                    _httpContextAccessor.HttpContext.Response.Redirect(ipnUrl1);
                }
            }

            //or add only an order total query parameters to the request
            AddOrderTotalParameters(queryParameters, postProcessPaymentRequest);

            //remove null values from parameters
            queryParameters = queryParameters.Where(parameter => !string.IsNullOrEmpty(parameter.Value))
                .ToDictionary(parameter => parameter.Key, parameter => parameter.Value);


            //Aaib 26/11/2018
            string Prod1 = postProcessPaymentRequest.Order.Id.ToString();
            var webHelper1 = Nop.Core.Infrastructure.EngineContext.Current.Resolve<Nop.Core.IWebHelper>();
            var storeUrl1 = webHelper1.GetStoreLocation();

            string PaymentServerURL1 = "https://migs.mastercard.com.au/vpcpay?";
            string vpc_Version1 = "&vpc_Version=1";
            string vpc_Command1 = "&vpc_Command=pay";
            string vpc_Merchant1 = "&vpc_Merchant=" + _AaibPaymentSettings.vpc_Merchant;
            string vpc_AccessCode1 = "vpc_AccessCode=" + _AaibPaymentSettings.vpc_AccessCode;
            string SecureSecret1 = "&SecureSecret=" + _AaibPaymentSettings.SecureSecret;
            string vpc_ReturnURL1 = "&vpc_ReturnURL=" + storeUrl1 + "/Plugins/PaymentAaib/PDTHandler";
            string vpc_Currency1 = "&vpc_Currency=EGP";
            string vpc_Locale1 = "&vpc_Locale=en_AU";
            string vpc_SecureHash1 = "&vpc_SecureHash=58F895D840E488BD640613F672FCFD23AB2622353FF8649DC84BBB17D9C3578F";
            string vpc_SecureHashType1 = "&vpc_SecureHashType=SHA256";


            string ipnUrl11 = PaymentServerURL1 +
                              vpc_AccessCode1 +
                              vpc_Command1 +
                              vpc_Currency1+
                              vpc_Locale1+
                              vpc_Merchant1 +
                              vpc_ReturnURL1+
                              vpc_Version1+
                              vpc_SecureHash1+
                              vpc_SecureHashType1;


            _httpContextAccessor.HttpContext.Response.Redirect(ipnUrl11);


        }

        /// <summary>
        /// Returns a value indicating whether payment method should be hidden during checkout
        /// </summary>
        /// <param name="cart">Shopping cart</param>
        /// <returns>true - hide; false - display.</returns>
        public bool HidePaymentMethod(IList<ShoppingCartItem> cart)
        {
            //you can put any logic here
            //for example, hide this payment method if all products in the cart are downloadable
            //or hide this payment method if current customer is from certain country
            return false;
        }

        /// <summary>
        /// Gets additional handling fee
        /// </summary>
        /// <param name="cart">Shopping cart</param>
        /// <returns>Additional handling fee</returns>
        public decimal GetAdditionalHandlingFee(IList<ShoppingCartItem> cart)
        {
             return this.CalculateAdditionalFee(_orderTotalCalculationService, cart,
             _AaibPaymentSettings.AdditionalFee, _AaibPaymentSettings.AdditionalFeePercentage);
      

        }

        /// <summary>
        /// Captures payment
        /// </summary>
        /// <param name="capturePaymentRequest">Capture payment request</param>
        /// <returns>Capture payment result</returns>
        public CapturePaymentResult Capture(CapturePaymentRequest capturePaymentRequest)
        {
            return new CapturePaymentResult { Errors = new[] { "Capture method not supported" } };
        }

        /// <summary>
        /// Refunds a payment
        /// </summary>
        /// <param name="refundPaymentRequest">Request</param>
        /// <returns>Result</returns>
        public RefundPaymentResult Refund(RefundPaymentRequest refundPaymentRequest)
        {
            return new RefundPaymentResult { Errors = new[] { "Refund method not supported" } };
        }

        /// <summary>
        /// Voids a payment
        /// </summary>
        /// <param name="voidPaymentRequest">Request</param>
        /// <returns>Result</returns>
        public VoidPaymentResult Void(VoidPaymentRequest voidPaymentRequest)
        {
            return new VoidPaymentResult { Errors = new[] { "Void method not supported" } };
        }

        /// <summary>
        /// Process recurring payment
        /// </summary>
        /// <param name="processPaymentRequest">Payment info required for an order processing</param>
        /// <returns>Process payment result</returns>
        public ProcessPaymentResult ProcessRecurringPayment(ProcessPaymentRequest processPaymentRequest)
        {
            return new ProcessPaymentResult { Errors = new[] { "Recurring payment not supported" } };
        }

        /// <summary>
        /// Cancels a recurring payment
        /// </summary>
        /// <param name="cancelPaymentRequest">Request</param>
        /// <returns>Result</returns>
        public CancelRecurringPaymentResult CancelRecurringPayment(CancelRecurringPaymentRequest cancelPaymentRequest)
        {
            return new CancelRecurringPaymentResult { Errors = new[] { "Recurring payment not supported" } };
        }

        /// <summary>
        /// Gets a value indicating whether customers can complete a payment after order is placed but not completed (for redirection payment methods)
        /// </summary>
        /// <param name="order">Order</param>
        /// <returns>Result</returns>
        public bool CanRePostProcessPayment(Order order)
        {
            if (order == null)
                throw new ArgumentNullException(nameof(order));
            
            //let's ensure that at least 5 seconds passed after order is placed
            //P.S. there's no any particular reason for that. we just do it
            if ((DateTime.UtcNow - order.CreatedOnUtc).TotalSeconds < 5)
                return false;

            return true;
        }

        /// <summary>
        /// Validate payment form
        /// </summary>
        /// <param name="form">The parsed form values</param>
        /// <returns>List of validating errors</returns>
        public IList<string> ValidatePaymentForm(IFormCollection form)
        {
            return new List<string>();
        }

        /// <summary>
        /// Get payment information
        /// </summary>
        /// <param name="form">The parsed form values</param>
        /// <returns>Payment info holder</returns>
        public ProcessPaymentRequest GetPaymentInfo(IFormCollection form)
        {
            return new ProcessPaymentRequest();
        }

        /// <summary>
        /// Gets a configuration page URL
        /// </summary>
        public override string GetConfigurationPageUrl()
        {
            return $"{_webHelper.GetStoreLocation()}Admin/PaymentAaib/Configure";
        }

        /// <summary>
        /// Gets a view component for displaying plugin in public store ("payment info" checkout step)
        /// </summary>
        /// <param name="viewComponentName">View component name</param>
        public void GetPublicViewComponent(out string viewComponentName)
        {
            viewComponentName = "PaymentAaib";
        }

        /// <summary>
        /// Install the plugin
        /// </summary>
        public override void Install()
        {
            //settings
            _settingService.SaveSetting(new AaibPaymentSettings
            {
                UseSandbox = true
            });

            //locales
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFee", "Additional fee");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFee.Hint", "Enter additional fee to charge your customers.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFeePercentage", "Additional fee. Use percentage");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFeePercentage.Hint", "Determines whether to apply a percentage additional fee to the order total. If not enabled, a fixed value is used.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.BusinessEmail", "Business Email");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.BusinessEmail.Hint", "Specify your Aaib business email.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.PassProductNamesAndTotals", "Pass product names and order totals to Aaib");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.PassProductNamesAndTotals.Hint", "Check if product names and order totals should be passed to Aaib.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTToken", "PDT Identity Token");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTToken.Hint", "Specify PDT identity token");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.RedirectionTip", "You will be redirected to Aaib site to complete the order.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.UseSandbox", "Use Sandbox");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.UseSandbox.Hint", "Check to enable Sandbox (testing environment).");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Instructions", "<p><b>If you're using this gateway ensure that your primary store currency is supported by Aaib.</b><br /><br />To use PDT, you must activate PDT and Auto Return in your Aaib account profile. You must also acquire a PDT identity token, which is used in all PDT communication you send to PayPal. Follow these steps to configure your account for PDT:<br /><br />1. Log in to your PayPal account (click <a href=\"https://www.paypal.com/us/webapps/mpp/referral/paypal-business-account2?partner_id=9JJPJNNPQ7PZ8\" target=\"_blank\">here</a> to create your account).<br />2. Click the Profile subtab.<br />3. Click Website Payment Preferences in the Seller Preferences column.<br />4. Under Auto Return for Website Payments, click the On radio button.<br />5. For the Return URL, enter the URL on your site that will receive the transaction ID posted by PayPal after a customer payment ({0}).<br />6. Under Payment Data Transfer, click the On radio button.<br />7. Click Save.<br />8. Click Website Payment Preferences in the Seller Preferences column.<br />9. Scroll down to the Payment Data Transfer section of the page to view your PDT identity token.<br /><br /></p>");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.PaymentMethodDescription", "You will be redirected to Aaib site to complete the payment");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.RoundingWarning", "It looks like you have \"ShoppingCartSettings.RoundPricesDuringCalculation\" setting disabled. Keep in mind that this can lead to a discrepancy of the order total amount, as Aaib only rounds to two decimals.");
            //edit here by amal
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTValidateOrderTotal", "PDT. Validate order total");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTValidateOrderTotal.Hint", "Check if PDT handler should validate order totals.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.EnableIpn", "Enable IPN (Instant Payment Notification)");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.EnableIpn.Hint", "Check if IPN is enabled.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.EnableIpn.Hint2", "Leave blank to use the default IPN handler URL.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.IpnUrl", "IPN Handler");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.IpnUrl.Hint", "Specify IPN Handler.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.AddressOverride", "Address override");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.AddressOverride.Hint", "For people who already have Aaib accounts and whom you already prompted for a shipping address before they choose to pay with Aaib, you can use the entered address instead of the address the person has stored with Aaib.");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage", "Return to order details page");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage.Hint", "Enable if a customer should be redirected to the order details page when he clicks \"return to store\" link on PayPal site WITHOUT completing a payment");


            //Aaib 26/11/2018
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_Merchant", "vpc_Merchant for Aaib account");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_Merchant.Hint", "check for vpc_Merchant.");

            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_AccessCode", "vpc_AccessCode for Aaib account");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_AccessCode.Hint", "check for vpc_AccessCode.");

            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.SecureSecret", "SecureSecret for Aaib account");
            this.AddOrUpdatePluginLocaleResource("Plugins.Payments.Aaib.Fields.SecureSecret.Hint", "check for SecureSecret.");



            base.Install();
        }

        /// <summary>
        /// Uninstall the plugin
        /// </summary>
        public override void Uninstall()
        {
            //settings
            _settingService.DeleteSetting<AaibPaymentSettings>();

            //locales
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFee");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFee.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFeePercentage");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.AdditionalFeePercentage.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.BusinessEmail");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.BusinessEmail.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.PassProductNamesAndTotals");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.PassProductNamesAndTotals.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTToken");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTToken.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.RedirectionTip");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.UseSandbox");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.UseSandbox.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Instructions");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.PaymentMethodDescription");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.RoundingWarning");
            //edit here by amal
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTValidateOrderTotal");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.PDTValidateOrderTotal.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.EnableIpn");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.EnableIpn.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.EnableIpn.Hint2");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.IpnUrl");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.IpnUrl.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.AddressOverride");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.AddressOverride.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage.Hint");




            //Aaib 26/11/2018
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_Merchant");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_Merchant.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_AccessCode");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.vpc_AccessCode.Hint");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.SecureSecret");
            this.DeletePluginLocaleResource("Plugins.Payments.Aaib.Fields.SecureSecret.Hint");


            base.Uninstall();
        }

        #endregion

        #region Properties

        /// <summary>
        /// Gets a value indicating whether capture is supported
        /// </summary>
        public bool SupportCapture
        {
            get { return false; }
        }

        /// <summary>
        /// Gets a value indicating whether partial refund is supported
        /// </summary>
        public bool SupportPartiallyRefund
        {
            get { return false; }
        }

        /// <summary>
        /// Gets a value indicating whether refund is supported
        /// </summary>
        public bool SupportRefund
        {
            get { return false; }
        }

        /// <summary>
        /// Gets a value indicating whether void is supported
        /// </summary>
        public bool SupportVoid
        {
            get { return true; }
        }

        /// <summary>
        /// Gets a recurring payment type of payment method
        /// </summary>
        public RecurringPaymentType RecurringPaymentType
        {
            get { return RecurringPaymentType.NotSupported; }
        }

        /// <summary>
        /// Gets a payment method type
        /// </summary>
        public PaymentMethodType PaymentMethodType
        {
            get { return PaymentMethodType.Redirection; }
        }

        /// <summary>
        /// Gets a value indicating whether we should display a payment information page for this plugin
        /// </summary>
        public bool SkipPaymentInfo
        {
            get { return true; }
        }

        /// <summary>
        /// Gets a payment method description that will be displayed on checkout pages in the public store
        /// </summary>
        public string PaymentMethodDescription
        {
            //return description of this payment method to be display on "payment method" checkout step. good practice is to make it localizable
            //for example, for a redirection payment method, description may be like this: "You will be redirected to Aaib site to complete the payment"
            get { return _localizationService.GetResource("Plugins.Payments.Aaib.PaymentMethodDescription"); }
        }

        #endregion
    }
}

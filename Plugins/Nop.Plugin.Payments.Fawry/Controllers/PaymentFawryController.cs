using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Nop.Core;
using Nop.Core.Domain.Orders;
using Nop.Core.Domain.Payments;
using Nop.Plugin.Payments.Fawry;
using Nop.Plugin.Payments.Fawry.Models;
using Nop.Services.Common;
using Nop.Services.Configuration;
using Nop.Services.Localization;
using Nop.Services.Logging;
using Nop.Services.Orders;
using Nop.Services.Payments;
using Nop.Services.Security;
using Nop.Services.Stores;
using Nop.Web.Framework;
using Nop.Web.Framework.Controllers;
using Nop.Web.Framework.Mvc.Filters;

namespace Nop.Plugin.Payments.Fawry.Controllers
{
    public class PaymentFawryController : BasePaymentController
    {
        #region Fields

        private readonly IWorkContext _workContext;
        private readonly IStoreService _storeService;
        private readonly ISettingService _settingService;
        private readonly IPaymentService _paymentService;
        private readonly IOrderService _orderService;
        private readonly IOrderProcessingService _orderProcessingService;
        private readonly IPermissionService _permissionService;
        private readonly IGenericAttributeService _genericAttributeService;
        private readonly ILocalizationService _localizationService;
        private readonly IStoreContext _storeContext;
        private readonly ILogger _logger;
        private readonly IWebHelper _webHelper;
        private readonly PaymentSettings _paymentSettings;
        private readonly FawryPaymentSettings _fawryPaymentSettings;
        private readonly ShoppingCartSettings _shoppingCartSettings;

        #endregion

        #region Ctor

        public PaymentFawryController(IWorkContext workContext,
            IStoreService storeService, 
            ISettingService settingService, 
            IPaymentService paymentService, 
            IOrderService orderService, 
            IOrderProcessingService orderProcessingService,
            IPermissionService permissionService,
            IGenericAttributeService genericAttributeService,
            ILocalizationService localizationService,
            IStoreContext storeContext,
            ILogger logger, 
            IWebHelper webHelper,
            PaymentSettings paymentSettings,
            FawryPaymentSettings fawryPaymentSettings,
            ShoppingCartSettings shoppingCartSettings)
        {
            this._workContext = workContext;
            this._storeService = storeService;
            this._settingService = settingService;
            this._paymentService = paymentService;
            this._orderService = orderService;
            this._orderProcessingService = orderProcessingService;
            this._permissionService = permissionService;
            this._genericAttributeService = genericAttributeService;
            this._localizationService = localizationService;
            this._storeContext = storeContext;
            this._logger = logger;
            this._webHelper = webHelper;
            this._paymentSettings = paymentSettings;
            this._fawryPaymentSettings = fawryPaymentSettings;
            this._shoppingCartSettings = shoppingCartSettings;
        }

        #endregion

        #region Methods

        [AuthorizeAdmin]
        [Area(AreaNames.Admin)]
        public IActionResult Configure()
        {
            if (!_permissionService.Authorize(StandardPermissionProvider.ManagePaymentMethods))
                return AccessDeniedView();

            //load settings for a chosen store scope
            var storeScope = this.GetActiveStoreScopeConfiguration(_storeService, _workContext);
            var fawryPaymentSettings = _settingService.LoadSetting<FawryPaymentSettings>(storeScope);

            var model = new ConfigurationModel
            {
                UseSandbox = fawryPaymentSettings.UseSandbox,
                BusinessEmail = fawryPaymentSettings.BusinessEmail,
                PdtToken = fawryPaymentSettings.PdtToken,
                PassProductNamesAndTotals = fawryPaymentSettings.PassProductNamesAndTotals,
                AdditionalFee = fawryPaymentSettings.AdditionalFee,
                AdditionalFeePercentage = fawryPaymentSettings.AdditionalFeePercentage,
                ActiveStoreScopeConfiguration = storeScope,
                //edit here by amal
                PdtValidateOrderTotal = fawryPaymentSettings.PdtValidateOrderTotal,
                EnableIpn = fawryPaymentSettings.EnableIpn,
                IpnUrl = fawryPaymentSettings.IpnUrl,
                AddressOverride = fawryPaymentSettings.AddressOverride,
                ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage = fawryPaymentSettings.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage,
                //amal 23/9/2018
                AdminName = fawryPaymentSettings.AdminName,
                AdminEmail = fawryPaymentSettings.AdminEmail,
                OrderExpiry = fawryPaymentSettings.OrderExpiry


            };
            if (storeScope > 0)
            {
                model.UseSandbox_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.UseSandbox, storeScope);
                model.BusinessEmail_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.BusinessEmail, storeScope);
                model.PdtToken_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.PdtToken, storeScope);
                model.PassProductNamesAndTotals_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.PassProductNamesAndTotals, storeScope);
                model.AdditionalFee_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.AdditionalFee, storeScope);
                model.AdditionalFeePercentage_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.AdditionalFeePercentage, storeScope);
                //edit here by amal
                model.PdtValidateOrderTotal_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.PdtValidateOrderTotal, storeScope);
                model.EnableIpn_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.EnableIpn, storeScope);
                model.IpnUrl_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.IpnUrl, storeScope);
                model.AddressOverride_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.AddressOverride, storeScope);
                model.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage, storeScope);

                //amal 23/9/2018
                model.AdminName_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.AdminName, storeScope);
                model.AdminEmail_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.AdminEmail, storeScope);
                model.OrderExpiry_OverrideForStore = _settingService.SettingExists(fawryPaymentSettings, x => x.OrderExpiry, storeScope);
            }

            return View("~/Plugins/Payments.Fawry/Views/Configure.cshtml", model);
        }

        [HttpPost]
        [AuthorizeAdmin]
        [AdminAntiForgery]
        [Area(AreaNames.Admin)]
        public IActionResult Configure(ConfigurationModel model)
        {
            if (!_permissionService.Authorize(StandardPermissionProvider.ManagePaymentMethods))
                return AccessDeniedView();

            if (!ModelState.IsValid)
                return Configure();

            //load settings for a chosen store scope
            var storeScope = this.GetActiveStoreScopeConfiguration(_storeService, _workContext);
            var fawryPaymentSettings = _settingService.LoadSetting<FawryPaymentSettings>(storeScope);

            //save settings
            fawryPaymentSettings.UseSandbox = model.UseSandbox;
            fawryPaymentSettings.BusinessEmail = model.BusinessEmail;
            fawryPaymentSettings.PdtToken = model.PdtToken;
            fawryPaymentSettings.PassProductNamesAndTotals = model.PassProductNamesAndTotals;
            fawryPaymentSettings.AdditionalFee = model.AdditionalFee;
            fawryPaymentSettings.AdditionalFeePercentage = model.AdditionalFeePercentage;
            //edit here by amal
            fawryPaymentSettings.PdtValidateOrderTotal = model.PdtValidateOrderTotal;
            fawryPaymentSettings.EnableIpn = model.EnableIpn;
            fawryPaymentSettings.IpnUrl = model.IpnUrl;
            fawryPaymentSettings.AddressOverride = model.AddressOverride;
            fawryPaymentSettings.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage = model.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage;

            //amal 23/9/2018
            fawryPaymentSettings.AdminName = model.AdminName;
            fawryPaymentSettings.AdminEmail = model.AdminEmail;
            fawryPaymentSettings.OrderExpiry = model.OrderExpiry;

            /* We do not clear cache after each setting update.
             * This behavior can increase performance because cached settings will not be cleared 
             * and loaded from database after each update */
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.UseSandbox, model.UseSandbox_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.BusinessEmail, model.BusinessEmail_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.PdtToken, model.PdtToken_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.PassProductNamesAndTotals, model.PassProductNamesAndTotals_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.AdditionalFee, model.AdditionalFee_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.AdditionalFeePercentage, model.AdditionalFeePercentage_OverrideForStore, storeScope, false);
            //edit here by amal
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.PdtValidateOrderTotal, model.PdtValidateOrderTotal_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.EnableIpn, model.EnableIpn_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.IpnUrl, model.IpnUrl_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.AddressOverride, model.AddressOverride_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage, model.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage_OverrideForStore, storeScope, false);


            //amal 23/9/2018
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.AdminName, model.AdminName_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.AdminEmail, model.AdminEmail_OverrideForStore, storeScope, false);
            _settingService.SaveSettingOverridablePerStore(fawryPaymentSettings, x => x.OrderExpiry, model.OrderExpiry_OverrideForStore, storeScope, false);



            //now clear settings cache
            _settingService.ClearCache();

            SuccessNotification(_localizationService.GetResource("Admin.Plugins.Saved"));

            return Configure();
        }

        //action displaying notification (warning) to a store owner about inaccurate PayPal rounding
        [AuthorizeAdmin]
        [Area(AreaNames.Admin)]
        public IActionResult RoundingWarning(bool passProductNamesAndTotals)
        {
            if (!_permissionService.Authorize(StandardPermissionProvider.ManagePaymentMethods))
                return AccessDeniedView();

            //prices and total aren't rounded, so display warning
            if (passProductNamesAndTotals && !_shoppingCartSettings.RoundPricesDuringCalculation)
                return Json(new { Result = _localizationService.GetResource("Plugins.Payments.PayPalStandard.RoundingWarning") });

            return Json(new { Result = string.Empty });
        }
        
        public IActionResult PDTHandler()
        {
            if (_webHelper.QueryString<string>("FawryRefNo") != null)
            {
                var MerchantRefNo = Convert.ToInt16(_webHelper.QueryString<string>("MerchantRefNo"));
                var order = _orderService.GetOrderById(MerchantRefNo);
                var OrderStatus = _webHelper.QueryString<string>("OrderStatus");
                var FawryRefNo= _webHelper.QueryString<string>("FawryRefNo");          
                if (order != null && OrderStatus != null && FawryRefNo != null)
                {
                    if (OrderStatus == "NEW")
                    {
                        return RedirectToRoute("CheckoutCompleted", new { orderId = order.Id });
                    }
                    else if (OrderStatus == "EXPIRED")
                    {
                        _orderProcessingService.CancelOrder(order, false);
                    }
                    else if (OrderStatus == "PAID")
                    {
                        _orderProcessingService.MarkOrderAsPaid(order);
                    }
                }               
            }
            else
            {
                var MerchantRefNo = Convert.ToInt16(_webHelper.QueryString<string>("merchantRefNum"));
                var order = _orderService.GetOrderById(MerchantRefNo);
                _orderProcessingService.CancelOrder(order, false);
            }
            return RedirectToAction("Index", "Home", new { area = "" });
        }

        public IActionResult IPNHandler()
        {
            byte[] parameters;
            using (var stream = new MemoryStream())
            {
                this.Request.Body.CopyTo(stream);
                parameters = stream.ToArray();
            }
            var strRequest = Encoding.ASCII.GetString(parameters);

            var processor = _paymentService.LoadPaymentMethodBySystemName("Payments.Farwy") as FawryPaymentProcessor;
            if (processor == null ||
                !processor.IsPaymentMethodActive(_paymentSettings) || !processor.PluginDescriptor.Installed)
                throw new NopException("Fawry module cannot be loaded");

            if (processor.VerifyIpn(strRequest, out Dictionary<string, string> values))
            {
                #region values
                var mc_gross = decimal.Zero;
                try
                {
                    mc_gross = decimal.Parse(values["mc_gross"], new CultureInfo("en-US"));
                }
                catch { }

                values.TryGetValue("payer_status", out string payer_status);
                values.TryGetValue("payment_status", out string payment_status);
                values.TryGetValue("pending_reason", out string pending_reason);
                values.TryGetValue("mc_currency", out string mc_currency);
                values.TryGetValue("txn_id", out string txn_id);
                values.TryGetValue("txn_type", out string txn_type);
                values.TryGetValue("rp_invoice_id", out string rp_invoice_id);
                values.TryGetValue("payment_type", out string payment_type);
                values.TryGetValue("payer_id", out string payer_id);
                values.TryGetValue("receiver_id", out string receiver_id);
                values.TryGetValue("invoice", out string _);
                values.TryGetValue("payment_fee", out string payment_fee);

                #endregion

                var sb = new StringBuilder();
                sb.AppendLine("Farwy IPN:");
                foreach (var kvp in values)
                {
                    sb.AppendLine(kvp.Key + ": " + kvp.Value);
                }

                var newPaymentStatus = FawryHelper.GetPaymentStatus(payment_status, pending_reason);
                sb.AppendLine("New payment status: " + newPaymentStatus);

                switch (txn_type)
                {
                    case "recurring_payment_profile_created":
                        //do nothing here
                        break;
                    #region Recurring payment
                    case "recurring_payment":
                        {
                            var orderNumberGuid = Guid.Empty;
                            try
                            {
                                orderNumberGuid = new Guid(rp_invoice_id);
                            }
                            catch
                            {
                            }

                            var initialOrder = _orderService.GetOrderByGuid(orderNumberGuid);
                            if (initialOrder != null)
                            {
                                var recurringPayments = _orderService.SearchRecurringPayments(initialOrderId: initialOrder.Id);
                                foreach (var rp in recurringPayments)
                                {
                                    switch (newPaymentStatus)
                                    {
                                        case PaymentStatus.Authorized:
                                        case PaymentStatus.Paid:
                                            {
                                                var recurringPaymentHistory = rp.RecurringPaymentHistory;
                                                if (!recurringPaymentHistory.Any())
                                                {
                                                    //first payment
                                                    var rph = new RecurringPaymentHistory
                                                    {
                                                        RecurringPaymentId = rp.Id,
                                                        OrderId = initialOrder.Id,
                                                        CreatedOnUtc = DateTime.UtcNow
                                                    };
                                                    rp.RecurringPaymentHistory.Add(rph);
                                                    _orderService.UpdateRecurringPayment(rp);
                                                }
                                                else
                                                {
                                                    //next payments
                                                    var processPaymentResult = new ProcessPaymentResult
                                                    {
                                                        NewPaymentStatus = newPaymentStatus
                                                    };
                                                    if (newPaymentStatus == PaymentStatus.Authorized)
                                                        processPaymentResult.AuthorizationTransactionId = txn_id;
                                                    else
                                                        processPaymentResult.CaptureTransactionId = txn_id;

                                                    _orderProcessingService.ProcessNextRecurringPayment(rp, processPaymentResult);
                                                }
                                            }
                                            break;
                                        case PaymentStatus.Voided:
                                            //failed payment
                                            var failedPaymentResult = new ProcessPaymentResult
                                            {
                                                Errors = new[] {$"PayPal IPN. Recurring payment is {payment_status} ."},
                                                RecurringPaymentFailed = true
                                            };
                                            _orderProcessingService.ProcessNextRecurringPayment(rp, failedPaymentResult);
                                            break;
                                    }
                                }

                                //this.OrderService.InsertOrderNote(newOrder.OrderId, sb.ToString(), DateTime.UtcNow);
                                _logger.Information("PayPal IPN. Recurring info", new NopException(sb.ToString()));
                            }
                            else
                            {
                                _logger.Error("PayPal IPN. Order is not found", new NopException(sb.ToString()));
                            }
                        }                       
                        break;
                    case "recurring_payment_failed":
                        if (Guid.TryParse(rp_invoice_id, out Guid orderGuid))
                        {
                            var initialOrder = _orderService.GetOrderByGuid(orderGuid);
                            if (initialOrder != null)
                            {
                                var recurringPayment = _orderService.SearchRecurringPayments(initialOrderId: initialOrder.Id).FirstOrDefault();
                                //failed payment
                                if (recurringPayment != null)
                                    _orderProcessingService.ProcessNextRecurringPayment(recurringPayment, new ProcessPaymentResult { Errors = new[] { txn_type }, RecurringPaymentFailed = true });
                            }
                        }
                        break;
                    #endregion
                    default:
                        #region Standard payment
                        {
                            values.TryGetValue("custom", out string orderNumber);
                            var orderNumberGuid = Guid.Empty;
                            try
                            {
                                orderNumberGuid = new Guid(orderNumber);
                            }
                            catch
                            {
                            }

                            var order = _orderService.GetOrderByGuid(orderNumberGuid);
                            if (order != null)
                            {

                                //order note
                                order.OrderNotes.Add(new OrderNote
                                {
                                    Note = sb.ToString(),
                                    DisplayToCustomer = false,
                                    CreatedOnUtc = DateTime.UtcNow
                                });
                                _orderService.UpdateOrder(order);

                                switch (newPaymentStatus)
                                {
                                    case PaymentStatus.Pending:
                                        {
                                        }
                                        break;
                                    case PaymentStatus.Authorized:
                                        {
                                            //validate order total
                                            if (Math.Round(mc_gross, 2).Equals(Math.Round(order.OrderTotal, 2)))
                                            {
                                                //valid
                                                if (_orderProcessingService.CanMarkOrderAsAuthorized(order))
                                                {
                                                    _orderProcessingService.MarkAsAuthorized(order);
                                                }
                                            }
                                            else
                                            {
                                                //not valid
                                                var errorStr =
                                                    $"Fawry IPN. Returned order total {mc_gross} doesn't equal order total {order.OrderTotal}. Order# {order.Id}.";
                                                //log
                                                _logger.Error(errorStr);
                                                //order note
                                                order.OrderNotes.Add(new OrderNote
                                                {
                                                    Note = errorStr,
                                                    DisplayToCustomer = false,
                                                    CreatedOnUtc = DateTime.UtcNow
                                                });
                                                _orderService.UpdateOrder(order);
                                            }
                                        }
                                        break;
                                    case PaymentStatus.Paid:
                                        {
                                            //validate order total
                                            if (Math.Round(mc_gross, 2).Equals(Math.Round(order.OrderTotal, 2)))
                                            {
                                                //valid
                                                if (_orderProcessingService.CanMarkOrderAsPaid(order))
                                                {
                                                    order.AuthorizationTransactionId = txn_id;
                                                    _orderService.UpdateOrder(order);

                                                    _orderProcessingService.MarkOrderAsPaid(order);
                                                }
                                            }
                                            else
                                            {
                                                //not valid
                                                var errorStr =
                                                    $"Fawry IPN. Returned order total {mc_gross} doesn't equal order total {order.OrderTotal}. Order# {order.Id}.";
                                                //log
                                                _logger.Error(errorStr);
                                                //order note
                                                order.OrderNotes.Add(new OrderNote
                                                {
                                                    Note = errorStr,
                                                    DisplayToCustomer = false,
                                                    CreatedOnUtc = DateTime.UtcNow
                                                });
                                                _orderService.UpdateOrder(order);
                                            }
                                        }
                                        break;
                                    case PaymentStatus.Refunded:
                                        {
                                            var totalToRefund = Math.Abs(mc_gross);
                                            if (totalToRefund > 0 && Math.Round(totalToRefund, 2).Equals(Math.Round(order.OrderTotal, 2)))
                                            {
                                                //refund
                                                if (_orderProcessingService.CanRefundOffline(order))
                                                {
                                                    _orderProcessingService.RefundOffline(order);
                                                }
                                            }
                                            else
                                            {
                                                //partial refund
                                                if (_orderProcessingService.CanPartiallyRefundOffline(order, totalToRefund))
                                                {
                                                    _orderProcessingService.PartiallyRefundOffline(order, totalToRefund);
                                                }
                                            }
                                        }
                                        break;
                                    case PaymentStatus.Voided:
                                        {
                                            if (_orderProcessingService.CanVoidOffline(order))
                                            {
                                                _orderProcessingService.VoidOffline(order);
                                            }
                                        }
                                        break;
                                    default:
                                        break;
                                }
                            }
                            else
                            {
                                _logger.Error("Fawry IPN. Order is not found", new NopException(sb.ToString()));
                            }
                        }
                        #endregion
                        break;
                }
            }
            else
            {
                _logger.Error("Fawry IPN failed.", new NopException(strRequest));
            }

            //nothing should be rendered to visitor
            return Content("");
        }

        public IActionResult CancelOrder()
        {
            var order = _orderService.SearchOrders(storeId: _storeContext.CurrentStore.Id, 
                customerId: _workContext.CurrentCustomer.Id, pageSize: 1).FirstOrDefault();
            if (order != null)
                return RedirectToRoute("OrderDetails", new { orderId = order.Id });


            return RedirectToRoute("HomePage");
        }

        #endregion
    }
}
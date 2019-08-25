using Nop.Web.Framework.Mvc.ModelBinding;
using Nop.Web.Framework.Mvc.Models;

namespace Nop.Plugin.Payments.Fawry.Models
{
    public class ConfigurationModel : BaseNopModel
    {
        public int ActiveStoreScopeConfiguration { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.UseSandbox")]
        public bool UseSandbox { get; set; }
        public bool UseSandbox_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.BusinessEmail")]
        public string BusinessEmail { get; set; }
        public bool BusinessEmail_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.PDTToken")]
        public string PdtToken { get; set; }
        public bool PdtToken_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.PassProductNamesAndTotals")]
        public bool PassProductNamesAndTotals { get; set; }
        public bool PassProductNamesAndTotals_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.AdditionalFee")]
        public decimal AdditionalFee { get; set; }
        public bool AdditionalFee_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.AdditionalFeePercentage")]
        public bool AdditionalFeePercentage { get; set; }
        public bool AdditionalFeePercentage_OverrideForStore { get; set; }




        //edit here by amal
        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.PDTValidateOrderTotal")]////
        public bool PdtValidateOrderTotal { get; set; }////
        public bool PdtValidateOrderTotal_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.EnableIpn")]////
        public bool EnableIpn { get; set; }////
        public bool EnableIpn_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.IpnUrl")]////
        public string IpnUrl { get; set; }////
        public bool IpnUrl_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.AddressOverride")]////
        public bool AddressOverride { get; set; }////
        public bool AddressOverride_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage")]////
        public bool ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage { get; set; }////
        public bool ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage_OverrideForStore { get; set; }////



        //amal 23/9/2018
        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.AdminName")]
        public string AdminName { get; set; }
        public bool AdminName_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.AdminEmail")]
        public string AdminEmail { get; set; }
        public bool AdminEmail_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Fawry.Fields.OrderExpiry")]
        public int OrderExpiry { get; set; }
        public bool OrderExpiry_OverrideForStore { get; set; }





    }
}
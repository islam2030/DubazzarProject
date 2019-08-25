using Nop.Web.Framework.Mvc.ModelBinding;
using Nop.Web.Framework.Mvc.Models;

namespace Nop.Plugin.Payments.Aaib.Models
{
    public class ConfigurationModel : BaseNopModel
    {
        public int ActiveStoreScopeConfiguration { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.UseSandbox")]
        public bool UseSandbox { get; set; }
        public bool UseSandbox_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.BusinessEmail")]
        public string BusinessEmail { get; set; }
        public bool BusinessEmail_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.PDTToken")]
        public string PdtToken { get; set; }
        public bool PdtToken_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.PassProductNamesAndTotals")]
        public bool PassProductNamesAndTotals { get; set; }
        public bool PassProductNamesAndTotals_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.AdditionalFee")]
        public decimal AdditionalFee { get; set; }
        public bool AdditionalFee_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.AdditionalFeePercentage")]
        public bool AdditionalFeePercentage { get; set; }
        public bool AdditionalFeePercentage_OverrideForStore { get; set; }




        //edit here by amal
        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.PDTValidateOrderTotal")]////
        public bool PdtValidateOrderTotal { get; set; }////
        public bool PdtValidateOrderTotal_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.EnableIpn")]////
        public bool EnableIpn { get; set; }////
        public bool EnableIpn_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.IpnUrl")]////
        public string IpnUrl { get; set; }////
        public bool IpnUrl_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.AddressOverride")]////
        public bool AddressOverride { get; set; }////
        public bool AddressOverride_OverrideForStore { get; set; }////

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage")]////
        public bool ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage { get; set; }////
        public bool ReturnFromPayPalWithoutPaymentRedirectsToOrderDetailsPage_OverrideForStore { get; set; }////



        //Aaib 26/11/2018

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.vpc_Merchant")]
        public string vpc_Merchant { get; set; }
        public bool vpc_Merchant_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.vpc_AccessCode")]
        public string vpc_AccessCode { get; set; }
        public bool vpc_AccessCode_OverrideForStore { get; set; }

        [NopResourceDisplayName("Plugins.Payments.Aaib.Fields.SecureSecret")]
        public string SecureSecret { get; set; }
        public bool SecureSecret_OverrideForStore { get; set; }


    }
}
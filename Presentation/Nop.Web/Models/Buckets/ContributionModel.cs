using Nop.Web.Framework.Mvc.ModelBinding;
using Nop.Web.Framework.Mvc.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Nop.Web.Models.Buckets
{
    public class ContributionModel : BaseNopEntityModel
    {
        
        [NopResourceDisplayName("Gift.Fields.Amount")]
        public decimal Amount { get; set; }
        [NopResourceDisplayName("Gift.Fields.BucketCode")]
        public string BucketCode { get; set; }
    }
}

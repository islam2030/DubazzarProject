using Microsoft.AspNetCore.Mvc.Rendering;
using Nop.Core.Domain.Buckets;
using Nop.Web.Framework.Localization;
using Nop.Web.Framework.Mvc.ModelBinding;
using Nop.Web.Framework.Mvc.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Nop.Web.Models.Buckets
{
    public partial class BucketModel : BaseNopEntityModel
    {
        public BucketModel()
        {
           
            this.bucketTypes = new List<SelectListItem>();
        }
        [NopResourceDisplayName("Bucket.Fields.BucketTitle")]
        public string BucketTitle { get; set; }
       
        [NopResourceDisplayName("Bucket.Fields.EndDate")]
        public DateTime DueDate { get; set; }
    
        [NopResourceDisplayName("Bucket.Fields.EventType")]
        public int BucketTypeId { get; set; }
        public IList<SelectListItem> bucketTypes { get; set; }
        [NopResourceDisplayName("Bucket.Fields.Description")]
        public string BucketDesc { get; set; }
        [NopResourceDisplayName("Bucket.Fields.Published")]
        public bool IsActive { get; set; }
    }

}

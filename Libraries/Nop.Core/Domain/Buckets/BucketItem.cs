using Nop.Core.Domain.Catalog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Core.Domain.Buckets
{
  public class BucketItem:BaseEntity
    {
        public int ProductId { get; set; }
        public int BucketId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice { get; set; }
        public DateTime AddDate { get; set; }
        public virtual Bucket Bucket { get; set; }
        public virtual Product Product { get; set; }
    }
}

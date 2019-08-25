using Nop.Core.Domain.Customers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Core.Domain.Buckets
{
   public class Contribution:BaseEntity
    {
        public int BucketId { get; set; }
        public int CustomerId { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public string Notes { get; set; }
        public virtual Customer Customer { get; set; }
        public virtual Bucket Bucket { get; set; }
    }
}

using Nop.Core.Domain.Customers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Core.Domain.Buckets
{
   public class Bucket : BaseEntity
    {
        public Bucket()
        {
            this.BucketCode = Guid.NewGuid();
        }
        public Guid BucketCode { get; set; }
        public string  BucketTitle { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime DueDate { get; set; }
        public decimal BucketAmount { get; set; }
        public int StatusId { get; set; }
        public int BucketTypeId { get; set; }
        public bool BucketDeleted { get; set; }
        public string BucketDesc { get; set; }
        public bool IsActive { get; set; }
        public int CustomerId  { get; set; }
        private  ICollection<Contribution> _Contributions { get; set; }
        public virtual ICollection<Contribution> Contributions
        {
            get { return _Contributions ?? (_Contributions = new List<Contribution>()); }
            protected set { _Contributions = value; }
        }
        public virtual Customer Customer { get; set; }
        public virtual BucketType BucketType { get; set; }
        public virtual Status Status { get; set; }
        private ICollection<BucketItem> _BucketItems { get; set; }
        public virtual ICollection<BucketItem> BucketItems
        {
            get { return _BucketItems ?? (_BucketItems = new List<BucketItem>()); }
            protected set { _BucketItems = value; }
        }
    }
}

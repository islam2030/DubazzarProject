using Nop.Core.Domain.Buckets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Data.Mapping.Buckets
{
   public partial class BucketItemMap: NopEntityTypeConfiguration<BucketItem>
    {
        public BucketItemMap()
        {
            this.ToTable("BucketItem");
            this.HasKey(c => c.Id);
         
            this.HasRequired(c => c.Bucket)
              .WithMany(b => b.BucketItems)
              .HasForeignKey(b => b.BucketId);
            this.HasRequired(c => c.Product)
              .WithMany(b => b.BucketItems)
              .HasForeignKey(b => b.ProductId);
        }
    }
}

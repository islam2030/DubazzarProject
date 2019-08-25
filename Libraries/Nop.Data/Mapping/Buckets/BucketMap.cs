using Nop.Core.Domain.Buckets;
using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace Nop.Data.Mapping.Buckets
{

    public partial class BucketMap : NopEntityTypeConfiguration<Bucket>
    {
        public BucketMap()
        {
            this.ToTable("Bucket");
            this.HasKey(b => b.Id);

            this.Property(b => b.BucketAmount);
          //  this.Property(b=>b.BucketCode ).HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity).IsRequired();
            this.Property(b => b.BucketDeleted);
            this.Property(b => b.BucketDesc).HasMaxLength(600);
            this.Property(b => b.BucketTitle).HasMaxLength(100);
            this.Property(b => b.CreateDate).IsRequired();
            this.HasRequired(b => b.Customer)
                .WithMany(b => b.Buckets)
                .HasForeignKey(b => b.CustomerId);
            this.HasRequired(b => b.Status)
               .WithMany(b => b.Buckets)
               .HasForeignKey(b => b.StatusId);
            this.HasRequired(b => b.BucketType)
               .WithMany(b => b.Buckets)
               .HasForeignKey(b => b.BucketTypeId);
        }
    }
}

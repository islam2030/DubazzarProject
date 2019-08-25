using Nop.Core.Domain.Buckets;



namespace Nop.Data.Mapping.Buckets
{
  public partial  class ContributionMap : NopEntityTypeConfiguration<Contribution>
    {
        public ContributionMap()
        {
            this.ToTable("Contribution");
            this.HasKey(c => c.Id);
            this.Property(c => c.Notes).HasMaxLength(200);
            this.HasRequired(c => c.Bucket)
              .WithMany(b => b.Contributions)
              .HasForeignKey(b => b.BucketId).WillCascadeOnDelete(false);
            this.HasRequired(c => c.Customer)
              .WithMany(b => b.Contributions)
              .HasForeignKey(b => b.CustomerId).WillCascadeOnDelete(false);
        }
    }
}

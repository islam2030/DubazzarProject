using Nop.Core.Domain.Vendors;

namespace Nop.Data.Mapping.Vendors
{
    /// <summary>
    /// Mapping class
    /// </summary>
    public partial class VendorMap : NopEntityTypeConfiguration<Vendor>
    {
        /// <summary>
        /// Ctor
        /// </summary>
        public VendorMap()
        {
            this.ToTable("Vendor");
            this.HasKey(v => v.Id);

            this.Property(v => v.Name).IsRequired().HasMaxLength(400);
            this.Property(v => v.Email).HasMaxLength(400);
            this.Property(v => v.MetaKeywords).HasMaxLength(400);
            this.Property(v => v.MetaTitle).HasMaxLength(400);
            this.Property(v => v.PageSizeOptions).HasMaxLength(200);

            //Finance 11/8/2018
            this.Property(v => v.PickFee).HasPrecision(18, 4);


            this.Property(v => v.BankName).HasMaxLength(400);
            this.Property(v => v.AccountNumber).HasMaxLength(400);
            this.Property(v => v.IBAN).HasMaxLength(400);
            this.Property(v => v.SwftCode).HasMaxLength(400);
            this.Property(v => v.Currancy).HasMaxLength(400);
            this.Property(v => v.Branch).HasMaxLength(400);
            this.Property(v => v.Country).HasMaxLength(400);

        }
    }
}
using Nop.Core.Domain.Buckets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Data.Mapping.Buckets
{
  public partial  class StatusMap:NopEntityTypeConfiguration<Status>
    {
        public StatusMap()
        {
            this.ToTable("Status");
            this.HasKey(c => c.Id);
        }
    }
}

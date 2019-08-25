using Nop.Core.Domain.Buckets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Services.Buckets
{
    public partial interface IBucketTypeService
    {
        IList<BucketType> GetAllBucketTypes();
    }
}

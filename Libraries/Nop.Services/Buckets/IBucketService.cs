using Nop.Core;
using Nop.Core.Domain.Buckets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Services.Buckets
{
    public partial interface IBucketService
    {

        IList<Bucket> GetAllBuckets();
        Bucket InsertBucket(Bucket Bucket);
        Bucket UpdateBucket(Bucket Bucket);
        Bucket GetBucketById(int id);
        Bucket GetBucketByCode(Guid code);
    }
}

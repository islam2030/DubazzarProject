using Nop.Core.Domain.Buckets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Services.Buckets
{
public partial interface IBucketItemService
    {
        IList<BucketItem> GetAllBucketsByBucketId(int BucketId);
        BucketItem InsertBucket(BucketItem bucketItem);
        BucketItem UpdateBucket(BucketItem bucketItem);
        int CountItemsByBucketId(int bucketId);
        BucketItem GetItemById(int id);
        void DeleteItemById(int id);
        BucketItem CheckIfExists(int bucketId,int itemId);
    }
}

using Nop.Core;
using Nop.Core.Caching;
using Nop.Core.Data;
using Nop.Core.Domain.Buckets;
using Nop.Data;
using Nop.Services.Events;
using Nop.Services.Security;
using Nop.Services.Stores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Services.Buckets
{
  public partial  class BucketItemService : IBucketItemService
    {
        private readonly IRepository<BucketItem> _BucketItemRepository;
        private readonly IDbContext _dbContext;
        private readonly IDataProvider _dataProvider;
        private readonly IWorkContext _workContext;
        private readonly IStoreContext _storeContext;
        private readonly IEventPublisher _eventPublisher;
        private readonly ICacheManager _cacheManager;
        private readonly IStoreMappingService _storeMappingService;
        private readonly IAclService _aclService;
        public BucketItemService(ICacheManager cacheManager,
          IRepository<BucketItem> BucketItemRepository,
          IDbContext dbContext,
          IDataProvider dataProvider,
          IWorkContext workContext,
          IStoreContext storeContext,
          IEventPublisher eventPublisher,
          IStoreMappingService storeMappingService,
          IAclService aclService)
        {
            this._cacheManager = cacheManager;
            this._BucketItemRepository = BucketItemRepository;
            this._dbContext = dbContext;
            this._dataProvider = dataProvider;
            this._workContext = workContext;
            this._storeContext = storeContext;
            this._eventPublisher = eventPublisher;
            this._storeMappingService = storeMappingService;
            this._aclService = aclService;
        }

        public BucketItem CheckIfExists(int bucketId, int itemId)
        {
            var item= _BucketItemRepository.Table.Where(c => c.BucketId == bucketId &&c.ProductId==itemId).FirstOrDefault();
            return item;
        }

        public int CountItemsByBucketId(int bucketId)
        {
           return _BucketItemRepository.Table.Where(c => c.BucketId == bucketId).ToList().Count;
        }

        public IList<BucketItem> GetAllBucketsByBucketId(int bucketId)
        {
            var query = _BucketItemRepository.Table.Where(c => c.BucketId == bucketId).ToList();
            return query;
        }

        public BucketItem GetItemById(int id)
        {
            var query = _BucketItemRepository.Table.Where(c => c.Id == id).FirstOrDefault();
            return query;

        }
        public void DeleteItemById(int id)
        {
            _BucketItemRepository.Delete(GetItemById(id)) ;

        }

        public BucketItem InsertBucket(BucketItem bucketItem)
        {
            if (bucketItem == null)
                throw new ArgumentNullException(nameof(BucketItem));

            //Bucket.CustomerId = _workContext.CurrentCustomer.Id;
            _BucketItemRepository.Insert(bucketItem);
            return bucketItem;
        }

        public BucketItem UpdateBucket(BucketItem bucketItem)
        {

            if (bucketItem == null)
                throw new ArgumentNullException(nameof(BucketItem));
            _BucketItemRepository.Update(bucketItem);
            return bucketItem;
        }
    }
}

using Nop.Core;
using Nop.Core.Caching;
using Nop.Core.Data;
using Nop.Data;
using Nop.Services.Events;
using Nop.Services.Stores;
using Nop.Services.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Nop.Core.Domain.Buckets;

namespace Nop.Services.Buckets
{
  public partial  class BucketService: IBucketService
    {
        private readonly IRepository<Bucket> _BucketRepository;
        private readonly IDbContext _dbContext;
        private readonly IDataProvider _dataProvider;
        private readonly IWorkContext _workContext;
        private readonly IStoreContext _storeContext;
        private readonly IEventPublisher _eventPublisher;
        private readonly ICacheManager _cacheManager;
        private readonly IStoreMappingService _storeMappingService;
        private readonly IAclService _aclService;
        public BucketService(ICacheManager cacheManager,
          IRepository<Bucket> BucketRepository,
          IDbContext dbContext,
          IDataProvider dataProvider,
          IWorkContext workContext,
          IStoreContext storeContext,
          IEventPublisher eventPublisher,
          IStoreMappingService storeMappingService,
          IAclService aclService)
        {
            this._cacheManager = cacheManager;
            this._BucketRepository = BucketRepository;
            this._dbContext = dbContext;
            this._dataProvider = dataProvider;
            this._workContext = workContext;
            this._storeContext = storeContext;
            this._eventPublisher = eventPublisher;
            this._storeMappingService = storeMappingService;
            this._aclService = aclService;
        }

        public IList<Bucket> GetAllBuckets()
        {
            var query = _BucketRepository.Table.Where(c => c.CustomerId== 189458).ToList();
            return query;

        }
        public virtual Bucket InsertBucket(Bucket Bucket)
        {
            if (Bucket == null)
                throw new ArgumentNullException(nameof(Bucket));

            //Bucket.CustomerId = _workContext.CurrentCustomer.Id;
            _BucketRepository.Insert(Bucket);
            return Bucket;
        }
        public virtual Bucket UpdateBucket(Bucket Bucket)
        {
            if (Bucket == null)
                throw new ArgumentNullException(nameof(Bucket));
            _BucketRepository.Update(Bucket);
            return Bucket;
        }
        public virtual Bucket GetBucketByCode(Guid code)
        {
            var query = _BucketRepository.Table.Where(c => c.CustomerId == 189458 && c.BucketCode== code && c.BucketDeleted!=true).FirstOrDefault();
            return query;
         
        }
        public virtual Bucket GetBucketById(int id)
        {
            var query = _BucketRepository.Table.Where(c => c.CustomerId == 189458 && c.Id == id && c.BucketDeleted != true).FirstOrDefault();
            return query;

        }
    }
    }

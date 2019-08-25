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
    public partial class BucketTypeService : IBucketTypeService
    {
        private readonly IRepository<BucketType> _BucketRepository;
        private readonly IDbContext _dbContext;
        private readonly IDataProvider _dataProvider;
        private readonly IWorkContext _workContext;
        private readonly IStoreContext _storeContext;
        private readonly IEventPublisher _eventPublisher;
        private readonly ICacheManager _cacheManager;
        private readonly IStoreMappingService _storeMappingService;
        private readonly IAclService _aclService;
        public BucketTypeService(ICacheManager cacheManager,
          IRepository<BucketType> BucketRepository,
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

        public IList<BucketType> GetAllBucketTypes()
        {
            var query = _BucketRepository.Table.ToList();
            return query;
        }
    }
}

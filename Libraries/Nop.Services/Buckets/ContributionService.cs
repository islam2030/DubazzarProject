using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Nop.Core;
using Nop.Core.Caching;
using Nop.Core.Data;
using Nop.Core.Domain.Buckets;
using Nop.Data;
using Nop.Services.Events;
using Nop.Services.Security;
using Nop.Services.Stores;

namespace Nop.Services.Buckets
{
    public partial class ContributionService : IContributionService
    {
        private readonly IRepository<Contribution> _ContributionRepository;
        private readonly IDbContext _dbContext;
        private readonly IDataProvider _dataProvider;
        private readonly IWorkContext _workContext;
        private readonly IStoreContext _storeContext;
        private readonly IEventPublisher _eventPublisher;
        private readonly ICacheManager _cacheManager;
        private readonly IStoreMappingService _storeMappingService;
        private readonly IAclService _aclService;
        public ContributionService(ICacheManager cacheManager,
          IRepository<Contribution> ContributionRepository,
          IDbContext dbContext,
          IDataProvider dataProvider,
          IWorkContext workContext,
          IStoreContext storeContext,
          IEventPublisher eventPublisher,
          IStoreMappingService storeMappingService,
          IAclService aclService)
        {
            this._cacheManager = cacheManager;
            this._ContributionRepository = ContributionRepository;
            this._dbContext = dbContext;
            this._dataProvider = dataProvider;
            this._workContext = workContext;
            this._storeContext = storeContext;
            this._eventPublisher = eventPublisher;
            this._storeMappingService = storeMappingService;
            this._aclService = aclService;
        }
        public IList<Contribution> GetAllContributions()
        {
            throw new NotImplementedException();
        }

        public Contribution GetItemById(int contributionId)
        {
            throw new NotImplementedException();
        }

        public IList<Contribution> GetItemsByBucketId(int bucketId)
        {
            throw new NotImplementedException();
        }

        public Contribution InsertContribution(Contribution Contribution)
        {

            if (Contribution == null)
                throw new ArgumentNullException(nameof(Bucket));
            
            _ContributionRepository.Insert(Contribution);
            return Contribution;
        }

        public Contribution UpdateContribution(Contribution Contribution)
        {
            throw new NotImplementedException();
        }
    }
}

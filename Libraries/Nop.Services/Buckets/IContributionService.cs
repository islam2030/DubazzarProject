using Nop.Core.Domain.Buckets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Services.Buckets
{
  public partial interface IContributionService
    {
        IList<Contribution> GetAllContributions();
        Contribution InsertContribution(Contribution Contribution);
        Contribution UpdateContribution(Contribution Contribution);
        IList<Contribution> GetItemsByBucketId(int bucketId);
        Contribution GetItemById(int contributionId);
    }
}

using Nop.Services.Localization;
using Nop.Web.Framework.Validators;
using Nop.Web.Models.Buckets;
using FluentValidation;
using System;

namespace Nop.Web.Validators.Bucket
{
    public class BucketValidator : BaseNopValidator<BucketModel>
    {
        public BucketValidator(ILocalizationService localizationService)
        {
          
                //login by email
                RuleFor(x => x.BucketTitle).NotEmpty().NotNull();
            RuleFor(x => x.DueDate.Date).GreaterThan(DateTime.Now.Date);
            
        }
    }
}

using Microsoft.AspNetCore.Mvc;
using Nop.Web.Framework.Components;

namespace Nop.Plugin.Payments.Fawry.Components
{
    [ViewComponent(Name = "PaymentFawry")]
    public class PaymentFawryViewComponent : NopViewComponent
    {
        public IViewComponentResult Invoke()
        {
            return View("~/Plugins/Payments.Fawry/Views/PaymentInfo.cshtml");
        }
    }
}

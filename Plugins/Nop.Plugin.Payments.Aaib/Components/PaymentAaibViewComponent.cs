using Microsoft.AspNetCore.Mvc;
using Nop.Web.Framework.Components;

namespace Nop.Plugin.Payments.Aaib.Components
{
    [ViewComponent(Name = "PaymentAaib")]
    public class PaymentAaibViewComponent : NopViewComponent
    {
        public IViewComponentResult Invoke()
        {
            return View("~/Plugins/Payments.Aaib/Views/PaymentInfo.cshtml");
        }
    }
}

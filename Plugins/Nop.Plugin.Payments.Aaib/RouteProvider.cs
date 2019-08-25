using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;
using Nop.Web.Framework.Mvc.Routing;

namespace Nop.Plugin.Payments.Aaib
{
    public partial class RouteProvider : IRouteProvider
    {
        /// <summary>
        /// Register routes
        /// </summary>
        /// <param name="routeBuilder">Route builder</param>
        public void RegisterRoutes(IRouteBuilder routeBuilder)
        {
            //PDT
            routeBuilder.MapRoute("Plugin.Payments.Aaib.PDTHandler", "Plugins/PaymentAaib/PDTHandler",
                 new { controller = "PaymentAaib", action = "PDTHandler" });

            //IPN
            routeBuilder.MapRoute("Plugin.Payments.Aaib.IPNHandler", "Plugins/PaymentAaib/IPNHandler",
                 new { controller = "PaymentAaib", action = "IPNHandler" });

            //Cancel
            routeBuilder.MapRoute("Plugin.Payments.Aaib.CancelOrder", "Plugins/PaymentAaib/CancelOrder",
                 new { controller = "PaymentAaib", action = "CancelOrder" });
        }

        /// <summary>
        /// Gets a priority of route provider
        /// </summary>
        public int Priority
        {
            get { return -1; }
        }
    }
}

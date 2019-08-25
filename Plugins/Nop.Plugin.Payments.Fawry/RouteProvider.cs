using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;
using Nop.Web.Framework.Mvc.Routing;

namespace Nop.Plugin.Payments.Fawry
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
            routeBuilder.MapRoute("Plugin.Payments.Fawry.PDTHandler", "Plugins/PaymentFawry/PDTHandler",
                 new { controller = "PaymentFawry", action = "PDTHandler" });

            //IPN
            routeBuilder.MapRoute("Plugin.Payments.Fawry.IPNHandler", "Plugins/PaymentFawry/IPNHandler",
                 new { controller = "PaymentFawry", action = "IPNHandler" });

            //Cancel
            routeBuilder.MapRoute("Plugin.Payments.Fawry.CancelOrder", "Plugins/PaymentFawry/CancelOrder",
                 new { controller = "PaymentFawry", action = "CancelOrder" });
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

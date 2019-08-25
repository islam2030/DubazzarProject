namespace Nop.Core.Domain.Shipping
{
    /// <summary>
    /// Represents the shipping status enumeration
    /// </summary>
    public enum ShippingStatus
    {
        /// <summary>
        /// Shipping not required
        /// </summary>
        ShippingNotRequired = 10,
        /// <summary>
        /// Not yet shipped
        /// </summary>
        NotYetShipped = 20,
        /// <summary>
        /// Partially shipped
        /// </summary>
        PartiallyShipped = 25,

        /// ready to shipped 
        /// ereen 11-6-2018
        /// </summary>
        ReadyToShipped = 50,
        /// <summary>
        /// Shipped
        /// </summary>
        Shipped = 30,
        /// <summary>
        /// Delivered
        /// </summary>
        Delivered = 40,
    }
}

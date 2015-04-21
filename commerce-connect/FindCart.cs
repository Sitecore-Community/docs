// --------------------------------------------------------------------------------------------------------------------
// <copyright file="FindCartInEaState.cs" company="Sitecore Corporation">
//   Copyright (c) Sitecore Corporation 1999-2014
// </copyright>
// <summary>
//   Processor performs search for cart in EA state.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

// DOCDONE

namespace Sitecore.Commerce.Connectors.NopCommerce.Pipelines.Carts.GetCarts
{
    using System.Linq;
    using Sitecore.Diagnostics;
    using Sitecore.Commerce.Data.Carts;
    using Sitecore.Commerce.Services.Carts;
    using Sitecore.Commerce.Pipelines;
    using Sitecore.Analytics;

    /// <summary>
    /// Searches for a visitor cart in its current Engagement Automation (EA) state with the following input parameters:
    /// <list type="bullet">
    /// <item>
    /// <description>
    /// UserID
    /// </description>
    /// </item>
    /// <item>
    /// <description>
    /// CustomerID
    /// </description>
    /// </item>
    /// <item>
    /// <description>
    /// CartName
    /// </description>
    /// </item>
    /// <item>
    /// <description>
    /// ShopName
    /// </description>
    /// </item>
    /// </list>
    /// If a matching cart is found, the custom pipeline argument args.Request.Properties[“CartID”] is assigned to the the ID of the matching cart. 
    /// In the  CreateOrResumeCart pipeline, the RunLoadCart processor uses the cart ID stored in the custom data.
    /// You can use the FindCartInEaState processor to search and retrieve the ID of an existing cart before executing the RunLoadCart processor.
    /// </summary>
    public class FindCart : PipelineProcessor<ServicePipelineArgs>
    {
        /// <summary>
        /// Allows Create, Read, Update, and Delete operations to be performed on the shopping carts that are stored in the Engagement Automation states.
        /// </summary>
        private readonly ICartRepository repository;

        /// <summary>
        /// Initializes a new instance of the <see cref="FindCartInEaState"/> class.
        /// </summary>
        /// <param name="repository">The repository.</param>
        public FindCart([NotNull] ICartRepository repository)
        {
            Assert.ArgumentNotNull(repository, "repository");

            this.repository = repository;
        }

        /// <summary>
        /// Executes the business logic of the FindCartInEaState processor.
        /// </summary>
        /// <param name="args">The args.</param>
        public override void Process([NotNull] ServicePipelineArgs args)
        {
            Assert.ArgumentNotNull(args, "args");

            var request = (CreateOrResumeCartRequest)args.Request;
            args.Request.Properties["CartId"] = Tracker.Current.Contact.ContactId.ToString();
        }
    }
}

---
layout: default
title: Sitecore Data Provider API
---
There are any types that are used when building a custom data provider.  

* [Sitecore.Data.DataProviders.DataProvider](#DataProvider)
* [Sitecore.Data.ItemDefinition](#ItemDefinition)
* [Sitecore.Data.DataProviders.CallContext](#CallContext)

## <a name="DataProvider">Sitecore.Data.DataProviders.DataProvider</a>

`DataProvider` is the class that must be inherited when building a custom data provider.

Details on the API for this type is available on the [Data Provider API page]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Data Providers/Implementing a Data Provider/API/DataProvider).

## <a name="ItemDefinition">Sitecore.Data.ItemDefinition</a>

`ItemDefinition` represents the most basic data needed to represent a Sitecore item. This type is a common parameter on many methods on `DataProvider`. 

It has the following properties:

* **ID** - The item ID.
* **Name** - The item name. 
* **TemplateID** - The ID of the template used to create the item.
* **BranchId** - The ID of the branch template used to create the item. If no branch template was used this property will return `Sitecore.Data.ID.Null`.

## <a name="CallContext">Sitecore.Data.DataProviders.CallContext</a>

`CallContext` represents the runtime environment in which the `DataProvider` is executed. This type is a common parameter on many methods on `DataProvider`.

#### Abort()

Data providers are executed in the order they are specified in the Sitecore configuration. For example, if your Sitecore database is configured to use 2 data providers, when the `GetChildIDs()` method is called, the method is called on both data providers.

There are cases where the first data provider is the only data provider that needs to run. In this case the first data provider can use the `Abort()` method to prevent the second data provider's method from being run.

The following is an example of how to use this method:

	public override IDList GetChildIDs(ItemDefinition itemDefinition, CallContext context)
	{
	    if (itemDefinition.ID == MyItemIDs.MyProviderRoot)
	    {
			var ids = new IDList();
			ids.Add(MyItemIDs.Child1);
			ids.Add(MyItemIDs.Child2);
			ids.Add(MyItemIDs.Child3);
			context.Abort();
			return ids;
	    }
	    return null;
	}

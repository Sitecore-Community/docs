---
layout: default
title: Implementing a Sitecore Data Provider
---
When you implement a data provider you are creating two things:
 
1. [Implementation](#implementation) - a .NET class that implements the data provider
2. [Configuration](#configuration) - specifies where Sitecore should use the implementation

## <a name="implementation">Implementation</a>

A data provider inherits from the abstract class `Sitecore.Data.DataProviders.DataProvider`.

* [API]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Data Providers/Implementing a Data Provider/API) - describes the API used to build a custom data provider
* [Mapping identifiers]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Data Providers/Implementing a Data Provider/Mapping Identifiers) - approaches for mapping unique identifiers from external systems to Sitecore item IDs
* [Search]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Data Providers/Implementing a Data Provider/Search) - how to ensure items from custom data providers are available to the Sitecore search API 
* [Publishing]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Data Providers/Implementing a Data Provider/Publishing) - how to ensure publishing items from custom data providers works as required
* [Templates]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Data Providers/Implementing a Data Provider/Templates) - how to work with templates

## <a name="configuration">Configuration</a>

Configuration is used to tell Sitecore which data providers a Sitecore database should use.

* [Adding a data provider to a Sitecore database](#add_data_provider)
* [Data provider order](#data_provider_order)

#### <a name="add_data_provider">Adding a data provider to a Sitecore database</a>

The following example demonstrates how to define a data provider and add the data provider to the `master` Sitecore database:

	<dataProviders>
	  <myDataProvider type="Testing.DataProviders.MyDataProvider, Testing" />
	</dataProviders>
	
	<databases>
	  <database id="master">
	    <dataProviders hint="list:AddDataProvider">
	      <dataProvider patch:before="*[1]" ref="dataProviders/myDataProvider" />
	    </dataProviders>
	  </database>
	</databases>

#### <a name="data_provider_order">Data provider order</a>

Data providers are handled in the order they appear in the configuration. For more information on configuration and how order is determined, see the section on the [Patch Files]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Patch Files).

It is important to understand that a data provider is assigned to a Sitecore database, *not* a Sitecore item. This means that when multiple data providers are assigned to a Sitecore database, all data providers will run for all items in that database.

This is useful because it allows multiple data providers to work together to populate items. 

However, this can cause problems if you are not expecting this to happen. If you want to ensure that no subsequent data providers are run after your data provider runs you must use the `Abort()` method on the `CallContext` object that is passed to your data provider. For more information on the `CallContext` type, see  the data provider [API page]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Data Providers/Implementing a Data Provider/API).
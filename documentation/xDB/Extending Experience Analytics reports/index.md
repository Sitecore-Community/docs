---
layout: default
title: Extending Experience Analytics reports
---
<p><span class="glyphicon glyphicon-tag"></span> Sitecore 8</p>
This article provide really short introduction into creating of custom reports for Experience Analytics. In Sitecore terms I would say : to create new report dimensions and appropriate reports for showing them.
This article looks like really short step-by-step guide with few screenshot and without any extended documentation and explanation. I hope that that will come a bit later.  
- - -
__So, the task to do__: lets implement new report that shows statistic of visits/value by different web browsers. This report can help marketing people to discover which browsers do visitors use, which browser bring more value etc.  
![Browser information in xDB]({{ site.baseurl }}/img/Extending reports/robomongo1.png)

### Creating new dimension

#### Step 1: create a new dimension definition item  
Create new "Dimension" item under "/sitecore/system/Marketing Control Panel/Experience Analytics/Dimensions/Visits" (Just use right click on the parent) and give it name "By Browser Version".  
Appropriate dimension item as well as segment item will be created.

Lets also rename segment item to something better. So finally it will look like this:  
![Browser information in xDB]({{ site.baseurl }}/img/Extending reports/dimensionItem1.png)

Deploy the segment item: go to item "/sitecore/system/Marketing Control Panel/Experience Analytics/Dimensions/Visits/By Browser Version/All visits By Browser Version" in Content Editor, and hit "Deploy" button in "Review" tab of ribbon.  
Right after that you'll have new record added to Segments table of reporting database. Take into account IDs in that DB record that are actually IDs of appropriate Dimension and Segment definition items:  
![Browser information in xDB]({{ site.baseurl }}/img/Extending reports/idsMapping.png)  

Update "DeployDate" field value of that record in DB to some older value (minimum 30 min. less) in order to make xDB processing data. The reason, visit will be processed by the segment if:

```
__visit.SaveDateTime > segment.DeployDate + 30 min__)
```

#### Step 2: create and register new dimension class in config  
You can create new separate standalone (class library) project in Visual Studio as well as using existing one.
Make sure 3 following Sitecore assemblies are referenced there:  
* Sitecore.Analytics.Aggregation.dll  
* Sitecore.Analytics.Model.dll  
* Sitecore.ExperienceAnalytics.dll  
Create new class called "ByBrowserVersion" and inherit that from either ```DimensionBase``` or ```VisitDimensionBase``` base class. Lets use the second one in this example.  
2 abstract methods need to be implemented. Lets do some simple implementation:

```c#
using System;
using Sitecore.Analytics.Aggregation.Data.Model;
using Sitecore.ExperienceAnalytics.Aggregation.Dimensions;

namespace Sitecore.EADemo
{
  class ByBrowserVersion : VisitDimensionBase
  {
    public ByBrowserVersion(Guid dimensionId) : base(dimensionId)
    {
    }

    protected override bool HasDimensionKey(IVisitAggregationContext context)
    {
      // check browser data whether it is available
      return !string.IsNullOrEmpty(context.Visit.Browser.BrowserMajorName) &&
             !string.IsNullOrEmpty(context.Visit.Browser.BrowserVersion);
    }

    protected override string GetKey(IVisitAggregationContext context)
    {
      // making key for the dimension
      return string.Format("{0}-{1}", context.Visit.Browser.BrowserMajorName, context.Visit.Browser.BrowserVersion);
    }
  }
}
```

In case of using "DimensionBase" the custom class would look like this:

```c#
using System;
using System.Collections.Generic;
using Sitecore.Analytics.Aggregation.Data.Model;
using Sitecore.ExperienceAnalytics.Aggregation.Data.Model;
using Sitecore.ExperienceAnalytics.Aggregation.Dimensions;

namespace Sitecore.EADemo
{
  class ByBrowserVersionV2 : DimensionBase
  {
    public ByBrowserVersionV2(Guid dimensionId) : base(dimensionId)
    {
    }

    public override IEnumerable<DimensionData> GetData(IVisitAggregationContext context)
    {
      var key = string.Format("{0}-{1}", context.Visit.Browser.BrowserMajorName, context.Visit.Browser.BrowserVersion);

      // point of changing calculations that comes from base class
      // everything can be changed
      var calculations = CalculateCommonMetrics(context);
      calculations.Bounces = 15;

      yield return new DimensionData
      {
        DimensionKey = key,
        MetricsValue = calculations
      };
    }
  }
}

```

Build project and make sure the dll is copied to bin folder of the website.

Map created class to appropriate item in Sitecore - add line similar to following to ```<dimensions>``` section of "Sitecore.ExperienceAnalytics.Aggregation.config" file:  
```xml  
<dimension id="{19ADC022-71BB-462F-8745-AC9A8396480E}" type="Sitecore.EADemo.ByBrowserVersion, Sitecore.EADemo" />
```  
The id in my case is the ID of item "/sitecore/system/Marketing Control Panel/Experience Analytics/Dimensions/Visits/By Browser Version", Namespace, class and assembly name are of the one which has been just created.

__Important:__ ID of Dimension (not a Segment) item should be used for mapping.


To check that it works, remove all data from Interaction table of Analytics DB in MongoDB and generate some Visits by visiting website from different browsers. (see some more [tips and tricks]({{ site.baseurl }}/documentation/xDB/How to refresh Reports) how to get data flushed to MongoDB quicker).  
Select data from ```dbo.ReportDataView``` view if reporting DB using following query:

```sql  
SELECT TOP 1000 [SegmentRecordId]      
      ,[Visits]
      ,[Value]      
      ,[Conversions]
      ,[TimeOnSite]
      ,[Pageviews]      
      ,[SegmentId]
      ,[Date]            
      ,[DimensionKey]
  FROM [launchsitecore8Sitecore_reporting].[dbo].[ReportDataView]
  where SegmentId = '{17430584-B79D-423A-A2FB-89C36FF16E5E}'
```

The SegmentID in this case is ID of appropriate segment item ("/sitecore/system/Marketing Control Panel/Experience Analytics/Dimensions/Visits/By Browser Version/All visits By Browser Version" in this example).  
So, you should see some data that was aggregated using this custom dimension. Something like following one:  
![Aggregated example data]({{ site.baseurl }}/img/Extending reports/aggregatedData.png)  


#### Step 3: create reporting page in EA (Experience Analitycs) using Sitecore Rocks  

#### Step 4: create a dimension key transformer for the new dimension (optional)  

```
dimension key = Chrome-39.0  
dimension key transformation = Chrome 39.0
```  

### Creating new report  

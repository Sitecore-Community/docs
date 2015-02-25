---
layout: default
title: Extending Experience Analytics reports
---
<p><span class="glyphicon glyphicon-tag"></span> Sitecore 8</p>
This article provide really short introduction into creating of custom reports for Experience Analytics. In Sitecore terms I would say : to create new report dimensions and appropriate reports for showing them.
This article looks like really short step-by-step guide with few screenshot and without any extended documentation and explanation. I hope that that will come a bit later.  
- - -
__So, the task to do__: lets implement new report that shows statistic of visits/value by different web browsers. This report can help marketing people to discover which browsers do visitors use, which browser bring more value etc.  
![Browser information in xDB]({{ site.baseurl }}/img/extending reports/robomongo1.png)

### Creating new dimension
#### Step 1: create a new dimension definition item  
Create new "Dimension" item under "/sitecore/system/Marketing Control Panel/Experience Analytics/Dimensions/Visits" (Just use right click on the parent) and give it name "By Browser Version".  
Appropriate dimension item as well as segment item will be created.

Lets also rename segment item to something better. So finally it will look like this:  
![Browser information in xDB]({{ site.baseurl }}/img/extending reports/dimensionItem1.png)  

Deploy the segment item: go to item "/sitecore/system/Marketing Control Panel/Experience Analytics/Dimensions/Visits/By Browser Version/All visits By Browser Version" in Content Editor, and hit "Deploy" button in "Review" tab of ribbon.  
Right after that you'll have new record added to Segments table of reporting database. Take into account IDs in that DB record that are actually IDs of appropriate Dimension and Segment definition items:  
![Browser information in xDB]({{ site.baseurl }}/img/extending reports/idsMapping.png)  

Update "DeployDate" field value of that record in DB to some older value (minimum 30 min. less) in order to make xDB processing data. The reason, visit will be processed by the segment if:

```
__visit.SaveDateTime > segment.DeployDate + 30 min__)
```

#### Step 2: create and register new dimension class in config  

#### Step 3: create reporting page in EA (Experience Analitycs) using Sitecore Rocks  

#### Step 4: create a dimension key transformer for the new dimension (optional)  

```
dimension key = Chrome-39.0  
dimension key transformation = Chrome 39.0
```  

### Creating new report  

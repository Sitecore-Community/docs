---
layout: default
title: Refreshing Executive Dashboard/ Experience Analytics reports
redirect_from: "/documentation/xDB/How to refresh Reports/"
---

Developers (especially those that do some custom reports) would like often to debug something more easily by following scenario: "I visit some pages on my web site and I see results in reports immediately (no matter Executive Dashboard of Sitecore 7.5 or Experience Analytics of Sitecore 8.0)".  
Well, for now it is pretty tricky to get such behavior in both 7.5 and 8.0 out of the box. Since Executive Dashboard (ED) and Experience Analytics (EA) are not "runtime" reports and they show some aggregated information after some period of time (we will not cover more details in this article).  
So, developers get always something like below:  
![Empty Dashboard]({{ site.baseurl }}/images/Refreshing reports/emptyDashboard.png)

So, below are some steps that developer should do on its dev. environment in order to get wanted behavior.

- - -  
__Note: please take into account that some of suchg steps are not good to do on production__
- - -  

<p><span class="glyphicon glyphicon-tag"></span> Sitecore 7.5</p>

#### Step 1:  
Configure ```"reporting.secondary"``` DB (see the reason of that [here](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20overview/processing%20overview)).  
Use copy of clean reporting DB for that. Add appropriate line in connection strings (see some information [here](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/configure%20a%20content%20management%20server)). We will need that reporting DB when executing step #7.  
![Connection strings]({{ site.baseurl }}/images/Refreshing reports/connectionStrings.png)

#### Step 2:  
Change parameter ```"MinimumVisitsFilter"``` in "\sitecore\shell\Applications\Reports\Dashboard\Configuration.config" file from 50 to 0.  
This parameter is responsible for specifying which interactions to show (if contact has ore or equal than 50 visits - show that in general statistic).

#### Step 3:  
Set ```"<sessionState ... timeout="">"``` to 2 (default value is 20). This makes Sitecore to flush information more often from RAM to Mongo DB.

#### Step 4:  
Set ```"Analytics.AutoDetectBots"``` setting to ```false``` (you might not require this step, but just in case to be 100% sure that your requests won't be filtered out as robots. Sitecore has really advanced robots detection logic).

#### Step 5:  
Open web site and visit some pages (better to open several times new "InPrivate" browser window and surf through that in order to generate several contacts and interactions).

#### Step 6:  
Make sure 2 Minutes (see step #2) is gone after visiting and appropriate data appeared in MongoDB database.

#### Step 7:  
Go to the page ```http://<hostname>/sitecore/admin/rebuildreportingdb.aspx``` and click rebuild.

#### Step 8:  
When the rebuilding process finished, map reporting secondary database to connection string with ```name="reporting"``` (in other words, swap reporting databases).

#### Step 9:  
In reporting secondary database change the ```dbo.TrafficOverview``` view in the SQL server.  
Perform following steps for that:  
1. Open your reporting DB  
2. Navigate to Views -> dbo.TrafficOverview. Click "Design" and add the ```"CAST(Date AS date) AS Date"``` line and save the changes:  
![Workaround cast]({{ site.baseurl }}/images/Refreshing reports/workaroundCast.png)


---

<p><span class="glyphicon glyphicon-tag"></span> Sitecore 8</p>
Do the same steps as for Sitecore 7.5 except steps #7-9 - they are not required.

__Tipp:__ in order to reset some Dashboard caches change date filter in report:


![Sitecore 8 report]({{ site.baseurl }}/images/Refreshing reports/reportSitecore8.png)  
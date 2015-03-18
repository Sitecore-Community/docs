---
layout: default
title: Generating Sample Analytics Data
category: xdb
---

In Sitecore 8, the information you see in reports is not the raw data that was collected in MongoDB. [Analytics data is processed and aggregated](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20overview/processing%20overview) into indexes and databases that are then used for reporting. This makes it a bit more difficult to generate data.

## Flow of Information in the xDB

* A contact visits your site and browses around
* On session end, contact and interaction data is flushed to the collection database (MongoDB)
* At regular intervals, that information is **aggregated** and transformed. The aggregated data ends up in two places:
  * The **analytics index**, used primarily but the Experience Profile search page and the List Manager
  * The **reporting SQL database**, used primarily by the Experience Analytics reports

## Creating Sample Data

Blog posts about generating sample data in the xDB:

* [Refreshing Analytics Reports]({{ site.baseurl }}/xDB/reports/how-to-refresh-reports)
* [Populating Experience Profile data](http://coreblimey.azurewebsites.net/sitecore-8-xdb-and-experience-profile-simplified/)
* [Generating Meaningful xDB Data with JMeter](http://mhwelander.net/2014/07/25/generating-sample-sitecore-analytics-data-with-jmeter/)
* [Rebuilding the Sitecore Analytics index](http://www.sitecore.net/fr-be/learn/blogs/technical-blogs/getting-to-know-sitecore/posts/2014/11/rebuilding-the-sitecore-analytics-index.aspx) (make sure you delete the index before you rebuild!)
* [Data Sanitizer for xDB (GitHub)](https://github.com/adamconn/data-sanitizer)
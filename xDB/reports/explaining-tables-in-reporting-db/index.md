---
layout: default
title: Explaining tables in reporting DB
category: xdb
---
<p><span class="glyphicon glyphicon-tag"></span> Sitecore 8</p>
This article provides an explanation, how some of the tables in reporting database are filled. If you are reading this article and have some additional information about other tables, please contribute (contact maw@sitecore.net or ekb@sitecore.net)

---
When you have just installed Sitecore 8, you see a long list of tables in Reporting database:

![list of tables in reporting db]({{ site.baseurl }}/images/Explaining tables in Reporting db/1 tables list.png)

## Segments-related tables
There are several tables, that have word Segments in their names:

Fact_SegmentMetrics, 
Fact_SegmentMetricsReduced, 
SegmentRecords, 
SegmentRecordsReduced, 
Segments.

### What are those Segments?

First of all, those segments are not contact segments from ListManager application. Similar names should not confuse you.
Segments above are also segments of contacts, but those that are used by Experience Analytics application.

If you look into Segments table, you'll see there a set of rows, where each row corresponds to an appropriate item under this subtree:

`/sitecore/system/Marketing Control Panel/Experience Analytics/Dimensions/Visits/

![idsMapping]({{ site.baseurl }}/images/Extending%20reports/idsMapping.png)

### ReportDataView View

There is also one important thing we need to know about in connection to the Segments - ReportDataView. When you open Experience Analytics, this is the first page you see:

![experience analytics first page]({{ site.baseurl }}/images/Explaining tables in Reporting db/2 dashboard.png)

This dashboard is actually built from ReportDataView

/should talk about javascript calls here/

/View is built from Fact_SegmentMetrics, Fact_SegmentMetricsReduced, SegmentRecords, SegmentRecordsReduced, DimensionKeys.
Most of these tables are updated by Reduced… stored procedure (called from Agent)

SegmentMetrics, DimensionKeys and SegmentRecords tables are actually updated during aggregation by Sitecore.ExperienceAnalytics.Aggregation.Pipeline.SegmentProcessor. /

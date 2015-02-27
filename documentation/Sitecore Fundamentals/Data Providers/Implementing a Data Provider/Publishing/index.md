---
layout: default
title: Implementing Publishing for Sitecore Data Providers
---
Publishing in Sitecore is a lot more simple than a lot of people assume. It is the process of copying Sitecore items in one Sitecore database available in another Sitecore database.

* [To publish or not to publish?](#to_publish_or_not)
* [What to implement when you want to publish](#publish_implement)
* [What to implement when you don't want to publish](#no_publish_implement)

## <a name="to_publish_or_not">To publish or not to publish?</a>

One question that needs to be answered is whether the items exposed by a data provider should be published? 

Remember that publishing involves copying data from one Sitecore database to another. Items retrieved from an external data source in one Sitecore database can be published to another Sitecore database where the content is stored as a "regular" Sitecore item (meaning the content is stored in the Sitecore database's relational database).

In this case the data, after it is published, is "disconnected" from the original data source. This can be desired in some cases. For example, this approach can expose content that resides behind a firewall without requiring any firewall modifications.

It can also be undesired. For example, if the data provider is exposing product prices from an ERP you probably want prices read from the ERP in real-time. You don't want to publish in that case.

## <a name="publish_implement">What to implement when you want to publish</a>

## <a name="no_publish_implement">What to implement when you don't want to publish</a>
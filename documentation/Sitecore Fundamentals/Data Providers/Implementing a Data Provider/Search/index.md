---
layout: default
title: Implementing Search for Sitecore Data Providers
---
All of Sitecore's search capabilities are available for Sitecore items handled by custom data providers. But without understanding how the Sitecore content index is kept up-to-date you run the risk of items exposed by a custom data provider not being reindexed when needed.

* [How the default indexing process works](#default_indexing_process)
* [Why the default process may be insufficient for a custom data provider](#limitations)

## <a name="default_indexing_process">How the default indexing process works</a>

The indexing process involves the use of the [strategy design pattern](http://www.dofactory.com/net/strategy-design-pattern). The interface `Sitecore.ContentSearch.Maintenance.Strategies.IIndexUpdateStrategy` represents a component that implements the logic needed to update the search index.

In the Sitecore configuration, under the section `/sitecore/contentSearch/indexConfigurations/indexUpdateStrategies` you can see a variety of index strategies. These index strategies are responsible for updating the search index when certain events occur. Some examples are:

* **IntervalAsynchronousStrategy** - reindex items in a queue at a regular interval
* **OnPublishEndAsynchronousStrategy** - reindex items that were published after the `publish:end` event is fired      
* **RebuildAfterFullPublishStrategy** - rebuild an entire index after a full site publish is completed
* **SynchronousStrategy** - reindex items as the items are changed

Basically, these strategies know when to run because they either ask Sitecore if they should run or Sitecore tells them when they should run.

## <a name="limitations">Why the default process may be insufficient for a custom data provider</a>

The main challenge with getting data from a custom data provider to be indexed is figuring out how to inform Sitecore when the data in the external system has changed. Sitecore probably knows nothing about the external system, and the external system probably knows nothing about Sitecore. 

#### When the default process WILL work

The default process will work if the external items are manually reindexed. This can happen when:

* The entire search index is rebuilt
* A branch containing items from a custom data provider is re-indexed 

#### When the default process will NOT work

The default process will not work if you want the Sitecore search index to be kept in sync with the external data source. Sitecore has no way of knowing that the external data has changed, so Sitecore has no reason to reindex anything.

A custom index update strategy class can provide a solution. The precisely implementation of this class will depend on the external system. Some examples are:

* **Push**- the external system notifies Sitecore that content has changed. This might be an event that is fired on the external system. An event handler on the external system makes a web service call to Sitecore. This web service call acts as the notification that Sitecore needs in order to know that a change has been made on the external system. 
* **Monitor** - a Sitecore scheduled task periodically checks the external system for any changes. 


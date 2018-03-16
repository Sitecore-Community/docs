---
layout: default
title: Introduction to the xDB
category: xdb
---

## DMS vs xDB

Sitecore's Experience Database (xDB) was introduced in Sitecore 7.5 to solve the problem of **scaling analytics**. Previously, all data was written to a single SQL database with no real option to scale (apart from maintaining a secondary reporting database). In the xDB, raw analytics data is written to a MongoDB collection database and processed into formats that are used for analytics reporting. Every component of the xDB can be scaled.

## Vocabulary: DMS, xDB, WTF?

For developers, Digital Marketing Suite (DMS) was an easy way to talk about 'all the marketing stuff that Sitecore does' - including the collection of data. That has now been replaced by **Experience Marketing capabilities**. The xDB is the **collection and processing** part of that set of features. Where you would previously have said *'we're doing more complicated DMS stuff in phase 2'*, you would now say *'we're doing more complicated Experience Marketing stuff in phase 2'*.

## The Role of MongoDB

In Sitecore's xDB, MongoDB is used primarily for **collecting data**. Information about visitors and their interactions is written to MongoDB as flat JSON, which is then processed by an aggregation pipeline into a format that is used for reporting.

You can also choose to use MongoDB as your **session state provider** if you choose to use `OutProc` session state management. There is also a SQL version of this provider. 

## Deployment Options: Cloud vs On Premise

You can find out more about [xDB cloud vs on premise on the doc site](https://doc.sitecore.net/developers/scaling-guide/deployment-options.html). Your options are essentially this:

* Host and scale everything yourself - including MongoDB
* Take advantage of xDB in the Cloud. This is an Azure service. Sitecore takes care of **all analytics data collection and aggregation**, including the reporting databases, and provides you with a number of connection strings. You host and scale the content management aspects of the platform, including:
  * Content management
  * Content delivery
  * Content management databases (core, master, web)
  * Session state management - if you are using OutProc session state management, you will want your session state databases to be as close to your CD environments as possible
  
Find out more about the software and hardware requirements for Sitecore xDB on the doc.sitecore.net:

* [Hardware and software requirements](https://doc.sitecore.net/developers/scaling-guide/hardware-and-software.html)

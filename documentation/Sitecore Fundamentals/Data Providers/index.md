---
layout: default
title: Sitecore Data Providers
---
A Sitecore data provider exposes data as Sitecore items. The default data provider exposes data stored in Sitecore's content repositories (SQL Server or Oracle databases). Custom data providers can be written that expose data stored in third-party systems. 

* [Data provider basics](#data_provider_basics)
* [Implementing a data provider]({{ site.baseurl }}/documentation/Sitecore%20Fundamentals/Data%20Providers/Implementing%20a%20Data%20Provider)
* [Links for more information](#links)

## <a name="data_provider_basics">Data provider basics</a>

Before you start integrating external data with Sitecore you really need to understand how content is modeled in Sitecore. There are several concepts you need to understand:

1. [Fields](#Fields)
2. [Items](#Items)
4. [Relationships](#Relationships)
3. [Databases](#Databases)
5. [Publishing](#Publishing)

#### <a name="Fields">Fields</a>

In Sitecore content is exposed via `Fields`. Each field stores a value. The value can be anything: a block of formatted text, a block of simple text, a number, a reference to an image, and much more. Anything that can be represented as a value can be stored in a field.

#### <a name="Items">Items</a>

Related fields are grouped together in constructs called `Items`. An item is a collection of `Fields`. But there is more to an item. Each item has...

* **ID** - a GUID (global unique identifier) that uniquely identifies an item. An ID is often expressed as a hexadecimal number, such as `{BD36FFD2-211B-4B93-886C-F87DA01DCE2C}`.
* **Name** - a name that identifies an item. Names are not unique, but they are useful because they are easier to understand the the item ID.
* **Parent** - an item has 1 parent item.
* **Children** - an item may have 0-to-many child items.
* **Versions** - a version is a construct that is used to save the field values that were set at a specific point in time. An item may have 1-to-many versions.  

#### <a name="Relationships">Relationships</a> 

Relationships between items can be described in a couple of ways:

1. **Hierarchy** - An item has 1 parent item and it may have 0-to-many child items..  
2. **Fields** - An item can be linked to other items using fields. For example, a field may represent "related products". The field value would identify the different items that are related. 

Relationships between items can be followed using the following means. In order for a custom data provider to work correctly it is important to consider each of these:

* **Sitecore Content API** - used to access content directly from a Sitecore database
* **Sitecore Content Search API** - used to search for content 
 
#### <a name="Databases">Databases</a> 

A Sitecore database exposes items using the items' hierarchical relationships. 

The root item in a Sitecore database has the name `sitecore` and the ID `{11111111-1111-1111-1111-111111111111}`. All items in a Sitecore database are descendants of the root item.

By default the following Sitecore databases are pre-configured, but additional databases can be added:

* **core** - stores content that determines how the Sitecore application works
* **master** - stores content available during the content authoring process
* **web** - stores content available during the content delivery process 

The specific items that are exposed in a Sitecore database depend on the data providers that are assigned to the Sitecore database. Each of the default Sitecore databases has a data provider assigned that exposes items stored in a relational database. These relational databases are created and specified during Sitecore installation.

Additional data providers can be assigned to a Sitecore database. When this is done, the Sitecore database may expose items stored in multiple content repositories. The result is a single hierarchy of items.  

#### <a name="Publishing">Publishing</a>

Publishing is the process of copying items (and their content) from one Sitecore database to another.

## <a name="links">Links</a>

The following links provide more information on Sitecore data providers:

* [The Black Art of Sitecore Custom Data Providers](http://www.techphoria414.com/Blog/2011/January/Black-Art-of-Sitecore-Data-Providers) by [Nick Wesselman](https://twitter.com/techphoria414) - Probably the single most valuable resource on data providers. Don't be misled by the fact that Nick's post was written in 2011. Nick's information is still completely valid and should be read by anyone considering writing a custom Data Provider.
* [When to Implement Data Providers](http://www.sitecore.net/learn/blogs/technical-blogs/john-west-sitecore-blog/posts/2012/05/when-to-implement-data-providers-in-the-sitecore-aspnet-cms) by [John West](https://twitter.com/sitecorejohn) - A very comprehensive explanation of when you should and shouldn't consider custom data providers.
* [Sitecore Data Architecture](http://kamsar.net/index.php/2013/11/sitecore-data-architecture/) by [Kam Figy](https://twitter.com/kamsar) - An excellent overview of the different components that make up Sitecore's data architecture. There's a lot more than just data providers.
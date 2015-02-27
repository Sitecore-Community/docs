---
layout: default
title: Mapping Identifiers for Sitecore Data Providers
---
When external content is exposed via a data provider, the content is represented by a Sitecore item. Every Sitecore item has an ID. It is likely that the content in the external system also has a unique identifier. Being able to map a Sitecore item ID to the unique identifier in the external system is an important part of building a data provider.

The following are common options for handing this mapping: 

* [IDTable](#idtable) - assigning a GUID for an external identifier
* [Deterministic GUIDs](#deterministic) - generating a GUID using an external identifier

## <a name="idtable">IDTable</a>

Sitecore provides a storage area called the IDTable where external identifiers can be mapped to Sitecore item IDs.

* [API](#api) - describes the API used to interact with the IDTable
* [Caching](#caching) - describes the IDTable caching features
* [`IDTableProvider`](#IDTableProvider) - the provider responsible for storing data in and retrieving data from the IDTable.

#### <a name="api">API</a>

Sitecore has an API that is dedicated to mapping identifiers to Sitecore item IDs. The API is found in the namespace `Sitecore.Data.IDTables`. 

Using the API requires you understand a few concepts:

* **Key** - the unique identifier of a resource in an external data source. A key is stored as a string value 
* **Prefix** - a string that uniquely identifies an external data source. A single IDTable may store mappings for multiple external data sources. The combination of the prefix and the key uniquely identify an external resource in the IDTable.
* **ID** - Sitecore item ID that is mapped to a combination of Prefix and Key
* **Parent ID** - Sitecore item ID for the parent item of the Sitecore item identified by the ID
* **Custom Data** - a string that contains extra information relevant to mapping an external identifier to an ID 
* **Entry** - a "record" from the IDTable. An entry includes the key, prefix and ID. 

The following code samples demonstrate how to work with the IDTable API:

* [Add an entry](#api_add1)
* [Add an entry (specifying Parent ID)](#api_add2)
* [Add an entry (specifying Custom Data)](#api_add3)
* [Get an entry from a combination of Prefix and Key](#api_get1)
* [Get an entry from a combination of Prefix and ID](#api_get2)
* [Get the entries for a Prefix](#api_get3)
* [Remove an entry using a Prefix and Key](#api_remove1)
* [Remove an entry using a Prefix and ID](#api_remove2)
* [Update an entry](#api_update1)

###### <a name="api_add1">Add an entry</a>

```
var prefix = "source1";
var key = "product1";
var newId = Sitecore.Data.ID.Parse("{5D31DF26-9562-47E0-8095-666BD681AD08}");
var entry = IDTable.Add(prefix, key, newId);
```

###### <a name="api_add2">Add an entry (specifying the Parent ID)</a>

```
var prefix = "source1";
var key = "product1";
var newId = Sitecore.Data.ID.Parse("{5D31DF26-9562-47E0-8095-666BD681AD08}");
var parentId = Sitecore.Data.ID.Parse("{1E7B9470-06CC-4E59-B8F5-9CD221454E71}");
var entry = IDTable.Add(prefix, key, newId, parentId);
```

###### <a name="api_add3">Add an entry (specifying the Custom Data)</a>

```
var prefix = "source1";
var key = "product1";
var newId = Sitecore.Data.ID.Parse("{5D31DF26-9562-47E0-8095-666BD681AD08}");
var parentId = Sitecore.Data.ID.Parse("{1E7B9470-06CC-4E59-B8F5-9CD221454E71}");
var customData = "name=Something|place=Here";
var entry = IDTable.Add(prefix, key, newId, parentId, customData);
```

###### <a name="api_get1">Get an entry from a combination of Prefix and Key</a>

```
var prefix = "source1";
var key = "product1";
var entry = IDTable.GetID(prefix, key);
```

###### <a name="api_get2">Get an entry from a combination of Prefix and ID</a>

```
var prefix = "source1";
var id = Sitecore.Data.ID.Parse("{5D31DF26-9562-47E0-8095-666BD681AD08}");
var entry = IDTable.GetKeys(prefix, id).FirstOrDefault();
```

###### <a name="api_get3">Get the entries for a Prefix</a>

```
var prefix = "source1";
var key = "product1";
var entries = IDTable.GetKeys(prefix);
```

###### <a name="api_remove1">Remove an entry using a Prefix and Key</a>

```
var prefix = "source1";
var key = "product1";
IDTable.RemoveKey(prefix, key);
```

###### <a name="api_remove2">Remove an entry using a Prefix and ID</a>

```
var prefix = "source1";
var id = Sitecore.Data.ID.Parse("{5D31DF26-9562-47E0-8095-666BD681AD08}");
IDTable.RemoveID(prefix, id);
```

###### <a name="api_update1">Update an entry</a>
There is no API for updating an entry, so an entry must be removed and then added.

```
var prefix = "source1";
var key = "product1";
var id = Sitecore.Data.ID.Parse("{5D31DF26-9562-47E0-8095-666BD681AD08}");

IDTable.RemoveID(prefix, id);

var customData = "name=Something|place=Here";
var entry = IDTable.Add(prefix, key, id, Sitecore.Data.ID.Null, customData);
```

#### <a name="IDTableProvider">`IDTableProvider`</a>

Sitecore must store the mappings somewhere. This is handled by a provider that inherits from `Sitecore.Data.IDTables.IDTableProvider`.

The default provider uses a relational database table to store the mappings. This table is named `IDTable`. The IDTable configuration identifies which relational database is used. By default Sitecore uses the relational database that corresponds to the connection string named `master`:

```
<IDTable type="Sitecore.Data.$(database).$(database)IDTable, Sitecore.Kernel" singleInstance="true">
  <param connectionStringName="master" />
  <param desc="cacheSize">2500KB</param>
</IDTable>
 ```

The default provider implements some additional features:

* [Caching](#idprovider_caching)
* [Events](#idprovider_events)

###### <a name="idprovider_caching">Caching</a>

The default IDTable provider uses implements its own caching. The size of the cache is specified in the IDTable configuration.  

```
<IDTable type="Sitecore.Data.$(database).$(database)IDTable, Sitecore.Kernel" singleInstance="true">
  <param connectionStringName="master" />
  <param desc="cacheSize">2500KB</param>
</IDTable>
 ```

###### <a name="idprovider_events">Events</a>

The default IDTable provider triggers the following events:

* `idtable:added` - when an entry is added to the IDTable
* `idtable:removed` - when an entry is removed from the IDTable

## <a name="deterministic">Deterministic GUIDs</a>

It is possible to generate a GUID using a string. The algorithm is described in [RFC4122](http://www.ietf.org/rfc/rfc4122.txt) from the IETF. 

A C# implementation of the algorithm is [available on GitHub](https://github.com/LogosBible/Logos.Utility/blob/master/src/Logos.Utility/GuidUtility.cs).

The following demonstrates how to use this implementation. The GUID `{9D02E821-E902-5BA1-BE5E-3B3F87F2DB51}` will always returned when the external identifier `D-7734J` is supplied.

```
var externalId = "D-7734J";
var guid = GuidUtility.Create(GuidUtility.IsoOidNamespace, externalId);
```

Use the following code to check if a specific GUID corresponds to an external identifier:

```
var guidExpected = Guid.Parse("{9D02E821-E902-5BA1-BE5E-3B3F87F2DB51}");
var externalId = "D-7734J";
var guidCreated = GuidUtility.Create(GuidUtility.IsoOidNamespace, externalId);
var match = (guidExpected == guidCreated);
``` 

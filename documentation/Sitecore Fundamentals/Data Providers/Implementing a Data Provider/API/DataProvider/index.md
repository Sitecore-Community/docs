---
layout: default
title: Sitecore.Data.DataProviders.DataProvider
---
`DataProvider` is the class that must be inherited when building a custom data provider. 

The list of methods available on this class is pretty expansive. A small number of the methods must be implemented in order to get a working data provider. The functionality you need will determine the methods you must implement.

However, in most cases there are methods that you will almost certainly need to implement. Those methods are:  

1. [GetChildIDs](#GetChildIDs)
2. [GetItemDefinition](#GetItemDefinition)
3. [GetItemFields](#GetItemFields)
4. [GetItemVersions](#GetItemVersions)
5. [GetLanguages](#GetLanguages)
6. [GetParentID](#GetParentID)

But there are many other methods available as well:

* xxx

## <a name="GetChildIDs">GetChildIDs</a>
Returns a collection of `ID`s that represents the Sitecore items that are children of a specific Sitecore item.

###### Parameters

* `ItemDefinition` - the Sitecore item whose children are being retrieved
* `CallContext`

###### Returns

* If the specified Sitecore item has children: `IDList` containing the `ID`s of the children
* If the specified Sitecore item has no children: `null` or empty `IDList` object 
* If the data provider does not handle the specified Sitecore item: `null`

###### Example

```c#
public override IDList GetChildIDs(ItemDefinition itemDefinition, CallContext context)
{
    if (itemDefinition.ID == MyItemIDs.MyProviderRoot)
    {
		var ids = new IDList();
		ids.Add(MyItemIDs.Child1);
		ids.Add(MyItemIDs.Child2);
		ids.Add(MyItemIDs.Child3);
		return ids;
    }
    return null;
}
```
## <a name="GetItemDefinition">GetItemDefinition</a>

Returns an object that describes the Sitecore item that corresponds to a specific Sitecore item `ID`.

###### Parameters

* `ID` - the ID of the Sitecore item whose definition is being retrieved
* `CallContext`

###### Returns

* If the data provider handles the specified `ID`: `ItemDefinition` object
* If the data provider does not handle the specified `ID`: `null`

###### Example

```c#
public override ItemDefinition GetItemDefinition(ID itemId, CallContext context)
{
    ItemDefinition itemDef = null;
    if (itemId == MyItemIDs.MyProviderRoot)
    {
        itemDef = new ItemDefinition(itemId, "My Provider Root", TemplateIDs.Folder, ID.Null);
    }
    else if (itemId == MyItemIDs.Child1)
    {
        itemDef = new ItemDefinition(itemId, "Child1", TemplateIDs.File, ID.Null);
    }
    else if (itemId == MyItemIDs.Child2)
    {
        itemDef = new ItemDefinition(itemId, "Child2", TemplateIDs.File, ID.Null);
    }
    else if (itemId == MyItemIDs.Child3)
    {
        itemDef = new ItemDefinition(itemId, "Child3", TemplateIDs.File, ID.Null);
    }
    return itemDef;
}

```

## <a name="GetItemFields">GetItemFields</a>

Returns a collection of information that identifies the fields that populate the a specific version of a specific Sitecore item.

###### Parameters

* `ItemDefinition` - the Sitecore item whose fields are being retrieved 
* `VersionUri` - the version of the Sitecore item whose fields are being retrieved
* `CallContext`

###### Returns

* If the specified Sitecore item has fields: `FieldList` containing the `ID`s of the children
* If the specified Sitecore item has no fields: `null` or empty `IDList` object 
* If the data provider does not handle the specified Sitecore item: `null`

###### Example

The following example demonstrates a data provider that does not support versioning. The same field values are returned regardless of the `VersionUri` parameter:

```c#
public override FieldList GetItemFields(ItemDefinition itemDefinition, VersionUri versionUri, CallContext context)
{
    if (itemId == MyItemIDs.MyProviderRoot || 
	    itemId == MyItemIDs.Child1 || 
		itemId == MyItemIDs.Child2 || 
	    itemId == MyItemIDs.Child3)
    {
        var now = Sitecore.DateUtil.ToIsoDate(DateTime.Now);
	    var fields = new FieldList();
        fields.Add(FieldIDs.Created, now);
        fields.Add(FieldIDs.Updated, now);
        fields.Add(FieldIDs.Owner, this.Owner);
        fields.Add(FieldIDs.CreatedBy, "custom data provider");
        fields.Add(FieldIDs.UpdatedBy, "custom data provider");
		return fields;
    }
    return null;
}
```

## <a name="GetItemVersions">GetItemVersions</a>

Returns a collection of `VersionUri` objects that represent the versions available for a specific Sitecore item.

###### Parameters

* `ItemDefinition` - the Sitecore item whose versions are being retrieved 
* `CallContext`

###### Returns

* If the specified Sitecore item has versions: `VersionUriList` containing the `VersionUri` objects that represent the available versions
* If the specified Sitecore item has no versions: `null` or empty `VersionUriList` object 
* If the data provider does not handle the specified Sitecore item: `null`

###### Example

The following example demonstrates a data provider that does not support versioning. It always returns one version for each language defined in the Sitecore database:

```c#
public override VersionUriList GetItemVersions(ItemDefinition itemDefinition, CallContext context)
{
    if (itemId == MyItemIDs.MyProviderRoot || 
	    itemId == MyItemIDs.Child1 || 
		itemId == MyItemIDs.Child2 || 
	    itemId == MyItemIDs.Child3)
    {
	    var versions = new VersionUriList();
        foreach (var language in context.DataManager.Database.Languages)
        {
            versions.Add(language, Sitecore.Data.Version.First);
        }
		return versions;
    }
    return null;
}
```

## <a name="GetLanguages">GetLanguages</a>

Returns the languages that are supported by the data provider. 

In most cases this method should be overridden to return `null`. The default data provider will return the appropriate languages. Failing to implement the method properly will result in duplicate languages appearing:

![improperly implemented GetLanguages method]({{ site.baseurl }}/img/data-providers-GetLanguages.png)

###### Parameters

* `CallContext`

###### Returns

* If the specified Sitecore item adds support for specific languages: `LanguageCollection` containing the `Language` objects
* If the specified Sitecore item does not add support for specific language: `null` or empty `LanguageCollection` object 
* If the data provider does not handle the specified Sitecore item: `null`

###### Example

The following example demonstrates a data provider that does not add support for any additional languages:

```
public override LanguageCollection GetLanguages(CallContext context)
{
    return null;
}
```

## <a name="GetParentID">GetParentID</a>

Returns the `ID` that represents the Sitecore item that is the parent of a specific Sitecore item.

###### Parameters

* `ItemDefinition` - the Sitecore item whose parent is being retrieved
* `CallContext`

###### Returns

* If the data provider is able to determine the parent Sitecore item ID for the specified Sitecore item: `ID` for the parent Sitecore item
* If the data provider does not handle the specified Sitecore item: `Sitecore.Data.ID.Null`

###### Example

```
public override ID GetParentID(ItemDefinition itemDefinition, CallContext context)
{
    if (itemId == MyItemIDs.Child1 || 
		itemId == MyItemIDs.Child2 || 
	    itemId == MyItemIDs.Child3)
    {
		return MyItemIDs.MyProviderRoot;
    }
    return ID.Null;
}
```
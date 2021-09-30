---
layout: default
title: Sitecore Caching
category: extending
---
Sitecore uses caching to improve system performance and response time.

* [Cache Basics](#cache_basics)
* [Adding a Cache](#adding_a_cache)
* [Implementing a Custom Cache](#implementing_a_custom_cache)

## <a name="cache_basics">Cache Basics</a>
Sitecore uses various caches to store data, rendered presentation logic and other information in memory in order to improve performance and response time.
A cache is a dictionary that keeps track of when each entry is accessed. The data that is stored for each entry depends on the cache. How the cache is used also depends on the cache.

* [Sitecore Caches](#sitecore_caches)
* [Cache Monitoring](#cache_monitoring)

#### <a name="sitecore_caches">Sitecore Caches</a>
The following is a list of caches that come with Sitecore. This is not an exhaustive list. New caches can be added at any time. Modules may add caches. 

These are caches that inherit from `Sitecore.Caching.CustomCache` class. There are many more caches that are instances of `Sitecore.Caching.Cache`.

<table>
<tr><th>Name</th><th>Purpose</th></tr>
<tr><td><code>AccessResultCache</code></td><td>Minimize the number of database reads needed to retrieve access rights.</td></tr>
<tr><td><code>DataCache</code></td><td>Minimize the number of times Sitecore has to read item meta-data and parent/child relationship information from the database.<br/><br/><i>Each Sitecore database as its own data cache.</i></td></tr>
<tr><td><code>DeviceItemsCache</code></td><td>Efficiently access items that represent the devices defined in Sitecore databases.</td></tr>
<tr><td><code>HtmlCache</code></td><td>Minimize the number of times Sitecore has to process renderings.</td></tr>
<tr><td><code>ItemCache</code></td><td>Minimize the number of database reads needed to retrieve item data.<br/><br/><i>Each Sitecore database as its own item cache.</i></td></tr>
<tr><td><code>ItemPathsCache</code></td><td>Minimize the number of times Sitecore has to resolve an item ID to a path<br/><br/><i>Each Sitecore database as its own items path cache.</i></td></tr>
<tr><td><code>PathCache</code></td><td>Minimize the number of times Sitecore has to resolve a path to an item ID.</td></tr>
<tr><td><code>RegistryCache</code></td><td>Minimizes the number of times Sitecore has to access its registry.</td></tr>
<tr><td><code>RuleCache</code></td><td>Minimizes the number of database reads needed to retrieve rules.</td></tr>
<tr><td><code>StandardValuesCache</code></td><td>Minimizes the number of database reads needed to retrieve standard values<br/><br/><i>Each Sitecore database as its own standard values cache.</i></td></tr>
<tr><td><code>ViewStateCache</code></td><td>Minimizes the number of times Sitecore has to read view state from permanent storage.</td></tr>
<tr><td><code>XslCache</code></td><td>Minimizes the number of times Sitecore has to process XSL renderings.</td></tr>
<tr><td><code>FieldReaderCache</code></td><td>Minimizes the number of database reads needed to retrieve field values.</td></tr>
</table>

#### <a name="cache_monitoring">Cache Monitoring</a>
Sitecore provides a basic cache monitoring script. It allows you view a list of the caches. For each cache you can see the number of records, the size of the data being cached and other information. You also have the ability to clear all of the caches.

`http://[host]/sitecore/admin/cache.aspx`

[Sitecore Rocks](http://vsplugins.sitecore.net/) provides more powerful cache monitoring features. In addition to displaying cache sizes and providing the ability to clear all caches, it allows you to clear individual caches, as well as to remove individual records from a cache.

## <a name="adding_a_cache">Adding a Cache</a>
Caches can be created as needed in your code.

> Consider implementing a custom cache. Custom caches are strongly-typed caches. 
> They are easier to work with and to keep track of. 

* [Creating the Cache](#creating_the_cache)
* [Referencing the Cache](#referencing_the_cache)
* [Adding a Value to the Cache](#adding_a_value_to_the_cache)
* [Reading a Value from the Cache](#reading_a_value_from_the_cache)
* [Removing a Value from the Cache](#removing_a_value_from_the_cache)
* [Clearing the Cache](#clearing_the_cache)

#### <a name=creating_the_cache"">Creating the Cache</a>
Creating a cache consists of creating a new instance of `Sitecore.Caching.Cache`. When the instance is created the cache is automatically registered with the system. This means that Sitecore recognizes the cache and can control it.

	var mycache = new Sitecore.Caching.Cache("test cache", 1024);

#### <a name="referencing_the_cache">Referencing the Cache</a>
A cache is accessed by name using the Cache Manager.

	var mycache = Sitecore.Caching.CacheManager.FindCacheByName("test cache");

#### <a name="adding_a_value_to_the_cache">Adding a Value to the Cache</a>
A value is added to the cache using the `Add` method.

	var mycache = Sitecore.Caching.CacheManager.FindCacheByName("test cache");
	mycache.Add("name", "value"); 

#### <a name="reading_a_value_from_the_cache">Reading a Value from the Cache</a>
A value is read from the cache using the `GetValue` method. Reading a value notifies that the value has been read, which resets the expiration timer.

	var mycache = Sitecore.Caching.CacheManager.FindCacheByName("test cache");
	var value = mycache.GetValue("name");

#### <a name="removing_a_value_from_the_cache">Removing a Value from the Cache</a>
A value is removed from the cache using the `Remove` method.

	var mycache = Sitecore.Caching.CacheManager.FindCacheByName("test cache");
	mycache.Remove("name");

#### <a name="clearing_the_cache">Clearing the Cache</a>
A cache can be cleared using the `Clear` method.

	var mycache = Sitecore.Caching.CacheManager.FindCacheByName("test cache");
	mycache.Clear();

## <a name="implementing_a_custom_cache">Implementing a Custom Cache</a>
A custom cache is a strongly-typed cache. These types of caches are easier to work with. In in other regards a custom cache works the same way as other caches.

#### <a name="custom_cache_example">Custom Cache Example</a>
The following is an example of a custom cache and a manager class for accessing the cache.
    
	public class AbbreviationCache : CustomCache<string>
	{
	    public AbbreviationCache(string name, long maxSize) : base(name, maxSize) {  }
	
	    public void SetAbbreviation(string key, string value)
	    {
	        base.SetString(key, value);
	    }
	    public string GetAbbreviation(string key)
	    {
	        return base.GetString(key);
	    }
	}

	public class AbbreviationCacheManager
	{
	    private static AbbreviationCache _abbreviationCache;
	
	    public static AbbreviationCache GetAbbreviationCache()
	    {
	        if (_abbreviationCache == null)
	        {
	            var name = "AbbreviationCache";
	            var size = Sitecore.Configuration.Settings.Caching.SmallCacheSize;
	            _abbreviationCache = new AbbreviationCache(name, size);
	        }
	        return _abbreviationCache;
	    }
	}

The following is an example of how to use the custom cache.

	var cache = Testing.Caching.AbbreviationCacheManager.GetAbbreviationCache();
	cache.SetAbbreviation("adc", "Adam David Conn");

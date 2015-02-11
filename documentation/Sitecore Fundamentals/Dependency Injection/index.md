---
layout: default
title: Dependency Injection
---
Sitecore allows you to use dependency injection in Sitecore patch files to define objects that will be available at runtime. You can define arbitrary nodes under `/configuration/sitecore` and then use the Sitecore API to access objects that represent those nodes.

The purpose of such nodes is to allow you to configure a component you have built. At some point you will want to access the information from those nodes. You can read those nodes as XML, but it is often easier to create a class that is loaded with the information.

But it's not just a matter of convenience. Sitecore caches these objects so you get better performance.

* [Mapping Types](#mapping_types)
* [Mapping Constructors](#mapping_constructors)
* [Mapping Primitive Properties](#mapping_primitive_properties)
* [Mapping Object Properties](#mapping_object_properties)
* [Mapping String List Properties](#mapping_string_list_properties)
* [Mapping Collection Properties](#mapping_collection_properties)
* [Using the Configuration Factory](#config_factory)

## <a name="mapping_types">Mapping Types</a>
The following Sitecore patch file demonstrates the most basic kind of name-to-object mapping: a name to a type.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <guide>
	      <simplemap type="Testing.Config.MyClass1, Testing" />
	    </guide>
	  </sitecore>
	</configuration>

This configuration assumes the following class is available on the Sitecore server:

	namespace Testing.Config
	{
	    public class MyClass1 {}
	}

## <a name="mapping_constructors">Mapping Constructors</a>
You can specify constructor parameters in your Sitecore patch file.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <guide>
	      <constructormap type="Testing.Config.MyClass2, Testing">
	        <param name="name">Constructor mapping</param>
	      </constructormap>
	    </guide>
	  </sitecore>
	</configuration>

This configuration assumes the following class is available on the Sitecore server:
	namespace Testing.Config
	{
	    public class MyClass2
	    {
	        public MyClass2(string name)
	        {
	            this.Name = name;
	        }
	        public string Name { get; private set; }
	    }
	}

## <a name="mapping_primitive_properties">Mapping Primitive Properties</a>
You can set values on primitive-type properties in your Sitecore patch file.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <guide>
	      <propertymap type="Testing.Config.MyClass3, Testing">
	        <name>Property mapping</name>
	      </propertymap>
	    </guide>
	  </sitecore>
	</configuration>

This configuration assumes the following class is available on the Sitecore server:

	namespace Testing.Config
	{
	    public class MyClass3
	    {
	        public string Name { get; set; }
	    }
	}

## <a name="mapping_object_properties">Mapping Object Properties</a>
You can set values on object-type properties in your Sitecore patch file.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <guide>
	      <objectpropmap type="Testing.Config.MyClass4, Testing">
	        <config type="Testing.Config.ConfigExample, Testing">
	          <name>/sitecore/content/Home</name>
	          <description>Home item</description>
	        </config>
	      </objectpropmap>
	    </guide>
	  </sitecore>
	</configuration>

Since the `type` attribute is specified on the `config` node, Sitecore will instantiate an object using that type and will set the `config` property on the `objectpropman` object.

This configuration assumes the following class is available on the Sitecore server:

	namespace Testing.Config
	{
	    public class ConfigExample
	    {
	        public string Name { get; set; }
	        public string Description { get; set; }
	    }
	    public class MyClass4
	    {
	        public ConfigExample Config { get; set; }
	    }
	}

## <a name="mapping_string_list_properties">Mapping String List Properties</a>
You can add values to properties that store string lists in your Sitecore patch file.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <guide>
	       <stringlistmap type="Testing.Config.MyClass5, Testing">
	        <locations hint="list">
	          <location>/sitecore/content/Home</location>
	          <location>/sitecore/media library</location>
	        </locations>
	      </stringlistmap>
	    </guide>
	  </sitecore>
	</configuration>

The addition of `hint="list"` tells Sitecore to treat each child node as a string, and to pass that string to the list's `Add` method. But using the "hint" functionality means you cannot use the "type" functionality. Without the "type" functionality Sitecore doesn't know which type to use to create a new object to assign to the property, so you have to be sure the property is set to an object because Sitecore tries to add a new member to the collection.

This configuration assumes the following class is available on the Sitecore server:

	namespace Testing.Config
	{
	    public class MyClass5
	    {
	        public List<string> Locations { get; private set; }
	        public MyClass5()
	        {
	            this.Locations = new List<string>();
	        }
	    }
	}

## <a name="mapping_collection_properties">Mapping Collection Properties</a>
You can add objects to collections in your Sitecore patch file.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <guide>
	      <dictionarymap type="Testing.Config.MyClass6, Testing">
	        <names hint="raw:AddItemName">
	          <home guid="{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}">
	            <name>Home</name>
	          </home>
	          <medialibrary guid="{3D6658D8-A0BF-4E75-B3E2-D050FABCF4E1}">
	            <name>Media Library</name>
	          </medialibrary>
	        </names>
	      </dictionarymap>
	    </guide>
	  </sitecore>
	</configuration>

The addition of `hint="raw:AddItemName"` tells Sitecore to pass each child node as an `XmlNode` object to the `MyClass6` object's `AddItemName` method. 

This configuration assumes the following class is available on the Sitecore server:

	namespace Testing.Config
	{
	    public class MyClass6
	    {
	        public Dictionary<Guid, string> ItemNames { get; private set; }
	        public MyClass6()
	        {
	            this.ItemNames = new Dictionary<Guid, string>();
	        }
	
	        public void AddItemName(string key, System.Xml.XmlNode node)
	        {
	            AddItemName(node);
	        }
	        public void AddItemName(System.Xml.XmlNode node)
	        {
	            var guid = Sitecore.Xml.XmlUtil.GetAttribute("guid", node);
	            var name = Sitecore.Xml.XmlUtil.GetChildValue("name", node);
	            this.ItemNames.Add(new Guid(guid), name);
	        }
	    }
	}

#### Create helper methods for adding items to a collection
A helper method allows you to take advantage of the "hint" functionality which greatly simplifies the configuration that is required to define the members of the collection.

* If the collection member is configured using only attributes (as opposed to attributes and child nodes) your helper method must accept a `System.Xml.XmlNode` parameter instead of a `System.Xml.XmlNode` parameter.
* If the node that represents a collection member has an attribute named `key` your helper method must accept another parameter. An example of the method signature is `public void AddItemName(string key, System.Xml.XmlNode node)`.

## <a name="config_factory">Using the Configuration Factory</a>
The Sitecore API provides a factory that will instantiate the objects defined in your Sitecore patch file.

	var refObj = Sitecore.Configuration.Factory.CreateObject("guide/stringlistmap", true) as Testing.Config.MyClass5;

The `bool` parameter in the `CreateObject` method specifies whether an exception is thrown if the specified path in the Sitecore patch file cannot be located. 

* `True` means an exception will be thrown if the path does not exist. 
* `False` means no exception will be thrown and the `CreateObject` method will return `null`.


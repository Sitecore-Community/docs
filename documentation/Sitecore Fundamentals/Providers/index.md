---
layout: default
title: Sitecore Providers
---
.NET's provider model offers a convenient and consistent model for encapsulating business logic so that is can be extended or replaced. Sitecore uses providers extensively.

* [Provider Basics](#provider_basics)
* [Implementing a Custom Provider](#implementing_a_custom_provider)

## <a name="provider_basics">Provider Basics</a>

* [What is a Provider?](#what_is_a_provider)
* [How does Sitecore use Providers?](#how_does_sitecore_use_providers)

#### <a name="what_is_a_provider">What is a Provider?</a>
A provider is a component that implements logic. They are used to encapsulate functionality for a problem domain.  Much of Sitecore's functionality is implemented in providers. For example, when you publish items Sitecore uses a publishing provider. 

Dependency injection is used to identify which providers Sitecore should use. This makes it possible to replace providers without changing code. As a result, providers make it easy for developers to extend or replace Sitecore functionality. For more information on dependency injection and Sitecore see [this section]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Dependency injection).

#### <a name="how_does_sitecore_use_providers">How does Sitecore use Providers?</a>
Most functionality in Sitecore is implemented in and accessed using providers. The following is a list of some of the Sitecore functionality that is implemented by providers.

* Archiving
* Authentication
* Authorization
* Presentation
* Publishing
* CRUD operations for items
* Site resolution
* Link generation and resolution

## <a name="implementing_a_custom_provider">Implementing a Custom Provider</a>

* [Provider Class](#provider_class)
* [Provider Collection Class](#provider_collection_class)
* [Manager Class](#manager_class)
* [Provider Configuration](#provider_configuration)
* [Using a Provider](#using_a_provider)

#### <a name="provider_class">Provider Class</a>
A provider is a class that inherits from `System.Configuration.Provider.ProviderBase`. Apart from making inheriting from this class, the only other thing you need to do to implement a provider is to add the methods that allow other components to interact with your provider.

> Expect that your provider will be extended. One of the main reasons for 
> implementing a provider is to allow developers to extend or replace the 
> default provider. Mark methods as virtual where appropriate.

The following is an example of a provider.

```c#
public class HelloWorldProvider : System.Configuration.Provider.ProviderBase
{
    public virtual string SayHello()
    {
        return "Hello, world.";
    }
}
```

#### <a name="provider_collection_class">Provider Collection Class</a>
It is possible for a single Sitecore server to support multiple implementations of a certain provider. For example, Sitecore supports basic and digest authentication, so Sitecore has multiple HTTP authentication providers. The provider collection class provides access to these multiple providers.

The following is an example of a provider collection.

```c#
public class HelloWorldProviderCollection : System.Configuration.Provider.ProviderCollection
{
    public HelloWorldProvider this[string name]
    {
        get
        {
            return (base[name] as HelloWorldProvider);
        }
    }
}
```

#### <a name="manager_class">Manager Class</a>
A manager class is used to access a provider. The manager makes it easier for a developer to ask Sitecore for the appropriate provider without having to hard-code and references to a specific implementation.

A manager is used to access providers and to facilitate using providers.

The following is an example of a manager.

```c#
public static class HelloWorldManager
{
    private static Sitecore.Configuration.ProviderHelper<HelloWorldProvider, HelloWorldProviderCollection> _providerHelper;
    static HelloWorldManager()
    {
        _providerHelper = new Sitecore.Configuration.ProviderHelper<HelloWorldProvider, HelloWorldProviderCollection>("helloWorldManager");
    }
    public static HelloWorldProvider Provider
    {
        get
        {
            return _providerHelper.Provider;
        }
    }
    public static HelloWorldProviderCollection Providers
    {
        get
        {
            return _providerHelper.Providers;
        }
    }
    public static string SayHello()
    {
        return Provider.SayHello();
    }
}
```

#### <a name="provider_configuration">Provider Configuration</a>
Providers are defined in `Web.config` and Sitecore patch files under `/configuration/sitecore`.

The following is an example of a provider configuration.

```xml
<helloWorldManager defaultProvider="default" enabled="true">
  <providers>
    <clear />
    <add name="default" type="Testing.IntegrationGuide.Providers.HelloWorldProvider, Testing.IntegrationGuide" />
  </providers>
</helloWorldManager>
```

#### <a name="using_a_provider">Using a Provider</a>
The easiest way to use a provider is through the manager class. The following is an example of how to use the manager class.

```c#
var msg = Testing.IntegrationGuide.Providers.HelloWorldManager.SayHello();
```
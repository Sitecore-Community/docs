---
layout: default
title: Creating a Visual Studio Project for Sitecore MVC
redirect_from: "/documentation/Sitecore%20MVC/Creating a Visual Studio Project for Sitecore MVC/"
category: mvc
---

In order to work with Sitecore, you must set up a Visual Studio project. The following article explains how to do so for a Sitecore MVC project.

<div class="embed-responsive embed-responsive-16by9">
  <iframe class="embed-responsive-item" src="//www.youtube.com/embed/cskz2oZYCYs" frameborder="0" allowfullscreen></iframe>
</div>

## Before You Start

### Which Version of MVC?

Different versions of Sitecore support different versions of ASP.NET MVC. For a complete list, [refer to the Knowledgebase article](https://kb.sitecore.net/articles/522918). Your version affects the type of project you create.

### Work Outside the Web Root

Sitecore recommends that you create your Visual Studio project in a location outside the web root, and set up a process that copies files into the web root of the Sitecore instance (on build, for example). There are several methods of doing this:

* Use something like [Team Development for Sitecore (TDS)](https://www.teamdevelopmentforsitecore.com/)
* Create a post-build script
* Use [Web One Click Publish](http://msdn.microsoft.com/en-us/library/vstudio/dd434211.aspx) in Visual Studio

## Step 1 - Create a Visual Studio Project

1. Open Visual Studio, and create a new project with the [correct version of ASP.NET MVC for your version of Sitecore](https://kb.sitecore.net/articles/522918). Choosing the wrong version (ASP.NET MVC 5.0 vs 5.1) will result in application errors when the .dlls are copied into the bin directory.
2. Replace the **default web.config** with the web.config from your Sitecore instance. Because the web.config file references **App_Config\ConnectionStrings.config**, you may get complaints that it can't find a referenced file. If this is the case, copy App_Config\ConnectionStrings.config into your solution.
3. Delete the **default Global.asax** and replace it with the Global.asax from your Sitecore instance.
5. Configure your method of copying files from the project to the web root (whether that's Visual Studio's Web One Click Publish, TDS, or something else).
6. Build your solution and browse to your site.

## Step 2 - Add References

Add a reference to **Sitecore.Kernel.dll** and **Sitecore.MVC.dll** at the very least. It is recommended that you do not add your references directly from the web root /bin directory, as the version and location may vary across machines. Here are some options:

* Create a **lib** folder in your project root, and make copies of the Sitecore .dlls that you require.
* Create a central library for Sitecore .dlls within your organization.
* Set up a **local NuGet server** within your organization to store different versions of the Sitecore .dlls.

## Step 3 - Connect Your Project to Sitecore Rocks

This is not a Sitecore MVC-specific step.

1. Make sure [Sitecore Rocks](https://marketplace.sitecore.net/en/Modules/Sitecore_Rocks.aspx) is installed.
2. Right-click on your main project, and select **Sitecore > Connect to Sitecore...**. 
3. Choose the Sitecore instance from the list.

Connecting your project to Sitecore Rocks means that when you create certain files from the **Sitecore** menu, you will be prompted to add a corresponding Sitecore item. For example, a view rendering consists of a .cshtml file on the file system and an item under ``sitecore/Layout/Renderings``.

## FAQs and Troubleshooting

### My project has the wrong ASP.NET MVC dlls - how can I correct this?

If you are using a version of Sitecore that requires ASP.NET MVC 5.1 but you have accidentally created a 5.0 project (of you're in Visual Studio 2012 without the update that lets you create a 5.1 project), you can get the .dlls from NuGet.

```
Uninstall-Package Microsoft.AspNet.Mvc
```

Then install the version you need:

```
Install-Package Microsoft.AspNet.Mvc -Version 5.1.0
```

All references (``System.Web.Razor``, and so on) will automatically update.

### What's different about Sitecores Global.asax file?

The following is a default Sitecore Global.asax:

```
<%@Application Language='C#' Inherits="Sitecore.Web.Application" %>
```

Notice that it inherits ``Sitecore.Web.Application`` (which in turn inherits the standard (``System.Web.HttpApplication``). To extend Global.asax (which you are very likely to do if you use any kind of IoC container), you can simply add in the ``Application_*`` methods:
  
    <%@Application Language='C#' Inherits="Sitecore.Web.Application" %>
    <script runat="server">
      public void Application_Start() {
      }
    
      public void Application_End() {
      }
    
      public void Application_Error(object sender, EventArgs args) {
      }
    </script>

Or, if you want to use a ``Global.asax.cs`` to work in, just remember to inherit ``Sitecore.Web.Application``.

### How do I install WebGrease if I am using Sitecore 7.2 and ASP.NET MVC 5.1?

See Kern's [gist](https://gist.github.com/herskinduk/7a67839b4af39fc7ebcc) for web.config changes. At time of writing (17/10/2014), the MVC assemblies are targeting a lower version of the WebGrease assembly than the one used in the MVC project template.

---
layout: default
title: View Renderings
redirect_from: "/documentation/Sitecore MVC/View Renderings/"
category: mvc
---

A view rendering is the simplest Sitecore MVC rendering type. As with all presentation items in Sitecore, a view rendering consists of a definition item in Sitecore and a file on the file system. In the case of view renderings, the file is a standard Razor view (``.cshtml``) which expects a model of type ``RenderingModel`` by default (but can be configured to use a custom class). The model is assembled by the Sitecore MVC pipeline - you do not create a controller and ``ActionResult`` as you would with standard ASP.NET MVC. For this reason, [controller renderings may be a better choice for complex business logic](http://mhwelander.net/2014/06/13/view-renderings-vs-controller-renderings/). 

## Using a datasource with a view rendering

The default ``RenderingModel`` has a property named ``.Item`` - this will return the datasource item if present, or the context item if no datasource has been set. ``.PageItem`` will always return the context item. Either item can be used by the [field helper]({{ site.baseurl }}/documentation/Sitecore MVC/Rendering Content/index.html).

## Creating a view rendering with Sitecore Rocks

1. Connect your website project to an instance of Sitecore by right-clicking on the project and choosing the **Sitecore** menu. This will allow Sitecore Rocks to create a corresponding rendering item in the master database. 

	![Sitecore menu]({{ site.baseurl }}/images/connect-project-to-rocks.png)

2. Choose your instance from the **Sitecore Explorer Connection** dropdown list: 

	![Choose an instance of Sitecore from the dropdown]({{ site.baseurl }}/images/project-rocks-properties.PNG)

3. To create a view rendering, right-click on the folder in your project where you wish to insert the ``.cshtml`` file and select **Add > New Item...**.
4. Choose **Sitecore** in the left-hand menu, and select **Sitecore View Rendering** in the right-hand pane. Give the view rendering a name. Keep in mind that this will also be the name of the compenent definition item in Sitecore, so it should be human-readable.

	![Select and name view rendering]({{ site.baseurl }}/images/create-view-rendering.PNG)

5. Sitecore will prompt you to add a corresponding definition item. View renderings live under ``/sitecore/Layout/Renderings``, and should ideally be organized into a sub-folder.

	![Create a Sitecore item]({{ site.baseurl }}/images/create-corresponding-item.PNG)	

	Choose a location and click OK (or right-click to insert a new sub-folder). Sitecore will create a definition item in the tree, and you will get a ``.cshtml`` file that is setup in the following way:
		
		@using Sitecore.Mvc
		@using Sitecore.Mvc.Presentation
		@model RenderingModel

6. If you are working outside the web root, remember to move your files across (by using One-Click Web Publish in Visual Studio, TDS, or a custom post-build step).

---
layout: default
title: Rendering Content
---

# Rendering Content

In standard ASP.NET MVC, a view accepts a model (or view model). This model contains everything that the view requires - including content. For instance, you may have a ``NewsArticle`` model with a ``Text`` and ``Title`` property. You would output this content like this:

{% highlight html %}
<h1>@Model.Title</h1>
@Model.Text
{% endhighlight %}

In Sitecore, you have two options. You can either populate the model with content before it ends up in the view (very similar to standard ASP.NET MVC), or you can use the **field helper**.

## Using @Html.Sitecore().Field()

By default, view renderings us Sitecore's generic ``RenderingModel``. 

## Populating Model 
==============
Rendering Content
==============

In standard ASP.NET MVC, a view accepts a view model. Recommended practice says that the view model contains everything that the view requires, and that the view should contain no further business logic. The view should only contain display logic. In standard ASP.NET MVC, something like EntityFramework or nHibernate may be used to return data as objects in the application's repository layer - for example, you may have a ``NewsArticle`` model with a ``Text`` and ``Title`` property. The view receives the completed model and outputs it as HTML:

{% highlight html %}
<h1>@Model.Title</h1>
@Model.Text
{% endhighlight %}

In Sitecore, you have two options. Whether you are using a view rendering or a controller rendering, you *can* pass a custom model to the view as you would in standard ASP.NET MVC and simply call on its properties. The other option is to use Sitecore's **field helper** together with a more generic model.

## The @Html.Sitecore().Field() Helper

Sitecore's field helper is Sitecore MVC's answer to the ``<sc:FieldRenderer />``. In Web Forms, there are a number of more specialized versions, such as ``<sc:Text />`` and ``<sc:Link />``. Ultimately, the Web Forms controls and MVC helper call on exactly the same method: ``FieldRenderer.Render()``.

The helper accept as a field name, item, and set of parameters. At the very least, you must supply a field name. If no item has been specified, Sitecore will look for that field on the **context item** and output its content. Consider the following view - it is used by a **view rendering**, and uses Sitecore's default ``RenderingModel``.

{% highlight html %}
@model RenderingModel

@Html.Sitecore().Field("Pet Name")
{% endhighlight %}

The only content in this view is the ``Pet Name`` field. Because we did not specify an item, the helper will use the context page item by default (if you browse to http://mysite/dogs/spot, then the context item is 'spot'). To make it absolutely clear where the content is coming from, you could pass the context item in explicitly:

{% highlight html %}
@model RenderingModel

@Html.Sitecore().Field("Pet Name", Model.PageItem)
{% endhighlight %}

Alternatively, you can pass in the **datasource item** - if no datasource item is found, it will fall back to the context item:

{% highlight html %}
@model RenderingModel

@Html.Sitecore().Field("Pet Name", Model.Item)
{% endhighlight %}

You do not have to use Sitecore's ``RenderingModel`` - any model that gives you access to a Sitecore ``Item`` will work, but all view renderings use this model by default, and if you are only outputting simple data, it is quite likely that you will be using a view rendering.

## Field Rendering Parameters

Like the standard HTML helper, Sitecore's field helper accepts parameters. If Sitecore recognizes something as a **field rendering parameter** (like max width and max height for images), it will process them accordingly. All other parameters are added as attributes (such as CSS class in the example below):

{% highlight html %}
@Html.Sitecore().Field("Pet Image", Model.PageItem, new { @class="large-image", @mw="250" })
{% endhighlight %}

<mark>
	<strong>Note</strong>: Sitecore does have some problems processing data_* attributes - see <a href="http://brad-christie.com/blog/2014/09/24/using-data-attributes-with-sitecore-mvc/">Brad Christie's blog post for a solution</a>.
</mark>

## Custom Field Helpers

You can create your own library of field helpers that support a specific field type - for instance, you might create an image, date, or link field helper. Refer to [John West's blog post on custom field helpers](https://www.sitecore.net/Learn/Blogs/Technical-Blogs/John-West-Sitecore-Blog/Posts/2012/06/Sitecore-MVC-Playground-Part-4-Extending-the-SitecoreHelper-Class.aspx) for more information.

This doesn't feel very MVC...
~~~~~~~~~~~~~~~~~~~~~~

For developers that are accustomed to seeing ``@Model.PropertyName``, using a generic model with a field helper may look a bit wrong. It does, however, have certain advantages:

* It's very simple - if you are just rendering content from a single item, you may not want to go to the effort of populating a custom model or view model with data
* It supports the Experience Editor straight away without any additional work 
* You can pass different field parameters to the helper that are specific to the view - for instance, a news article may require different date formatting depending on where it is being displayed

If a rendering's only job is to output Sitecore content (no business logic, no data from elsewhere in the tree), it may not be worth complicating the process by returning a custom model. 
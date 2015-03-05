---
layout: onecol
title: How to help
---

## Sitecore Community Docs are hosted on GitHub

In order to contribute, all you need is a GitHub account! Fork the [docs repository](http://github.com/sitecore-community/docs), add or edit a page, and make a pull request. We will merge in your changes or ask for changes.

### How to add an article

* Create some folders. **Folder structure** determines URLs (simple!) - if you want to create an article under /xdb/facets, create a folder named **xdb**, a folder named **facets** inside that, and an **index.md** file inside that
* Include the following code at the top of your page:

	<pre>
	---
	layout: default
	title: How to help	
	---</pre>

  The title variable will be the title of your page.

 * Write your article using Markdown - please put all images inside the **images** folder in the top level directory - feel free to use sub-folders.
 * Make a pull request to merge in your changes; we will review the content and publish it. That's it!

### What about navigation?

 Navigation is only semi-automated - each section's navigation tree is stored in an individual .html file inside `_includes` folder in the top level directory. 

 * To add a page to an existing tree, just edit the relevant HTML file.
 * To add a navigation tree to a particular page, add a category to your page frontmatter:

	<pre>
	---
	layout: default
	title: How to help	
	catgory: mvc
	---</pre>

   Have a look in `_layouts\default.html` to see which category displays which navigation tree.
   * To add a brand new section with its own navigation tree, copy one of the files in `_includes`, construct your tree, and edit the logic in `_layouts\default.html` to display the tree when the context page has a certain category set. Make sure it hasn't already been used!


### A note about links and images

When you are inserting links or images, use `{{ site.baseurl }}` instead of `sitecore-community.github.io/docs` - this ensures that the links will still work of the base URL changes.
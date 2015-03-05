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
---
layout: default
title: Sitecore Pipelines
category: pipelinesandevents
redirect_from: "/documentation/Sitecore Fundamentals/Pipelines/"
---

* [What is a Pipeline?](#what_is_a_pipeline)
* [Common Pipelines](#common_pipelines)
* [Sitecore 8 Pipelines](#sc8_pipelines)


Pipelines are one of Sitecore's essential integration concepts. They are used to extend existing functionality, and to allow custom functionality to be extended in the future. They also provide a level of documentation and transparency by virtue of how they are configured.

## <a name="what_is_a_pipeline">What is a Pipeline?</a>
A pipeline is basically a method whose flow is defined using XML. 

A pipeline consists of a sequence of [processors]({{ site.baseurl }}/pipelines-and-events/pipelines/pipeline-processors). A processor is a .NET class that implements a method. When a pipeline is invoked, the processors are run in order.

Pipelines are used to control most of Sitecore's functionality. Processes ranging from authentication to request handling to publishing to indexing are all controlled through pipelines.

Pipelines are defined in `Web.config` and in Sitecore patch files.

The following is an example of the pipeline that is responsible for rendering a page:

	<renderLayout>
	  <processor type="Sitecore.Pipelines.PreprocessRequest.CheckIgnoreFlag, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.PageHandlers, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.SecurityCheck, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.InsertRenderings, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.PageExtenders, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.ExpandMasterPages, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.BuildTree, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.InsertSystemControls, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.InsertUnusedControls, Sitecore.Kernel" />
	  <processor type="Sitecore.Pipelines.RenderLayout.BrowserCaching, Sitecore.Kernel" />
	</renderLayout>

## <a name="common_pipelines">Sitecore's Pipelines</a>

Sitecore includes more than 140 pipelines. Each new version of Sitecore adds pipelines. Installing Sitecore modules also results in more pipelines being added.

The following is a list of some of the more commonly used pipelines. It is unlikely you will ever call any of these pipelines directly, but it is not unusual to extend these pipelines.

<table>
<tr><th>Pipeline name</th><th>Defined in</th><th>Args type</th><th>Description</th></tr>
<tr><td><code>initialize</code></td><td><code>Web.config</code></td><td><code>PipelineArgs</code></td><td>Runs when the IIS application pool is started. Processors handle initialization tasks that need to run once.</td></tr>
<tr><td><code>httpRequestBegin</code></td><td><code>Web.config</code></td><td><code>HttpRequestArgs</code></td><td>Handles the HTTP request. This includes tasks such as resolving the context item, device and presentation settings.</td></tr>
<tr><td><code>insertRenderings</code></td><td><code>Web.config</code></td><td><code>InsertRenderingsArgs</code></td><td>Determines the presentation components to include when rendering an item.</td></tr>
<tr><td><code>renderField</code></td><td><code>Web.config</code></td><td><code>RenderFieldArgs</code></td><td>Runs when the FieldRenderer is used to render a field value.</td></tr>
</table>

## <a name="sc8_pipelines">Sitecore 8 Pipelines</a>

Sitecore 8 introduced a large number of additional pipelines. See links below for more information about these pipelines:

* [A Sitecore 8 Request from Beginning to End](http://sitecoreskills.blogspot.co.uk/2015/02/a-sitecore-8-request-from-beginning-to.html)
* [Sitecore 8's 'StartTracking' pipeline](http://sitecoreskills.blogspot.co.uk/2015/03/sitecore-pipelines-starttracking.html)
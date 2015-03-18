---
layout: default
title: Extending or Creating Pipelines
category: pipelinesandevents
---

Pipelines are extended by adding or replacing processors. Extending a pipeline involves modifying the pipeline definition located in a Sitecore patch file.

The following is an example of how the Sitecore patch file `Sitecore.Analytics.config` extends the pipeline `httpRequestBegin`:

	<httpRequestBegin>
	  <processor type="Sitecore.Analytics.Pipelines.HttpRequest.StartDiagnostics,Sitecore.Analytics" patch:after="processor[@type='Sitecore.Pipelines.HttpRequest.StartMeasurements, Sitecore.Kernel']" />
	  <processor type="Sitecore.Analytics.Pipelines.HttpRequest.PageLevelTestItemResolver,Sitecore.Analytics" patch:after="processor[@type='Sitecore.Pipelines.HttpRequest.ItemResolver, Sitecore.Kernel']" />
	</httpRequestBegin>

## <a name="configuring_a_processor">Creating and Configuring a Processor</a>

To extend a pipeline, you must either replace an existing processor or [add a custom processor]({{ site.baseurl }}/pipelines-and-events/pipelines/pipeline-processors#custom_processors). If you are replacing an existing pipeline, be sure to check for updates to that pipeline when you upgrade Sitecore.

Most processors are specified by type only, but there are other ways to specify a processor.

* **Description:** Only the processor type is specified
* **Example:** `<processor type="Sitecore.Analytics.Pipelines.StartAnalytics.Init, Sitecore.Analytics" />`
* **Method called:** `void Process(PipelineArgs)`

* **Description:** The processor type and method are specified
* **Example:** `<processor type="Sitecore.Jobs.JobRunner, Sitecore.Kernel" method="SetPriority" />`
* **Method called:** `void SetPriority(PipelineArgs)`

The second method is useful when are using the same processor class more than once in a pipeline (or across pipelines), with different methods, and you want to group this functionality together.

## <a name="custom_pipelines">Creating a Custom Pipeline</a>
Creating custom pipelines is an essential part of integrating an external system with Sitecore.

* [`PipelineArgs`](#pipelineargs)
* [Defining a Pipeline](#defining_a_pipeline)
* [Invoking a Pipeline](#invoking_a_pipeline)

### <a name="pipelineargs">`PipelineArgs`</a>
When creating a custom pipeline a custom `PipelineArgs` class is not required. The standard `PipelineArgs` class can be used.

However, a custom `PipelineArgs` class makes it easier to pass objects between processors and to provide output to the process that called the pipeline. At runtime the `PipelineArgs` object acts as the pipeline's context.

In order to create a custom `PipelineArgs` class you must inherit from `Sitecore.Pipeline.PipelineArgs`.

	public class MyPipelineArgs : Sitecore.Pipelines.PipelineArgs
	{
	    public string Val1 { get; set; }
	    public string Val2 { get; set; }
	}

> Objects used with `PipelineArgs` objects must be serializable

### <a name="defining_a_pipeline">Defining a Pipeline</a>
A pipeline itself is nothing more than a block of XML in the `configuration > Sitecore > pipelines` section of `Web.config` or a Sitecore patch file.

The following is an example of a custom pipeline definition.

	<myPipeline>
	  <processor type="Testing.SetVal1, Testing" />
	  <processor type="Testing.SetVal2, Testing" />
	</myPipeline>

Processors are executed in the order they are defined in the configuration.

### <a name="invoking_a_pipeline">Invoking a Pipeline</a>
The following is an example of calling a pipeline.

	var args = new Testing.MyPipelineArgs();
	Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);

Set values from the Sitecore context and from other static objects on the `PipelineArgs` object.
Pipelines run in a different context than the process (the request) that invokes the pipeline. Explicitly set any values you need on the `PipelineArgs` before running a pipeline.

> Pipelines run synchronously on the current thread, so be aware that a call into the pipeline will be a blocking call, until the pipeline has finished executed or is aborted.

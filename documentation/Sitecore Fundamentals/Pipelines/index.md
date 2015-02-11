---
layout: default
title: Sitecore Pipelines
---
Pipelines are one of Sitecore's essential integration concepts. They are used to extend existing functionality, and to allow custom functionality to be extended in the future. They also provide a level of documentation and transparency by virtual of how they are configured.

* [Pipeline Basics](#pipeline_basics)
* [Custom Pipelines](#custom_pipelines)
* [Processor Basics](#processor_basics)

## <a name="pipeline_basics">Pipeline Basics</a>

* [What is a Pipeline?](#what_is_a_pipeline)
* [Common Pipelines](#common_pipelines)
* [Extending a Pipeline](#extending_a_pipeline)
* [Configuring a Processor](#configuring_a_processor)
* [Custom Processors](#custom_processors)

#### <a name="what_is_a_pipeline">What is a Pipeline?</a>
A pipeline is basically a method whose flow is defined using XML. 

A pipeline consists of processors. A processor is a .NET class that implements a method. When a pipeline is invoked, the processors are run in order.

Pipelines are used to control most of Sitecore's functionality. Processes ranging from authentication to request handling to publishing to indexing are all controlled through pipelines.

Pipelines are defined in `Web.config` and in Sitecore patch files.

The following is an example of the pipeline that is responsible for rendering a page:

{% highlight xml %}
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
{% endhighlight %}

#### <a name="common_pipelines">Common Pipelines</a>

Sitecore includes more than 140 pipelines. Each new version of Sitecore adds pipelines. Installing Sitecore modules also results in more pipelines being added.

The following is a list of some of the more commonly used pipelines. It is unlikely you will ever call any of these pipelines directly, but it is not unusual to extend these pipelines.

Pipeline name|Defined in|Args type|Description
-|-|-|-
`initialize`|`Web.config`|`PipelineArgs`|Runs when the IIS application pool is started. Processors handle initialization tasks that need to run once.
`httpRequestBegin`|`Web.config`|`HttpRequestArgs`|Handles the HTTP request. This includes tasks such as resolving the context item, device and presentation settings.
`insertRenderings`|`Web.config`|`InsertRenderingsArgs`|Determines the presentation components to include when rendering an item.
`renderField`|`Web.config`|`RenderFieldArgs`|Runs when the FieldRenderer is used to render a field value.

#### <a name="extending_a_pipeline">Extending a Pipeline</a>

Pipelines are extended by adding or replacing processors. Extending a pipeline involves modifying the pipeline definition located in a Sitecore patch file.

The following is an example of how the Sitecore patch file `Sitecore.Analytics.config` extends the pipeline `httpRequestBegin`:

{% highlight xml %}
<httpRequestBegin>
  <processor type="Sitecore.Analytics.Pipelines.HttpRequest.StartDiagnostics,Sitecore.Analytics" patch:after="processor[@type='Sitecore.Pipelines.HttpRequest.StartMeasurements, Sitecore.Kernel']" />
  <processor type="Sitecore.Analytics.Pipelines.HttpRequest.PageLevelTestItemResolver,Sitecore.Analytics" patch:after="processor[@type='Sitecore.Pipelines.HttpRequest.ItemResolver, Sitecore.Kernel']" />
</httpRequestBegin>
{% endhighlight %}

#### <a name="configuring_a_processor">Configuring a Processor</a>
Most processors are specified by type only, but there are other ways to specify a processor.

* **Description:** Only the processor type is specified
* **Example:** `<processor type="Sitecore.Analytics.Pipelines.StartAnalytics.Init, Sitecore.Analytics" />`
* **Method called:** `void Process(PipelineArgs)`

----

* **Description:** The processor type and method are specified
* **Example:** `<processor type="Sitecore.Jobs.JobRunner, Sitecore.Kernel" method="SetPriority" />`
* **Method called:** `void SetPriority(PipelineArgs)`

----

#### <a name="custom_processors">Custom Processors</a>
While there is neither a class to extend nor an interface to implement, a convention must be followed in order for Sitecore to be in order for a class to be used as a processor: 

* If the processor has a method specified, the method must accept a `PipelineArgs` object and return `void` 
* If the processor does not have a method specified, the processor must have a method named `Process` which accepts a `PipelineArgs` object and returns `void`

The following is an example of a custom processor.

{% highlight csharp %}
public class SetVal1
{
    public void Process(MyPipelineArgs args)
    {
        Sitecore.Diagnostics.Assert.ArgumentNotNull(args, "args");
        //do something
    }
}
{% endhighlight %}

## <a name="custom_pipelines">Custom Pipelines</a>
Creating custom pipelines is an essential part of integrating an external system with Sitecore.

* [`PipelineArgs`](#pipelineargs)
* [Defining a Pipeline](#defining_a_pipeline)
* [Invoking a Pipeline](#invoking_a_pipeline)

#### <a name="pipelineargs">`PipelineArgs`</a>
When creating a custom pipeline a custom `PipelineArgs` class is not required. The standard `PipelineArgs` class can be used. 

However, custom a `PipelineArgs` class makes it easier to pass objects between processors and to provide output to the process that called the pipeline. At runtime the `PipelineArgs` object acts as the pipeline's context.

In order to create a custom `PipelineArgs` class you must inherit from `Sitecore.Pipeline.PipelineArgs`.

{% highlight csharp %}
public class MyPipelineArgs : Sitecore.Pipelines.PipelineArgs
{
    public string Val1 { get; set; }
    public string Val2 { get; set; }
}
{% endhighlight %}

> Objects used with `PipelineArgs` objects must be serializable

#### <a name="defining_a_pipeline">Defining a Pipeline</a>
A pipeline itself is nothing more than a block of XML in the `configuration > Sitecore > pipelines` section of `Web.config` or a Sitecore patch file.

The following is an example of a custom pipeline definition.

{% highlight xml %}
<myPipeline>
  <processor type="Testing.SetVal1, Testing" />
  <processor type="Testing.SetVal2, Testing" />
</myPipeline>
{% endhighlight %}

#### <a name="invoking_a_pipeline">Invoking a Pipeline</a>
The following is an example of calling a pipeline.

{% highlight csharp %}
var args = new Testing.MyPipelineArgs();
Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);
{% endhighlight %}

Set values from the Sitecore context and from other static objects on the `PipelineArgs` object
Pipelines run in a different context than the process (the request) that invokes the pipeline. Explicitly set any values you need on the `PipelineArgs` before running a pipeline.

## <a name="processor_basics">Processor Basics</a>
Processors provide the logic that is used when a pipeline is invoked.

* [Passing Data to a Pipeline](#passing_data_to_a_pipeline)
* [Reading Information from a Pipeline](#reading_information_from_a_pipeline)
* [Aborting a Pipeline](#aborting_a_pipeline)

#### <a name="passing_data_to_a_pipeline">Passing Data to a Pipeline</a>
When the base `PipelineArgs` class is used to run the pipeline, the `CustomData` property is used to pass parameters to the pipeline. This property is a `Dictionary<string, object>` object. 

{% highlight csharp %}
var args = new Sitecore.Pipelines.PipelineArgs();
args.CustomData.Add("product", "Sitecore");
Sitecore.Pipelines.CorePipeline.Run("somePipeline", args);
{% endhighlight %}

In addition, custom `PipelineArgs` classes can be created. This can make it easier to pass values to a pipeline. Values can be passed using a constructor or by properties.

{% highlight csharp %}
var args = new Testing.MyPipelineArgs();
args.Val2 = "value set before the pipeline runs";
Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);
{% endhighlight %}

#### <a name="reading_information_from_a_pipeline">Reading Information from a Pipeline</a>
The `PipelineArgs` object is what is used to read information from the pipeline. If you think of a pipeline as a method, then the `PipelineArgs` object is a parameter passed by reference to the method. Any of the processors in the pipelines may set fields on the `PipelineArgs` object. When the pipeline is finished running, the `PipelineArgs` object is still available and the fields can be read.

The following is an example of calling a pipeline and then reading a value that (ostensibly) has been set during the execution of the pipeline.

{% highlight csharp %}
var args = new Testing.MyPipelineArgs();
args.Val2 = "value set before the pipeline runs";
Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);
var val1 = args.Val1;
{% endhighlight %}

#### <a name="aborting_a_pipeline">Aborting a Pipeline</a>
Pipelines are made up of one or more processors. If a processor determines a condition exists that should prevent the rest of the processors from running, the processor can abort the pipeline. 

The following example shows how a processor can abort a pipeline.

{% highlight csharp %}
public class SetVal1
{
    public void Process(MyPipelineArgs args)
    {
        Sitecore.Diagnostics.Assert.ArgumentNotNull(args, "args");
        if (!string.IsNullOrEmpty(args.Val1))
        {
            args.AbortPipeline();
            return;
        }
        args.Val1 = "some value set by the processor";
    }
}
{% endhighlight %}

The code that invoked the pipeline might want to know if the pipeline was aborted. The following example shows how to determine whether the pipeline was aborted.

{% highlight csharp %}
var args = new Testing.MyPipelineArgs();
args.Val1 = "this value will result in the pipeline being aborted";
Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);
if (args.Aborted)
{
    //aborted
}
{% endhighlight %}

> An aborted pipeline does not indicate an error has occurred. 
> It simply means that one of the processors determined the 
> remaining processors do not need to run.

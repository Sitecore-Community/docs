---
layout: default
title: Pipeline Processors
category: pipelinesandevents
---

Processors provide the logic that is used when a pipeline is invoked.

* [Passing Data to a Pipeline](#passing_data_to_a_pipeline)
* [Reading Information from a Pipeline](#reading_information_from_a_pipeline)
* [Aborting a Pipeline](#aborting_a_pipeline)
* [Custom Processors](#custom_processors)

## <a name="passing_data_to_a_pipeline">Passing Data to a Pipeline</a>

When the base `PipelineArgs` class is used to run the pipeline, the `CustomData` property is used to pass parameters to the pipeline. This property is a `Dictionary<string, object>` object. 

	var args = new Sitecore.Pipelines.PipelineArgs();
	args.CustomData.Add("product", "Sitecore");
	Sitecore.Pipelines.CorePipeline.Run("somePipeline", args);

In addition, custom `PipelineArgs` classes can be created. This can make it easier to pass values to a pipeline. Values can be passed using a constructor or by properties.

	var args = new Testing.MyPipelineArgs();
	args.Val2 = "value set before the pipeline runs";
	Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);

## <a name="reading_information_from_a_pipeline">Reading Information from a Pipeline</a>
The `PipelineArgs` object is what is used to read information from the pipeline. If you think of a pipeline as a method, then the `PipelineArgs` object is a parameter passed by reference to the method. Any of the processors in the pipelines may set fields on the `PipelineArgs` object. When the pipeline is finished running, the `PipelineArgs` object is still available and the fields can be read.

The following is an example of calling a pipeline and then reading a value that (ostensibly) has been set during the execution of the pipeline.

	var args = new Testing.MyPipelineArgs();
	args.Val2 = "value set before the pipeline runs";
	Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);
	var val1 = args.Val1;

## <a name="aborting_a_pipeline">Aborting a Pipeline</a>
Pipelines are made up of one or more processors. If a processor determines a condition exists that should prevent the rest of the processors from running, the processor can abort the pipeline. 

The following example shows how a processor can abort a pipeline.

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

The code that invoked the pipeline might want to know if the pipeline was aborted. The following example shows how to determine whether the pipeline was aborted.

	var args = new Testing.MyPipelineArgs();
	args.Val1 = "this value will result in the pipeline being aborted";
	Sitecore.Pipelines.CorePipeline.Run("myPipeline", args);
	if (args.Aborted)
	{
	    //aborted
	}

> An aborted pipeline does not indicate an error has occurred. 
> It simply means that one of the processors determined the 
> remaining processors do not need to run.

## <a name="custom_processors">Custom Processors</a>
While there is neither a class to extend nor an interface to implement, a convention must be followed in order for Sitecore to be in order for a class to be used as a processor: 

* If the processor has a method specified, the method must accept a `PipelineArgs` object and return `void` 
* If the processor does not have a method specified, the processor must have a method named `Process` which accepts a `PipelineArgs` object and returns `void`

The following is an example of a custom processor.

	public class SetVal1
	{
	    public void Process(MyPipelineArgs args)
	    {
	        Sitecore.Diagnostics.Assert.ArgumentNotNull(args, "args");
	        //do something
	    }
	}

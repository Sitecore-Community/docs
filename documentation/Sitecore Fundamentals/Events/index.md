---
layout: default
title: Sitecore Events
category: extending
---
Events in Sitecore are similar to events in other systems: handlers subscribe to the event, and when the event is raised, the handlers are called. Many system events in Sitecore are exposed as events that you can subscribe to. It is also possible to add your own events to the system.

* [Event Basics](#event_basics)
* [Custom Events](#custom_events)
* [Remote Events](#remote_events)

## <a name="event_basics">Event Basics</a>

* [What is an Event?](#what_is_an_event)
* [Adding an Event Handler](#add_an_event_handler)
* [Accessing Values from EventArgs](#accessing_values_from_eventargs)

#### <a name="what_is_an_event">What is an Event?</a>
Events in Sitecore are similar to events in other systems: something triggers an event and there are handlers that are configured to handle the event.

Event handlers are similar to pipelines in how they are configured. An event handler is a .NET class that implements a method. When an event is triggered, the event handlers are run in order.

Event handlers are defined in Sitecore patch files.

The following is an example of the event handler that handles the item:deleted event.

	<event name="item:deleted">
	  <handler type="Sitecore.Links.ItemEventHandler, Sitecore.Kernel" 
	           method="OnItemDeleted" />
	  <handler type="Sitecore.Tasks.ItemEventHandler, Sitecore.Kernel" 
	           method="OnItemDeleted" />
	  <handler type="Sitecore.Globalization.ItemEventHandler, Sitecore.Kernel" 
	           method="OnItemDeleted" />
	  <handler type="Sitecore.Data.Fields.ItemEventHandler, Sitecore.Kernel" 
	           method="OnItemDeleted" />
	  <handler type="Sitecore.Rules.ItemEventHandler, Sitecore.Kernel" 
	           method="OnItemDeleted" />
	</event>


#### <a name="add_an_event_handler">Adding an Event Handler</a>
While there is neither a class to extend nor an interface to implement, a convention must be followed in order for Sitecore to be in order for a class to be used as an event handler.
 
The class must have a method that accepts two parameters and return void: 

1.	`object` - represents the object that holds a collection of the various event listeners
2.	`EventArgs` - holds the parameters being passed to the event handler

The following is an example of a custom processor.

	public class MyEventHandlers
	{
	    public void OnItemSaved(object sender, EventArgs args)
	    {
	        //do something
	    }
	}

> Consider including all related custom event handlers in a single class. 
> By putting all custom event handlers in a single class it is easier to 
> manage, maintain and keep track of them.

After the event handler is written, it must be added to the event definition. The event definition is located in a Sitecore patch file.

The following is an example of how the custom event handler is added to the Sitecore patch file.

	<event name="item:saved">
	  <handler type="Testing.MyEventHandler, Testing" method="OnItemSaved"/>
	</event>

> Consider including remote event handlers. Always assume your components 
> will be used in multi-server environments. Consider whether your event 
> handler should run on remote servers. If the event handler should be 
> run on remote servers, add an event handler for the remote event.

#### <a name="accessing_values_from_eventargs">Accessing Values from EventArgs</a>
Sitecore uses the .NET framework's event model to handle its events. This means that unless you use a custom `EventArgs` class (described [below](#eventargs)) you must use the `Event.ExtractParameter` method to extract parameters from the `EventArgs` object.

The following is an example of extracting a parameter from the `EventArgs` object.

	var item = Sitecore.Events.Event.ExtractParameter(args, 0) as Sitecore.Data.Items.Item;
	Sitecore.Diagnostics.Assert.IsNotNull(item, "No item in parameters");

> In order to use the `Event.ExtractParameter` method you must know the position 
> of the parameter you want to extract. If this information is not included with 
> the documentation, you must use your debugging skills to figure it out.

## <a name="custom_events">Custom Events</a>
While not as common as custom pipelines, custom events are useful options when integrating an external system with Sitecore.

* [EventArgs](#eventargs)
* [Defining an Event](#defining_an_event)
* [Raising an Event](#raising_an_event)

#### <a name="eventargs">EventArgs</a>
When creating a custom event a custom `EventArgs` class is not required. The standard `EventArgs` class can be used. 

However, a custom `EventArgs` class makes it easier to pass objects between event handlers and to provide output to the process that triggered the event. At runtime the `EventArgs` object acts as the event's context.

In order to create a custom `EventArgs` class you must inherit from `System.EventArgs`.

	public class MyEventArgs : System.EventArgs
	{
	    public string Val1 { get; set; }
	    public string Val2 { get; set; }
	}

> Objects used with `EventArgs` objects must be serializable

#### <a name="defining_an_event">Defining an Event</a>
An event itself is nothing more than a block of XML in the `/configuration/Sitecore/events` section of a Sitecore patch file.

The following is an example of a custom event definition.

	<testing:myevent>
	  <processor type="Testing.Events.SetVal1, Testing" />
	  <processor type="Testing.Events.SetVal2, Testing" />
	</testing:myevent>

> Event names should follow the convention used by Sitecore events. 
> The colon character is used to separate logical parts of the event name. 
> Some examples are `item:saved`, `item:saved:remote`, and `item:bucketing:added`.

#### <a name="raising_an_event">Raising an Event</a>
The following is an example of raising an event.

	public class EventRaiser
	{
	  public void RaiseEvent()
	  {
	    var args = new Testing.Events.MyEventArgs();
	    Sitecore.Events.Event.RaiseEvent("testing:myevent", args);
	  }
	}

> Set values from the Sitecore context and from other static objects on the `EventArgs` 
> object. Event handlers run in a different context than the process (the request) 
> that raises the event. Explicitly set any values you need on the `EventArgs` 
> before raising an event.

## <a name="remote_events">Remote Events</a>
Remote events are critical when Sitecore runs in a multi-server environment.

* [What is a Remote Event?](#what_is_a_remote_event)
* [Raising a Remote Event](#raising_a_remote_event)

#### <a name="what_is_a_remote_event">What is a Remote Event?</a>
When an event is triggered, the event handlers on that server run. For example, when an item is saved, the `item:saved` event is fired on that server. That causes the database to be updated and for the cache to be updated.

But what happens if you are using a multi-server environment? The database has already been updated, so that doesn't need to happen again. But the item may be cached on the other servers, so the cache needs to be updated. This is what remote events do. They ensure the appropriate handlers are run on remote servers.

The following is an example of the remote event handler for the `item:deleted` event. Another way of describing the following is it is an example of the event handlers for the `remote:item:deleted` event.

	<event name="item:deleted:remote">
	  <handler type="Sitecore.Globalization.ItemEventHandler, Sitecore.Kernel" 
	                  method="OnItemDeletedRemote" />
	  <handler type="Sitecore.Data.Fields.ItemEventHandler, Sitecore.Kernel" 
	                  method="OnItemDeletedRemote" />
	  <handler type="Sitecore.Rules.ItemEventHandler, Sitecore.Kernel" 
	                  method="OnItemDeletedRemote" />
	</event>

If your event requires a remote event be triggered on remote servers, you need to be sure that you raise the remote event.

In a multi-server Sitecore environment, the term "remote" describes each of the other servers in the environment. It is a relative designation. Remove servers are all of the servers in the environment except for the server that the code is currently running on.

#### <a name="raising_a_remote_event">Raising a Remote Event</a>
You don't directly raise remote events. Instead, you add an item to the event queue that indicates a remote event should be raised. The event queue is a shared resource. All servers in the environment access the same queue. Each server monitors the event queue. When an entry from another server is found, the remote event that is described in the event queue is raised.

Sitecore handles most of this process for you, but there are a few things you need to do. 

* [Representing the Remote Event](#representing_the_remote_event)
* [Adding an Entry to the Event Queue](#adding_an_entry_to_the_event_queue)
* [Subscribing to the Remote Event](#subscribing_to_the_remote_event)
* [Ensuring the Subscription Code Runs](#ensuring_the_subscription_code_runs)
* [Adding a Custom Remote Event Handler](#adding_a_custom_remote_event_handler)
* [Raising the Local Event (which raises the remote event)](#raising_the_local_event)
* [Complete Example](#complete_example)

###### <a name="representing_the_remote_event">Representing the Remote Event</a>
The Sitecore eventing API depends on classes that represent events. In order to subscribe to an event, you need to identify the class that represents the event. 

There are no special requirements for a class, apart from the members being serializable. When the event is written to the event queue, the properties on the event are written to the database.

The following is an example of a class that represents a custom remote event.

	public class MyEventRemote
	{
	    public string Param1 { get; set; }
	}

###### <a name="adding_an_entry_to_the_event_queue">Adding an Entry to the Event Queue</a>
Next you need to add an entry to the event queue. Often it makes sense to trigger the local event and to add the remote event to the event queue at the same time. The following is an example of this.

	public class EventRaiser
	{
	  public void RaiseEvent()
	  {
	    var parameters = new object[]{ "param1", "param2" };
	    Sitecore.Events.Event.RaiseEvent("testing:myevent", parameters);
	    Sitecore.Eventing.EventManager.QueueEvent<MyEventRemote>(new MyEventRemote());
	  }
	}

###### <a name="subscribing_to_the_remote_event">Subscribing to the Remote Event</a>
Now the event queue monitor will pick up the remote event, and any subscribers to that event will get notified. But the only subscribers who fit this description are subscribers who registered via code. What about event handlers configured via Sitecore patch file? What triggers those handlers?

Well, nothing does automatically. You must add code to trigger handlers defined in a Sitecore patch file. The following code demonstrates how to register a handler that will trigger the event `testing:myevent:remote`.

	public class EventHandlers
	{
	  public virtual void InitializeFromPipeline(PipelineArgs args)
	  {
	    var action = new Action<MyEventRemote>(RaiseRemoteEvent);
	    Sitecore.Eventing.EventManager.Subscribe<MyEventRemote>(action);
	  }
	  private void RaiseRemoteEvent(MyEventRemote myEvent)
	  {
	    Sitecore.Events.Event.RaiseEvent("testing:myevent:remote", 
	                                     new object[] { myEvent.Param1 });
	  }
	}

###### <a name="ensuring_the_subscription_code_runs">Ensuring the Subscription Code Runs</a>
Next you need to make sure this code runs before the remote events start getting triggered. The best place for this code is in the initialize pipeline. The following Sitecore patch file sets this up.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <pipelines>
	      <initialize>
	        <processor type="Testing.EventHandlers, Testing" method="InitializeFromPipeline" />
	      </initialize>
	    </pipelines>
	  </sitecore>
	</configuration>

###### <a name="adding_a_custom_remote_event_handler">Adding a Custom Remote Event Handler</a>
Now everything is set up to allow a developer to add event handlers for `testing:myevent:remote`. The following Sitecore patch file demonstrates how this is done.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <events>
	      <event name="testing:myevent">
	        <handler type="Testing.EventHandlers, Testing" method="OnMyEvent" />
	      </event>
	      <event name="testing:myevent:remote">
	        <handler type="Testing.EventHandlers, Testing" method="OnMyEventRemote" />
	      </event>
	    </events>
	  </sitecore>
	</configuration>

###### <a name="raising_the_local_event">Raising the Local Event (which raises the remote event)</a>
The following code is an example of how to raise the local event, which results in the remote event being raised.

	Sitecore.Events.Event.RaiseEvent("testing:myevent", new object[] { "test1", "test2" });

###### <a name="complete_example">Complete Example</a>
The following is the complete code for the example described in this section.

	public class MyEventRemote
	{
	    public string Param1 { get; set; }
	}

	public class EventRaiser
	{
	  public void RaiseEvent()
	  {
	    var parameters = new object[]{ "param1", "param2" };
	    Sitecore.Events.Event.RaiseEvent("testing:myevent", parameters);
	    Sitecore.Eventing.EventManager.QueueEvent<MyEventRemote>(new MyEventRemote());
	  }
	}

	public class EventHandlers
	{
	  public virtual void InitializeFromPipeline(PipelineArgs args)
	  {
	    var action = new Action<MyEventRemote>(RaiseRemoteEvent);
	    Sitecore.Eventing.EventManager.Subscribe<MyEventRemote>(action);
	  }
	
	  private void RaiseRemoteEvent(MyEventRemote myEvent)
	  {
	    Sitecore.Events.Event.RaiseEvent("testing:myevent:remote", 
	                                     new object[] { myEvent.Param1 });
	  }
	
	  protected virtual void OnMyEventRemote(object sender, EventArgs args)
	  {
	    //do something
	  }
	
	  protected virtual void OnMyEvent(object sender, EventArgs args)
	  {
	    var s1 = Sitecore.Events.Event.ExtractParameter<string>(args, 0);
	    var e = new MyEventRemote() {Param1 = s1};
	    Sitecore.Eventing.EventManager.QueueEvent<MyEventRemote>(e);
	  }
	}

The following is the complete Sitecore patch file described in this section.

	<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
	  <sitecore>
	    <pipelines>
	      <initialize>
	        <processor type="Testing.EventHandlers, Testing" method="InitializeFromPipeline" />
	      </initialize>
	    </pipelines>
	    <events>
	      <event name="testing:myevent">
	        <handler type="Testing.EventHandlers, Testing" method="OnMyEvent" />
	      </event>
	      <event name="testing:myevent:remote">
	        <handler type="Testing.EventHandlers, Testing" method="OnMyEventRemote" />
	      </event>
	    </events>
	  </sitecore>
	</configuration>


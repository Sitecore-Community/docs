---
layout: default
title: Sitecore Asynchronous Tasks
---
Sitecore provides the ability for custom tasks to run asynchronously.

* [Scheduler Basics](#scheduler_basics)
* [Agents](#agents)
* [Database Scheduler](#database_scheduler)
* [Jobs API](#jobs_api)

## <a name="scheduler_basics">Scheduler Basics</a>
Sitecore's scheduler is responsible for running background tasks.

* [Terminology](#terminology)
* [Configuring Agents](#configuring_agents)
* [How the Scheduler Runs Agents](#how_the_scheduler_runs_agents)

#### <a name="terminology">Terminology</a>
The following terminology is used to describe how Sitecore handles asynchronous tasks.

* **Scheduler** - Sitecore component that runs asynchronous tasks based on how the tasks are scheduled.
* **Task** - A unit of work that is executed asynchronously. A task is implemented as a method.
* **Agent** - The object used to schedule a task. The scheduler runs agents based on each agent's configuration.
* **Job** - A process that is running asynchronously. When an agent runs, it runs as a job.

#### <a name="configuring_agents">Configuring Agents</a>
An agent is used to configure a scheduled task. Agents are defined in `Web.config` and Sitecore patch files under `/configuration/sitecore/scheduling`. 

The following is an example of an agent that is scheduled to run every 4 hours.

```xml
<agent type="Sitecore.Tasks.CleanupHistory" method="Run" interval="04:00:00" />
```

#### <a name="how_the_scheduler_runs_agents">How the Scheduler Runs Agents</a>
The initialize pipeline includes a processor `Sitecore.Pipelines.Loader.InitializeScheduler`. This processor creates a new thread. This thread sleeps for the amount of time specified in `Web.config` or Sitecore patch file by the value of `/configuration/sitecore/scheduling/frequency`.

This does not mean that agents run based on this value. It means that the thread wakes up and checks for agents that are ready to run. An agent cannot run more often than this value, but an agent can be set to run less often.

An example is useful for understanding the relationship between the scheduler's frequency setting and the individual task's interval setting. Consider the following Sitecore patch file:

```xml
<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
  <sitecore>
    <scheduling>
      <frequency>00:05:00</frequency>
      <agent type="Testing.IntegrationGuide.Scheduler.MyTask1, Testing.IntegrationGuide" method="Run" interval="00:03:00" />
      <agent type="Testing.IntegrationGuide.Scheduler.MyTask2, Testing.IntegrationGuide" method="Run" interval="00:06:00" />
      <agent type="Testing.IntegrationGuide.Scheduler.MyTask3, Testing.IntegrationGuide" method="Run" interval="00:12:00" />
    </scheduling>
  </sitecore>
</configuration>
```

The following is an example of when the various tasks will run if the Sitecore server is started and the scheduler runs for the first time at 09:00.

Time|MyTask1|MyTask2|MyTask3
-|-|-|-
09:00|**Start**<br/>Last run: never|**Start**<br/>Last run: never|**Start**<br/>Last run: never
09:01|||
09:02|||
09:03|||
09:04|||
09:05|**Start**<br/>Last run: 09:00<br/>Interval: 00:03:00<br/>*More than 3 minutes has passed, so start*|**Do not start**<br/>Last run: 09:00<br/>Interval: 00:06:00<br/>*Fewer than 6 minutes has passed, so do not start*|**Do not start**<br/>Last run: 09:00<br/>Interval: 00:12:00<br/>*Fewer than 12 minutes has passed, so do not start*
09:06|||
09:07|||
09:08|||
09:09|||
09:10|**Start**<br/>Last run: 09:05<br/>Interval: 00:03:00<br/>*More than 3 minutes has passed, so start*|**Start**<br/>Last run: 09:00<br/>Interval: 00:06:00<br/>*More than 6 minutes has passed, so start*|**Do not start**<br/>Last run: 09:00<br/>Interval: 00:12:00<br/>*Fewer than 12 minutes has passed, so do not start*
09:11|||
09:12|||
09:13|||
09:14|||
09:15|**Start**<br/>Last run: 09:10<br/>Interval: 00:03:00<br/>*More than 3 minutes has passed, so start*|**Do not start**<br/>Last run: 09:10<br/>Interval: 00:06:00<br/>*Fewer than 6 minutes has passed, so do not start*|**Start**<br/>Last run: 09:00<br/>Interval: 00:12:00<br/>*More than 12 minutes has passed, so start*
09:16|||
09:17|||
09:18|||
09:19|||
09:20|**Start**<br/>Last run: 09:15<br/>Interval: 00:03:00<br/>*More than 3 minutes has passed, so start*|**Start**<br/>Last run: 09:10<br/>Interval: 00:06:00<br/>*More than 6 minutes has passed, so start*|**Do not start**<br/>Last run: 09:15<br/>Interval: 00:12:00<br/>*Fewer than 12 minutes has passed, so do not start*

## <a name="agents">Agents</a>
Agents are used to schedule tasks. 

* [Implementing a Task](#implementing_a_task)
* [Scheduling Agents using Sitecore Patch Files](#scheduling_agents_using_sitecore_patch_files)
* [Context](#context)
* [Logging](#logging)
* [Units Processed](#units_processed)
* [Performance](#performance)
* [Security](#security)

#### <a name="implementing_a_task">Implementing a Task</a>
A task is a method that is run by an agent. The method must have a specific method signature:

```c#
public void Run()
```

Task methods do not return values and they accept no parameters. In order to pass parameters, use the class constructor or properties.

#### <a name="scheduling_agents_using_sitecore_patch_files">Scheduling Agents using Sitecore Patch Files</a>
Scheduled tasks can be configured using a Sitecore patch file.

The following is an example of how to schedule a task using a Sitecore patch file.

```xml
<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
  <sitecore>
    <scheduling>
      <agent type="Testing.IntegrationGuide.Scheduler.MyTask, Testing.IntegrationGuide" method="Run" interval="01:00:00">
      </agent>
    </scheduling>
  </sitecore>
</configuration>
```

Parameters can be passed to tasks using dependency injection. For more information on using dependency injection in [this section]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Dependency injection).

#### <a name="context">Context</a>
When an agent is run, Sitecore calls the specified method. The method is called outside of the standard Sitecore request-handling process. As a result, the Sitecore context is not fully initialized.

One part of the Sitecore context that is initialized is `Sitecore.Context.Job`. This property provides access to an object that represents the current job.

#### <a name="logging">Logging</a>
Task logging is best handled by using the `Status` property on `Sitecore.Context.Job`. The following is an example of how to log messages from a task.

```c#
public virtual void Run()
{
    Sitecore.Context.Job.Status.LogError("error message");
    Sitecore.Context.Job.Status.LogInfo("info message");
    Sitecore.Context.Job.Status.LogException(new Exception("exception happened"));
}
```

#### <a name="units_processed">Units Processed</a>
If you look in the Sitecore log you will see messages (logged at INFO level) that indicate when a job started and when it stopped.

```
ManagedPoolThread #15 12:43:28 INFO  Scheduling.DatabaseAgent started. Database: master
ManagedPoolThread #15 12:43:28 INFO  Job ended: Sitecore.Tasks.DatabaseAgent (units processed: 2)
```

Some of the "Job ended" messages include a "units processed" count. If you want your task to be able to report this value, use the following code.

```
Sitecore.Context.Job.Status.Processed = 44;
```

#### <a name="performance">Performance</a>
Agents can cause performance problems on a Sitecore server. It is important to use them appropriately.

#### <a name="security">Security</a>
Scheduled tasks run as the anonymous user. A security disabler can be used to imitate specific users.

## <a name="database_scheduler">Database Scheduler</a>
Sitecore's Database Agent allows tasks to be scheduled in a Sitecore database. This means Content Editor can be used to schedule tasks.

* [Database Agent](#database_agent)
* [Commands and Schedules](#commands_and_schedules)
* [Implementing a Command Method](#implementing_a_command_method)
* [Defining a Command](#defining_a_command)
* [Defining a Schedule](#defining_a_schedule)

#### <a name="database_agent">Database Agent</a>
The Database Agent is an agent that comes enabled by default. Just like all other agents, database agents are defined in `Web.config` or a Sitecore patch file under `/configuration/sitecore/scheduling`.

Each Sitecore database has its own database scheduler. The following is an example of the database agent for the master database.

```xml
<agent type="Sitecore.Tasks.DatabaseAgent" method="Run" interval="00:10:00">
  <param desc="database">master</param>
  <param desc="schedule root">/sitecore/system/tasks/schedules</param>
  <LogActivity>true</LogActivity>
</agent>
```

The `Sitecore.Tasks.DatabaseAgent` constructor expects following parameters:

* `string databaseName` - Name of the Sitecore database that has the scheduled tasks.
* `string scheduleRoot` - Path to the Schedule items in the Sitecore database.

In addition, `Sitecore.Tasks.DatabaseAgent` supports the following properties:

* `bool LogActivity` - The database agent logs basic activity at the INFO level. If `true` the agent will write to the Sitecore log. If `false` the agent will not write to the Sitecore log.


#### <a name="commands_and_schedules">Commands and Schedules</a>
A command is a Sitecore item that specifies a type and method that can be run by a database agent.

A schedule is a Sitecore item that specifies when a command should be executed.

#### <a name="implementing_a_command_method">Implementing a Command Method</a>
Command methods must have a specific method signature:

```c#
public void Run(Sitecore.Data.Items.Item[] items, Sitecore.Tasks.CommandItem command, Sitecore.Tasks.ScheduleItem schedule)
```

Parameters:
* `Sitecore.Data.Items.Item[] items` - When a command is scheduled, items can be specified. This parameter represents those items. If no items are specified, this array will be a 0-length array.
* `Sitecore.Tasks.CommandItem command` - This parameter represents the command item.
* `Sitecore.Tasks.ScheduleItem schedule` - This parameter represents the schedule that resulted in the command being executed.

> Agents can cause performance problems on a Sitecore server. It is important to use them appropriately.

#### <a name="defining_a_command">Defining a Command</a>
Commands are defined in the Sitecore client.

1.	In Content Editor navigate to `/sitecore/system/Tasks/Commands`
2.	Create a new item using the `Command` template
3.	Specify the `Type` and `Method` fields.

#### <a name="defining_a_schedule">Defining a Schedule</a>
The database agent will execute the command based on the settings in the schedule.

1.	In Content Editor navigate to `/sitecore/system/Tasks/Schedules`
2.	Create a new item using the `Schedule` template
3.	For the `Command` field select the Command item you just created
4.	If the task applies to specific items, you can identify those items in the `Items` field. This field supports a couple of [formats](#items_field_formats).
5.	For the `Schedule` field, you identify when the task should run. The value for this field is in a [pipe-separated format](#schedule_field_values).

###### <a name="items_field_formats">`Items` field formats</a>
The following are examples of values you can use for the `Items` field on a `Schedule` item.

----

**Kind:** Single item<br/>
**Description:** a path to the Sitecore item<br/>
**Example:** `/sitecore/content/Home`

----

**Kind:** Multiple items<br/>
**Description:** pipe-delimited set of paths to Sitecore items<br/>
**Example:** <code>/sitecore/content/Home/Item1&#124;/sitecore/content/Home/Item2</code>

----

**Kind:** Query<br/>
**Description:** Sitecore Query format, but without the `query:` prefix<br/>
**Example:** `/sitecore/content/Home/*`

----

###### <a name="schedule_field_values">`Schedule` field values</a>
The `Schedule` field on a `Schedule` item expects a pipe-delimited value make up of the following parts.

----

**Position:** 1<br/>
**Name:** Start date/time<br/>
**Description:** The task will not run before this date/time (in ISO format)<br/>
**Example:** `20040720T235900`

----

**Position:** 2<br/>
**Name:** End date/time<br/>
**Description:** The task will not run after this date/time (in ISO format)<br/> 
**Example:** `20060725T235900`

----

**Position:** 3<br/>
**Name:** Days flag<br/>
**Description:** The days of the week when the task should run. The value is a flag, so the individual values below must be added in order to specify the days:

* Sunday = 1
* Monday = 2
* Tuesday = 4
* Wednesday = 8
* Thursday = 16
* Friday = 32
* Saturday = 64

**Example:** `127`

----

**Position:** 4<br/>
**Name:** Interval<br/>
**Description:** How often the task should run, in `HH:mm:ss` format<br/>
**Example:** `01:00:00`

----

## <a name="jobs_api">Jobs API</a>

* [Starting a Job Programmatically](#starting_a_job_programmatically)
* [Job Status](#job_status)
* [Expiration](#expiration)
* [Priority](#priority)
* [Events](#events)

#### <a name="starting_a_job_programmatically">Starting a Job Programmatically</a>
The following is an example of how to start a job programmatically.

```c#
public class JobRunner
{
    public Job CurrentJob { get; set; }

    public void StartJob()
    {
        var jobName = "job name";
        var jobCategory = "tests";
        var siteName = Sitecore.Context.Site.Name;
        var objectWithMethodToRun = this;
        var methodName = "Run";
        var methodParameters = new Object[] {};
        var options = new Sitecore.Jobs.JobOptions(jobName, jobCategory, siteName, 
                                                          objectWithMethodToRun, methodName, 
                                                          methodParameters);
        this.CurrentJob = Sitecore.Jobs.JobManager.Start(options);
    }

    public void Run()
    {
        if (this.CurrentJob != null)
        {
            //do something
        }
    }
}
```

The `Sitecore.Jobs.JobOptions` instance tells Sitecore what to do. The constructor expects the following parameters:

* `string jobName` - Name used to identify the job.
* `string category` - Category used to group similar jobs. This value is arbitrary and can be used for whatever purposes you need. (Sitecore uses it certain cases to ensure that only appropriate tasks are performed. For example, the scheduler uses it to ensure that it only interacts with scheduled jobs.)
* `string siteName` - Name of the site that `Sitecore.Context.Site` is initialized with.
* `object obj` - The object whose method will be run.
* `string methodName` - The name of the method on the `obj` parameter that will be run.
* `object[] parameters` - Parameters that are passed to the method that is run.

#### <a name="job_status">Job Status</a>
The `Sitecore.Jobs.Job` class has a property `Status`. This property is an instance of the `Sitecore.Jobs.JobStatus` class. This object is used to indicate the job's status. 

The properties on this object do not change how the job runs, but the values are important for communicating what your code is doing.

> Consider setting the job status in your code. This will make it easier to debug problems.

#### <a name="expiration">Expiration</a>
A job runs as a thread, and when the thread returns, the job is finished. Sitecore keeps the job around for a limited amount of time afterwards in case you want to check its status. This is called the "after-life".

By default the after-life value is 1 minute. It can be changed using the `Options` property on the job.

```c#
var job = Sitecore.Jobs.JobManager.GetJob("job name");
if (job != null)
{
    job.Options.AfterLife = new TimeSpan(0, 5, 0);
}
```

#### <a name="priority">Priority</a>
A job runs as a thread, so it is possible to set the thread priority. 

```c#
var options = new Sitecore.Jobs.JobOptions(...);
options.Priority = System.Threading.ThreadPriority.Highest;
Sitecore.Jobs.JobManager.Start(options);
```

> Do not change the priority of a thread after it has started. This is a standard .NET recommendation.

#### <a name="events">Events</a>
The following job-related events are available.

----

**Name:** `job:starting`<br/>
**Description:** Raised before a job is placed into the thread pool<br/>
**Sample handler:** 

```c#
public virtual void OnJobStarting(Object sender, EventArgs e)
{
    Assert.ArgumentNotNull(sender, "sender");
    Assert.ArgumentNotNull(e, "e");
    if (e is SitecoreEventArgs)
    {
        var args = Event.ExtractParameter<JobStartingEventArgs>(e, 0);
        //do something
    }
}
```

----

**Name:** `job:started`<br/>
**Description:** Raised after a job is placed into the thread pool and has been started<br/>
**Sample handler:** 

```c#
public virtual void OnJobStarted(Object sender, EventArgs e)
{
    Assert.ArgumentNotNull(sender, "sender");
    Assert.ArgumentNotNull(e, "e");
    if (e is SitecoreEventArgs)
    {
        var args = Event.ExtractParameter<JobStartedEventArgs>(e, 0);
        //do something
    }
}
```

----

**Name:** `job:ended`<br/>
**Description:** Raised during the `Job_Finished` event<br/>
**Sample handler:** 

```c#
public virtual void OnJobEnded(Object sender, EventArgs e)
{
    Assert.ArgumentNotNull(sender, "sender");
    Assert.ArgumentNotNull(e, "e");
    if (e is SitecoreEventArgs)
    {
        var args = Event.ExtractParameter<JobFinishedEventArgs>(e, 0);
        //do something
    }
}
```

----
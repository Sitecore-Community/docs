---
layout: default
title: Sitecore Logging
---
Logging is an important way to ensure that the people responsible for maintaining a Sitecore system are able to identify and fix problems. 

* [Logging Basics](#logging_basics)
* [Writing to a Sitecore Log](#writing_to_a_sitecore_log)
* [Custom Logs](#custom_logs)

## <a name="logging_basics">Logging Basics</a>

#### Apache log4net
Sitecore uses Apache log4net for logging. Configuration settings for log4net are defined in `Web.config` under `configuration/log4net`.

Do not put log4net settings in a Sitecore patch file. Log4net is not a Sitecore component. Only Sitecore components can be configured using Sitecore patch files. 

#### Standard Logs
By default Sitecore uses the following logs:

* **Log** - All-purpose, general Sitecore log.
* **WebDAV** - Log for WebDAV activity. If you are not using WebDAV, this log will be empty.
* **Search** - Activity from searches performed using Sitecore search providers.
* **Crawling** - Activity from crawling performed by Sitecore search providers.
* **Publishing** - Activity from publishing performed by Sitecore servers.
* **Fxm** - Activity from Federated Experience Manager. If you are not using FXM, this log will be empty.

#### Log Levels
Each log has a log level assigned to it. This log level limits the messages that are written to the log. Log level is also called priority.

For example, on a testing server you may be looking for any opportunity to tune performance. In this case, you would lower the log level so you get as much information from the system as possible. But on a production server, you might only be interested in errors. By setting the log level appropriately on each server, you have the ability to capture the amount of logging needed.

The following is a list of log levels (priorities) from lowest to highest severity. 

1.	DEBUG
2.	INFO
3.	WARN
4.	ERROR
5.	FATAL

This means that if the log level is set to INFO, messages logged at the INFO level will be recorded, as will messages logged at all of the higher levels (WARN, ERROR, and FATAL). DEBUG messages will not be logged because they have a lower level than INFO.

The following is an excerpt from `Web.config` that shows the log level (priority) assigned to the main Sitecore log:

{% highlight xml %}
<log4net>
  <appender name="LogFileAppender" 
            type="log4net.Appender.SitecoreLogFileAppender, Sitecore.Logging">
    <file value="$(dataFolder)/logs/log.{date}.txt" />
    <appendToFile value="true" />
    <layout type="log4net.Layout.PatternLayout">
      <conversionPattern value="%4t %d{ABSOLUTE} %-5p %m%n" />
    </layout>
  </appender>
  <root>
    <priority value="INFO" />
    <appender-ref ref="LogFileAppender" />
  </root>
</log4net>
{% endhighlight %}

## <a name="writing_to_a_sitecore_log">Writing to a Sitecore Log</a>
In your integration you may want to write to the Sitecore log. The class `Sitecore.Diagnostics.Log` contains a number of methods that provide logging at different severity levels.

#### `Audit`
An audit message indicates that a user has performed an action in the Sitecore client. Audit messages are INFO level messages. They will only be recorded if the level level is set to INFO.

The following code...

{% highlight csharp %}
var msg = "my audit message";
Log.Audit(msg, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3936 11:52:40 INFO  AUDIT (sitecore\admin): my audit message
{% endhighlight %}

#### `Debug`
A debug message records information that may be useful during troubleshooting or debugging, but is generally not needed on a routine basis. As a result, most Sitecore servers are not set to record debug messages.

The following code...

{% highlight csharp %}
var msg = "my debug message";
Log.Debug(msg, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3940 15:35:54 DEBUG my debug message
{% endhighlight %}

#### `Error`
An error message indicates an error has occurred.

The following code...

{% highlight csharp %}
var msg = "my error message";
Log.Error(msg, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3936 11:52:40 ERROR my error message
{% endhighlight %}

#### `Fatal`
A fatal message indicates something has happened where significant loss of functionality is likely to follow.

The following code...

{% highlight csharp %}
var msg = "my fatal message";
Log.Fatal(msg, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3936 11:52:40 FATAL my fatal message
{% endhighlight %}

#### `Info`
An info message indicates a routine condition. INFO is the default logging level on a Sitecore server, so any Sitecore server that has not been changed will include info messages in its log.

The following code...

{% highlight csharp %}
var msg = "my info message";
Log.Info(msg, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3936 11:52:40 INFO my info message
{% endhighlight %}

#### `SingleError`
This method is used to record error conditions that should only be recorded in the log one time.

The following code...

{% highlight csharp %}
var msg = "my single error message";
Log.SingleError(msg, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3940 15:35:54 ERROR my single error message
{% endhighlight %}

#### `SingleFatal`
This method is used to record fatal conditions that should only be recorded in the log once time.

The following code...

{% highlight csharp %}
var msg = "my single fatal message";
var ex = new Exception("My fatal exception);
Log.SingleFatal(msg, ex, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3940 15:35:54 FATAL SINGLE MSG: my single fatal message
Exception: System.Exception
Message: My fatal exception
{% endhighlight %}

#### `Warn`
A warn message indicates a condition that, while not an error, is something an administrator might want to investigate.

The following code...

{% highlight csharp %}
var msg = "my warn message";
Log.Warn(msg, this);
{% endhighlight %}

... results in the following message in the log:

{% endhighlight %}
3940 15:35:54 WARN  my warn message
{% endhighlight %}

## <a name="custom_logs">Custom Logs</a>
Sitecore allows you to add custom logs.

#### When to Consider Custom Logs
The main Sitecore log is sufficient in many cases, but there are cases when custom logs are useful:

* **Concentrate your logging.** By using a custom logs you can ensure that your messages are available in one place and are not interrupted by other messages.  This may make it easier to identify problems and to support your integration.
* **Ability to control log level.** A custom log can have a different log level from the Sitecore log. This means that you can debug your integration independent of the Sitecore log.

You should also be aware of the disadvantages of using custom logs:

* **May complicate troubleshooting.** By moving your logging outside of the Sitecore log you lose the continuing narrative that a central log provides. Conditions that led up to an error may have been recorded in the Sitecore log. If you use a custom log, tracing the error may require looking through multiple logs and matching timestamps.
* **Monitoring tools may be unaware of custom logs.** The Sitecore log may be monitored by external tools. Those tools may know to monitor or handle custom logs. 

#### Adding Custom Logs
Since Sitecore uses log4net, log messages can be written to a variety of sources: files, databases, event viewer, and more. This section describes how to add a custom log named MyLog that is written to a file.

1.	Open `Web.config` 
2.	Navigate to `configuration > log4net`
3.	Add the following:
{% highlight xml %}
<appender name="MyLogFileAppender" 
                 type="log4net.Appender.SitecoreLogFileAppender, Sitecore.Logging">
  <file value="$(dataFolder)/logs/log.{date}.txt" />
  <appendToFile value="true" />
  <layout type="log4net.Layout.PatternLayout">
    <conversionPattern value="%4t %d{ABSOLUTE} %-5p %m%n" />
  </layout>
</appender>
<logger name="MyLog" additivity="false">
  <priority value="INFO" />
  <appender-ref ref="MyLogFileAppender" />
</logger>
{% endhighlight %}
4.	Save your changes.

#### Writing to Custom Logs
The following is an example of the code needed to write to a custom log:

{% highlight csharp %}
var logger = Sitecore.Diagnostics.LoggerFactory.GetLogger("MyLog");
logger.Info("This is an info message for my custom log");
{% endhighlight %}

> Consider creating a helper class for custom logs. When you write 
> to the Sitecore log you use the `Sitecore.Diagnostics.Log` class. 
> Creating a similar class for a custom log makes it easier 
> to write to the log in a consistent way.

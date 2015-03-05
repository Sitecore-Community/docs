---
layout: default
title: Sitecore Settings
category: config
---
Settings are used to store values that are accessed by code when the code needs to perform a task. A setting is name and a value.

* [Defining Settings](#defining_settings)
* [Reading Settings from Code](#reading_settings_from_code)

## <a name="defining_settings">Defining Settings</a>
Settings are defined in the Sitecore configuration section under `sitecore/settings`.

> Do not define custom settings directly in `Web.config`. Only Sitecore platform settings 
> should be defined in `Web.config`. Custom settings for a module should be defined in 
> the module's [patch file]({{ site.baseurl }}/documentation/Sitecore Fundamentals/Patch Files).

## <a name="reading_settings_from_code">Reading Settings from Code</a>
The Sitecore API provides a variety of methods that can be used to read settings. The methods are available on the `Sitecore.Configuration.Settings` class.

* `GetSetting(string, string)` - Reads the setting as a string.
* `GetBoolSetting(string, bool)`- Reads the setting as a bool.
* `GetDoubleSetting(string, string)` - Reads the setting as a double.
* `GetIntSetting(string, string)` - Reads the setting as an int.
* `GetLongSetting(string, string)` - Reads the setting as a long.
* `GetTimeSpanSetting(string, string)` - Reads the setting as a TimeSpan.

> While there is an API that allows a developer to write settings, this API should not be used. 
> The API will only update the `Web.config` file. If a setting is defined in a patch file, or 
> should be saved to a patch file, using the API will result in the `Web.config` file being 
> updated. This may result in undesired results. 

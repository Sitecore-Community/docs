---
layout: default
title: Sitecore Patch Files
---
Since Sitecore runs within IIS, it is natural for Sitecore to be configured using IIS's configuration file, `Web.config`. The path to Sitecore-specific settings is `/configuration/sitecore`.

Sitecore supports distributed configuration. This means that Sitecore-specific settings (those settings located under `/configuration/sitecore`) can be spread out between multiple files. The process Sitecore uses to merge multiple config files is called called "config patching".

* [How Patching Works](#patching_explained)
* [How to See the Result of Patching](#patching_results)
* [Patching Examples](#examples)

## <a name="patching_explained">How Patching Works</a>
Sitecore uses a custom [configuration section handler](http://msdn.microsoft.com/en-us/library/system.configuration.iconfigurationsectionhandler.aspx) to merge patch files. The handler finds files with the `.config` extension in the `/App_Config/Include` folder and combines the files it finds with `Web.config`. The combined configuration is used at runtime.

### Patch File Names
Patch files are merged with `Web.config` in alphabetical order. This means configuration in a patch file named `a.config` will appear before configuration in a patch file named `b.config`. 

When the same configuration is found in multiple patch files, the configuration from the last patch file processed is the configuration that is used.

### Patch File Folders
Subfolders of `/App_Config/Include` are processed after files in the `/App_Config/Include`folder. Folders are processed in alphabetical order, as are the files in each folder.

For example, if the same configuration is defined in the following files the configuration from the last file listed is used:

1. `/App_Config/Include/z.config`
2. `/App_Config/Include/b/b.config`
3. `/App_Config/Include/b/c.config`
4. `/App_Config/Include/c/a.config` **[used]**    

### Limitations
Patching only works on the Sitecore configuration section. This is located in `Web.config` under `/configuration/sitecore`. Configuration in other sections of `Web.config` cannot be controlled through patching.

## <a name="patching_results">How to See the Result of Patching</a>
Since the Sitecore configuration is the result of the merging of configuration from `Web.config` with a variable number of patch files, you cannot look at `Web.config` or any individual patch file in order to determine the configuration Sitecore is using. Sitecore includes an admin script to do this.

The script displays the results of the config file patching process. 

`http://[host]/sitecore/admin/ShowConfig.aspx`

## <a name="examples">Patching Examples</a>
The following are examples of how patching can be used to affect Sitecore configuration.

* [Patch file merging](#example_merging)
* [Overriding configuration](#example_overriding)
* [Inserting before a specific position](#example_insert_before_relative)
* [Inserting before a specific element](#example_insert_before_specific)
* [Inserting after a specific position](#example_insert_after_relative)
* [Inserting after a specific element](#example_insert_after_specific)

#### <a name="example_merging">Example: patch file merging</a>
Configuration from different files are merged in the order the patch files are processed.

	<!-- Web.config -->
	<settings>
	  <setting name="name" value="Aaron" />
	</settings>

	<!-- /App_Config/Include/file1.config -->
	<settings>
	  <setting name="city" value="New York" />
	</settings>

	<!-- /App_Config/Include/file2.config -->
	<settings>
	  <setting name="country" value="USA" />
	</settings>

The following configuration is used at runtime. In this case the order of the elements doesn't matter because the elements are all different configurations:

	<settings>
	  <setting name="name" value="Aaron" />
	  <setting name="city" value="New York" />
	  <setting name="country" value="USA" />
	</settings>

#### <a name="example_merging">Example: overriding configuration</a>
The configuration from one file can override the configuration from another file.

	<!-- Web.config -->
	<settings>
	  <setting name="name" value="Charles" />
	</settings>
	
	<!-- /App_Config/Include/file1.config -->
	<settings>
	  <setting name="name" value="Brian" />
	</settings>
	
	<!-- /App_Config/Include/file2.config -->
	<settings>
	  <setting name="name" value="Aaron" />
	</settings>

The following configuration is used at runtime. The configuration from the last patch file processed is used:

	<settings>
	  <setting name="name" value="Aaron" />
	</settings>

#### <a name="example_insert_before_relative">Example: inserting before a specific position</a>
The configuration from one file can be inserted before the element at a specific position. In this example a processor is added before the first processor.

	<!-- Web.config -->
	<test>
	  <processor type="test1" />
	  <processor type="test2" />
	  <processor type="test3" />
	</test>
	
	<!-- Patch file -->
	<test>
	  <processor type="testA" patch:before = "*[1]"/>
	</test>

The following configuration is used at runtime:

	<test>
	  <processor type="testA" />
	  <processor type="test1" />
	  <processor type="test2" />
	  <processor type="test3" />
	</test>

#### <a name="example_insert_before_specific">Inserting before a specific element</a>
The configuration from one file can be inserted before a specific element. In this example a processor is added before the processor with the type `test2`.

	<!-- Web.config -->
	<test>
	  <processor type="test1" />
	  <processor type="test2" />
	  <processor type="test3" />
	</test>
	
	<!-- Patch file -->
	<test>
	  <processor type="testA" patch:before = "processor[@type='test2']"/>
	</test>

The following configuration is used at runtime:

	<test>
	  <processor type="test1" />
	  <processor type="testA" />
	  <processor type="test2" />
	  <processor type="test3" />
	</test>

#### <a name="example_insert_after_relative">Inserting after a specific position</a>
The configuration from one file can be inserted after the element at a specific position. In this example a processor is added after the first processor.

	<!-- Web.config -->
	<test>
	  <processor type="test1" />
	  <processor type="test2" />
	  <processor type="test3" />
	</test>
	
	<!-- Patch file -->
	<test>
	  <processor type="testA" patch:after = "*[1]"/>
	</test>

The following configuration is used at runtime:

	<test>
	  <processor type="test1" />
	  <processor type="testA" />
	  <processor type="test2" />
	  <processor type="test3" />
	</test>

#### <a name="example_insert_after_specific">Inserting after a specific element</a>
The configuration from one file can be inserted after a specific element. In this example a processor is added after the processor with the type `test2`.

	<!-- Web.config -->
	<test>
	  <processor type="test1" />
	  <processor type="test2" />
	  <processor type="test3" />
	</test>

	<!-- Patch file -->
	<test>
	  <processor type="testA" patch:after = "processor[@type='test2']"/>
	</test>

The following configuration is used at runtime:

	<test>
	  <processor type="test1" />
	  <processor type="test2" />
	  <processor type="testA" />
	  <processor type="test3" />
	</test>



---
layout: default
title: Fast track Solr for lazy Sitecore developers
category: search
---

Please use this document only if you don't need to do anything specific and you are not installing in production (or you do, but you are really sure in what you are doing). 
Ideal for testing locally. SOLR 4.10, Sitecore 8.1 versions (might also work for 8.0, needs checking)


## Shortest guide version
...if you have already done installing and configuring before and you are just looking for links:

* [SOLR 4.10 installer](http://archive.apache.org/dist/lucene/solr/4.10.4/solr-4.10.4.zip) 
* [Sitecore Solr Support package for 8.1 update-3](https://dev.sitecore.net/~/media/7CE11E1730444897A41D89D2333019E6.ashx)

* [Clean Sitecore SOLR 4.10 cores](https://www.dropbox.com/s/0sf9esus1c3eypa/Clean%20SOLR%20cores%204.10.zip?dl=0)
* [Script disabling all Lucene configs](https://www.dropbox.com/s/cvel877qg4opvyd/disablelucene.bat?dl=0) - put to App_Config/Include and run from command line 
* [Script enabling all Solr configs](https://www.dropbox.com/s/d1fwvocdchruq8l/enablesolr.bat?dl=0) - put to App_Config/Include and run from command line
* [Microsoft.Practices.Unity.dll](https://www.dropbox.com/s/pu6mgbrvz52ie9z/Microsoft.Practices.Unity.dll?dl=0) 
* [Changed Global.asax](https://www.dropbox.com/s/32z16hkwiwm280h/Global.asax?dl=0)


## Longer guide version
...if you are doing it first time

**Step 1:** Download [SOLR 4.10 installer](http://archive.apache.org/dist/lucene/solr/4.10.4/solr-4.10.4.zip) and unpack anywhere.

**Notes:**

Currently officially supported version of SOLR is 4.10. A list of supported versions you can see in the compatibility table at [this KB article](https://kb.sitecore.net/articles/227897)

If you want to install it through Bitnami, [Here is a link to SOLR Bitnami installer for 4.10](https://www.dropbox.com/s/599lglniv58gxf9/bitnami-solr-4.10.3-0-windows-installer.exe?dl=0).

If officially supported version changes to 5+, or you want to use SOLR version 5+, sorry, for now you'll need to use [the fullest guide]({{ site.baseurl }}/search/solr/Configuring-Solr-for-use-with-Sitecore-8/).


**Step 2:** Download [clean Sitecore SOLR cores](https://www.dropbox.com/s/0sf9esus1c3eypa/Clean%20SOLR%20cores%204.10.zip?dl=0) carefully created for you by me <3. These are all the cores needed to run Sitecore 8.1 with SOLR.

Unpack the archive and put the cores to the place where your example SOLR cores are. It will be C:\solr-4.10.4\example\solr or C:\Bitnami\solr-4.7.1-1\apache-solr\solr. 

The shortest definitive guide of finding where your SOLR cores should lie is "find a folder with collection1 in it, that doesn't have anything about schemaless or morphlines in path". Example:

<img src="/docs/images/search/solr/fast-track/corefolder.png" style="margin:5px 15px" />

This is how the folder will look like after you unpack cores there:

<img src="/docs/images/search/solr/fast-track/corefolderdone.png" style="margin:5px 15px" />

**Step 3:** Go to folder C:\solr-4.10.4\bin (this folder should contain solr.cmd) and run Windows Command Line there. Type "solr start" in command line:

<img src="/docs/images/search/solr/fast-track/solrstarted.png" style="margin:5px 15px" />

Now you should have SOLR running at http://localhost:8983/solr/#/ with all our cores visible in Core Selector:

<img src="/docs/images/search/solr/fast-track/solrrunning.png" style="margin:5px 15px" />

**Step 4:** Download [Script disabling all Lucene configs](https://www.dropbox.com/s/cvel877qg4opvyd/disablelucene.bat?dl=0).
Put the script to App_Config/Include and run from command line. You should see the next output:

<img src="/docs/images/search/solr/fast-track/disablelucene.png" style="margin:5px 15px" />

**Step 5:** [Script enabling all Solr configs](https://www.dropbox.com/s/d1fwvocdchruq8l/enablesolr.bat?dl=0).
Put the script to App_Config/Include and run from command line. You should see the next output:

<img src="/docs/images/search/solr/fast-track/enablesolr.png" style="margin:5px 15px" />

**Step 6:** Unpack Sitecore Solr Support package to bin folder and add [Microsoft.Practices.Unity.dll](https://www.dropbox.com/s/pu6mgbrvz52ie9z/Microsoft.Practices.Unity.dll?dl=0)

Solr Support package for 8.1 update-3 can be downloaded by [this link](https://dev.sitecore.net/~/media/7CE11E1730444897A41D89D2333019E6.ashx) 

**Step 7:** Edit the *Global.asax* file as follows:

{% highlight html %}
<%@Application Language='C#' Inherits="Sitecore.ContentSearch.SolrProvider.UnityIntegration.UnityApplication" %>
{% endhighlight %}

or download Global.asax with this change [here](https://www.dropbox.com/s/32z16hkwiwm280h/Global.asax?dl=0)

## Verify that it works
Go to Sitecore Control Panel, Indexing Manager and rebuild any index.



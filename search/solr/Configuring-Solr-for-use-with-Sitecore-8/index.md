---
layout: default
title: Configuring Solr for use with Sitecore 8
category: search
---

> This is a work in progress!

SOLR to enable only analytics index (for dummies :))

1. Install Solr via Bitnami as described  [here]({{ site.baseurl }}/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/)

2. Download [this zip]({{ site.baseurl}}/search/solr/Configuring-Solr-for-use-with-Sitecore-8/sitecore_analytics_index.zip) with sample analytics index (it has no data, just configuration)

3. Unpack downloaded zip to C:\Bitnami\solr-5.0.0-0\apache-solr\solr folder:

<img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/solrfolder.png"  />

4. Go to Solr admin page by loading http://localhost:8983/solr/ (it is default port, you should use the one that you specified when installed Bitnami) or by pressing Go to application in Bitnami tool:

<img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/bitnamistart.png"  />

5. Go to Core admin, press Add core and fill *name* and *instance dir* with "sitecore_analytics_index":

<img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/addcore.png"  />

6. Download Solr Support Package from your <a href="https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/8_0.aspx" >update of Sitecore 8</a>. Unpack the package and copy all dlls from bin folder to your Sitecore bin folder.

7. If you don’t have the Microsoft.Practices.Unity.dll in your bin folder, download and install <a href="http://www.microsoft.com/en-gb/download/details.aspx?id=17866" /> and it will be in C:\Program Files (x86)\Microsoft Unity Application Block 2.1\Bin.

8. Go to App_Config/Include folder:
- Uncomment Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config
- Uncomment Sitecore.ContentSearch.Solr.Index.Analytics.config
- Comment Sitecore.ContentSearch.Lucene.Index.Analytics.config

9.    Change next settings in Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config:

    `<setting name="ContentSearch.Solr.ServiceBaseAddress" value="http://localhost:9999/solr" />` - set your port here
    `<setting name="ContentSearch.Solr.EnableHttpCache" value="false" />` - change to false

Enjoy!
---
layout: default
title: Configuring Solr for use with Sitecore 8
category: search
---

> This is a work in progress!

### How to configure SOLR to enable only analytics index 

**Step 1.** Install Solr via Bitnami as described  [here]({{ site.baseurl }}/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/)

**Step 2.** Use default SOLR configuration. For example copy an rename folder "C:\Bitnami\solr-5.0.0-0\apache-solr\solr\configsets\basic_configs" to "C:\Bitnami\solr-5.0.0-0\apache-solr\solr\configsets\sitecore_analytics_index".

<img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/solrfolder.png"  />

**Step 3.** Do steps, described in workaround of article [https://kb.sitecore.net/articles/227897](https://kb.sitecore.net/articles/227897) for "schema.xml" in newly created folder.
    **Note:** for SOLR 5.X "pint" fildType definition should look like following one:
`<fieldType name="pint" class="solr.**Trie**IntField"/>`

**Step 4.** Fix following lines in the file "schema.xml" (that were added to "schema.xml" by schema generator):

     <dynamicField name="*_t_ar" type="text_ar" indexed="true" stored="true" /> 
     <dynamicField name="*_t_bg" type="text_bg" indexed="true" stored="true" />
     <dynamicField name="*_t_ca" type="text_ca" indexed="true" stored="true" /> 
     <dynamicField name="*_t_cz" type="text_cz" indexed="true" stored="true" /> 
     <dynamicField name="*_t_da" type="text_da" indexed="true" stored="true" /> 
     <dynamicField name="*_t_de" type="text_de" indexed="true" stored="true" /> 
     <dynamicField name="*_t_el" type="text_el" indexed="true" stored="true" /> 
     <dynamicField name="*_t_es" type="text_es" indexed="true" stored="true" /> 
     <dynamicField name="*_t_eu" type="text_eu" indexed="true" stored="true" /> 
     <dynamicField name="*_t_fa" type="text_fa" indexed="true" stored="true" /> 
     <dynamicField name="*_t_fi" type="text_fi" indexed="true" stored="true" /> 
     <dynamicField name="*_t_fr" type="text_fr" indexed="true" stored="true" /> 
     <dynamicField name="*_t_ga" type="text_ga" indexed="true" stored="true" /> 
     <dynamicField name="*_t_gl" type="text_gl" indexed="true" stored="true" /> 
     <dynamicField name="*_t_hi" type="text_hi" indexed="true" stored="true" /> 
     <dynamicField name="*_t_hu" type="text_hu" indexed="true" stored="true" /> 
     <dynamicField name="*_t_hy" type="text_hy" indexed="true" stored="true" /> 
     <dynamicField name="*_t_id" type="text_id" indexed="true" stored="true" /> 
     <dynamicField name="*_t_it" type="text_it" indexed="true" stored="true" /> 
     <dynamicField name="*_t_ja" type="text_ja" indexed="true" stored="true" /> 
     <dynamicField name="*_t_lv" type="text_lv" indexed="true" stored="true" /> 
     <dynamicField name="*_t_nl" type="text_nl" indexed="true" stored="true" /> 
     <dynamicField name="*_t_no" type="text_no" indexed="true" stored="true" /> 
     <dynamicField name="*_t_pt" type="text_pt" indexed="true" stored="true" /> 
     <dynamicField name="*_t_ro" type="text_ro" indexed="true" stored="true" /> 
     <dynamicField name="*_t_ru" type="text_ru" indexed="true" stored="true" /> 
     <dynamicField name="*_t_sv" type="text_sv" indexed="true" stored="true" /> 
     <dynamicField name="*_t_th" type="text_th" indexed="true" stored="true" /> 
     <dynamicField name="*_t_tr" type="text_tr" indexed="true" stored="true" /> 

so they look like following ones afterwards:

`<dynamicField name="*_t_ar" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_bg" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_ca" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_cz" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_da" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_de" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_el" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_es" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_eu" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_fa" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_fi" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_fr" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_ga" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_gl" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_hi" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_hu" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_hy" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_id" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_it" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_ja" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_lv" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_nl" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_no" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_pt" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_ro" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_ru" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_sv" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_th" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_t_tr" type="text_general" indexed="true" stored="true" />`

so, property "type" should be replaced in all those lines to "text_general".
**Note:** This is just for testing purposes, for real project definitions of appropriate language-specific field types (for example "text_de") have to be added according to SOLR documentation.

**Step 5.** Go to Solr admin page by loading http://localhost:8983/solr/ (it is default port, you should use the one that you specified when installed Bitnami) or by pressing Go to application in Bitnami tool:

<img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/bitnamistart.png"  />

**Step 6.** Go to Core admin, press Add core and fill **name** and **instance dir** with "sitecore_analytics_index":

<img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/addcore.png"  />

**Step 7.** Download Solr Support Package from your <a href="https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/8_0.aspx" >update of Sitecore 8</a>. Unpack the package and copy all dlls from bin folder to your Sitecore bin folder.

**Step 8.** If you don’t have the Microsoft.Practices.Unity.dll in your bin folder, download and install <a href="http://www.microsoft.com/en-gb/download/details.aspx?id=17866">Unity</a> and the needed dll will be in C:\Program Files (x86)\Microsoft Unity Application Block 2.1\Bin.

**Step 9.** Go to App_Config/Include folder:

- Uncomment Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config
- Uncomment Sitecore.ContentSearch.Solr.Index.Analytics.config
- Comment Sitecore.ContentSearch.Lucene.Index.Analytics.config

**Step 10.** Change next settings in Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config:

`<setting name="ContentSearch.Solr.ServiceBaseAddress" value="http://localhost:9999/solr" />` - set your port here

`<setting name="ContentSearch.Solr.EnableHttpCache" value="false" />` - change to false

**Step 11.** Do Step 11 from following [article](http://www.dansolovay.com/2013/05/setting-up-solr-with-sitecore-7.html). - "It is also necessary to add Castle.Core and Castle.Windsor. For example version 3.1.0 for each. Getting these is tricky. You can create a solution and use NuGet, or you can pull them directly from the Nuget site, using https://www.nuget.org/api/v2/package/castle.windsor/3.1.0and https://www.nuget.org/api/v2/package/castle.core/3.1.0 Hitting these URLs on Chrome automatically downloads a .nupkg object, which you can rename to a zip archive. Both archives contain a "lib\net40-client" path. Copy Castle.Windsor.dll and Castle.Core.dll from lib\net40-client of each package to the website bin directory."

**Step 12.** Do Step 12 from the same article (as in previous step). - "Finally, wire in the Inversion of Control logic by editing the Global.asax "Application" directive to read:
`<%@Application Language='C#' Inherits="Sitecore.ContentSearch.SolrProvider.CastleWindsorIntegration.WindsorApplication" %>`" 

**Step 13.** If you get an `index has no configuration` exception after starting the site, check your config patch files for Lucene indexes that are missing the `<configuration />` element.  
When you enable SOLR it becomes the default provider and that causes this exception on existing Lucene indexes that don't have the provider explicitely configured.   

### How to configure SOLR to enable other indexes

You can configure other indexes to work with SOLR. Basically you need to repeat the same steps as for analytics index but give the index correct name. So "sitecore_master_index" or "sitecore_web_index" or "sitecore_core_index" instead of "sitecore_analytics_index".
In case you have already done all the steps for analytics index (described) above, off course there is no need in repeating the steps #1,7,8,10,11,12. And on Step 9 you should disable and enable appropriate config file.  

Enjoy!

**P.S.** To check if anything is getting into your index, make some completed visits to the website (followed by session end) and run next query in the browser:

`http://localhost:8983/solr/sitecore_analytics_index/select?q=*&rows=1000

For other indexes, for example "sitecore_master_index", just rebuild index (using standard application in Control Panel -> Indexing Manager) and request similar URL: `http://localhost:8983/solr/sitecore_master_index/select?q=*&rows=1000

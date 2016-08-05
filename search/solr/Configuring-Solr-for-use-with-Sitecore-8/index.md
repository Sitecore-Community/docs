---
layout: default
title: Configuring Solr for use with Sitecore 8
category: search
---

> This is a work in progress!

The purpose of this document is to illustrate the steps needed to get SOLR configured properly for use with a Sitecore 8 instance.

**Step 1:** Install SOLR via Bitnami as described  [here]({{ site.baseurl }}/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/).

**Step 2:** To save time, create a custom SOLR configset by copying, pasting and renaming the *basic_configs* folder (found, for instance, in C:\Bitnami\solr-5.2.1-0\apache-solr\solr\configsets) to create a new one named *sitecore_configs* like this:

  <img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/configsets.png" style="margin:5px 15px" />

**Step 3:** Perform the steps described in this [KB article](https://kb.sitecore.net/articles/227897) for "schema.xml" in *sitecore_configs* folder. 
**NOTE:** For SOLR 5.x "pint" fieldType definition should look like this: ```<fieldType name="pint" class="solr.TrieIntField"/>``` 
**NOTE:** For some newer Sitecore versions dynamicField "pint" is already changed to "tint", check the generated schema for ```<dynamicField name="*_pi" type="tint" indexed="true" stored="true" />```

**Step 4:** Copy the *sitecore_configs* (C:\Bitnami\solr-5.2.1-0\apache-solr\solr\configsets\sitecore_configs) folder and paste it in C:\Bitnami\solr-5.2.1-0\apache-solr\solr. Rename it to the index you are setting up, which, for this exercise, use *sitecore_analytics_index*.

  <img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/solrfolder.png" style="margin:5px 15px" />

**Step 5:** Pass the *schema.xml* file from C:\Bitnami\solr-5.2.1-0\apache-solr\solr\sitecore_analytics_index\conf to the Sitecore SOLR Schema Generator (Control Panel > Indexing > Generate the SOLR Schema.xml file). **NOTE:** You should be able to use the same file for both source and target but it for some reason you have errors then copy schema.xml to schema-orig.xml and use that as your source).

---

### Optional Development Step

Fix following lines in the file "schema.xml" (that were added to "schema.xml" by schema generator):

{% highlight xml %}
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
{% endhighlight %}

When done they should look like these:

{% highlight xml %}
<dynamicField name="*_t_ar" type="text_general" indexed="true" stored="true" />
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
<dynamicField name="*_t_tr" type="text_general" indexed="true" stored="true" />
{% endhighlight %}

In summary, replace all *type* properties so they say *text_general*.

**NOTE:** This is just for testing purposes, for real project definitions of appropriate language-specific field types (for example "text_de") have to be added according to SOLR documentation.

---

**Step 6:** Navigate to the [SOLR admin page](http://localhost:8983/solr/) or by pressing Go to application in Bitnami tool:

  <img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/bitnamistart.png" style="margin:5px 15px" />

**Step 7:** Go to Core admin, press Add core and fill **name** and **instance dir** with the name of the index being added (from Step 4 above), in this example use *sitecore_analytics_index*.

  <img src="/docs/images/search/solr/Configuring-Solr-for-use-with-Sitecore-8/addcore.png" style="margin:5px 15px" />

**Step 8:** Download SOLR Support Package from your <a href="https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/8_0.aspx" >update of Sitecore 8</a>. Unpack the package and copy all dlls from bin folder to your Sitecore bin folder.

**Step 9:** If you don’t have the Microsoft.Practices.Unity.dll in your bin folder, download and install <a href="http://www.microsoft.com/en-gb/download/details.aspx?id=17866">Unity</a> and the needed dll will be in C:\Program Files (x86)\Microsoft Unity Application Block 2.1\Bin.

**Step 10:** In the App_Config/Include folder ensure that the following files have been disabled or enabled depending on their purpose.

 * **Disable:**
   * Sitecore.ContentSearch.Lucene.DefaultIndexConfiguration.config
   * Sitecore.ContentSearch.Lucene.Index.Analytics.config
   * Sitecore.ContentSearch.Lucene.Index.Core.config
   * Sitecore.ContentSearch.Lucene.Index.Master.config
   * Sitecore.ContentSearch.Lucene.Index.Web.config
   * Sitecore.ContentSearch.Lucene.Indexes.Sharded.Core.config
   * Sitecore.ContentSearch.Lucene.Indexes.Sharded.Master.config
   * Sitecore.ContentSearch.Lucene.Indexes.Sharded.Web.config

 * **Enable:**
   * Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config
   * Sitecore.ContentSearch.Solr.Index.Analytics.config
   * Sitecore.ContentSearch.Solr.Index.Core.config
   * Sitecore.ContentSearch.Solr.Index.Master.config
   * Sitecore.ContentSearch.Solr.Index.Web.config

Generally speaking, any config file with the *Lucene* text in it should be disabled and any config file with *Solr* text in it should be enabled.

**Step 11:** Change next settings in Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config:

  * ```<setting name="ContentSearch.Solr.ServiceBaseAddress" value="http://localhost:9999/solr" />``` - set port accordingly
  * ```<setting name="ContentSearch.Solr.EnableHttpCache" value="false" />``` - set to false

**Step 12:** Ensure that you have [Castle.Core](https://www.nuget.org/packages/Castle.Core/) and [Castle.windsor](https://www.nuget.org/packages/Castle.Windsor/) added to your solution. Two ways to do this include Nuget (probably the simplest) or dropping the assemblies in the bin folder directly.

**Step 13:** Now you need to convert the application to use ```Castle.WindsorApplication``` in the Global.asax. Do this by editing the *Global.asax* file as follows:

{% highlight html %}
<%@ Application Language='C#' Inherits="Sitecore.ContentSearch.SolrProvider.CastleWindsorIntegration.WindsorApplication" %>
{% endhighlight %}

**NOTE:** If you get an <i>index has no configuration</i> exception after starting the site, check your config patch files for Lucene indexes that are missing the ```<configuration />``` element. When you enable SOLR it becomes the default provider and that causes this exception on existing Lucene indexes that don't have the provider explicitly configured.

Another option is to use Unity integration:

<%@Application Language='C#' Inherits="Sitecore.ContentSearch.SolrProvider.UnityIntegration.UnityApplication" %>

Check it out, if Castle.Windsor doesn't work for you for some reasons. 

## Verify it works

To check if anything is getting into your index, make some completed visits to the website (followed by session end) and run this query in the browser:

 * ```http://localhost:8983/solr/sitecore_analytics_index/select?q=*&rows=1000```

For other indexes, for example "sitecore_master_index", just rebuild index (using standard application in Control Panel -> Indexing Manager) and request similar url:

 * ```http://localhost:8983/solr/sitecore_master_index/select?q=*&rows=1000```

## Rinse and repeat

 Use the process detailed in Steps 4-7 to create new cores for all the remaining indexes you would like to move to SOLR.

---

## References

 * Huge props to [Dan Solovay](https://twitter.com/DanSolovay) for his [guide on setting up Solr](http://www.dansolovay.com/2013/05/setting-up-solr-with-sitecore-7.html) for use with Sitecore 7 and higher.
 * [Sitecore Solr Compatibility KB Article](https://kb.sitecore.net/articles/227897)
 * [Bitnami Solr Stack](https://bitnami.com/stack/solr)

---
layout: default
title: Install and configure SolrCloud
category: search
---

> This is a work in progress!

To start with SolrCloud one needs to download Solr version that supports SolrCloud. The latest releases of Solr can be downloaded from the [official Solr resource](http://lucene.apache.org/solr/). It is likely that one will need an older release of Solr rather than the latest. Here's where you can get [older releases of Solr](http://lucene.apache.org/solr/downloads.html).

> This guide is written using Solr 5.2.1 and Windows OS. For Linux based systems reverse slashes and use Linux commands for file management.

Follow the usual drill to install Solr which is unpack the archive of Solr distributive into a local drive. For the sake of simplisity `E:\app\solr` will be used as a `<SolrRoot>` folder in this article.

# Prepare Solr configuration for Sitecore indexes
Every Solr collection is tied to a certain Solr configuration that is uploaded into ZooKeeper that orchestrates file management for SolrCloud instances. Solr distributive comes with ZooKeeper instance baked into it. When running SolrCloud instance locally, there is no need to configure ZooKeeper itself.
> Standalone configuration of ZooKeeper (Zk) is described later in this article.
  
Before collections for Sitecore indexes could be created, one needs to upload Solr configuration with Solr index schema into ZooKeeper. The default Sitecore index schema could be generated using the UI interface in Sitecore application. Refer to [Configuring Solr for use with Sitecore 8](../search/solr/Configuring-Solr-for-use-with-Sitecore-8/index.md) for more details on that.  
Here are basic steps to prepare Solr configuration for Sitecore indexes.  

1. Duplicate `<SolrRoot>\server\solr\configsets\basic_configs` folder and give it a configuration name (e.g. `sitecore_configs`)  
> Next two steps are optional and should be used if one needs to configure language specific stopwords so that the content parsed properly for those langauges. These steps use `sitecore_core_index` as an example since `Core` database by default uses several different languages. By default Sitecore uses `text_general` field type for all language specific fields in `schema.xml` file which uses common `stopwords.txt` file located in the `conf` folder of the Solr configuration directory (e.g. `sitecore_configs`).

2. *[Optional]* Add the following files to `sitecore_configs\conf\lang` folder
    - `stoptags_ja.txt`
    - `stopwords_da.txt`
    - `stopwords_de.txt`
    - `stopwords_ja.txt`
    - `userdict_ja.txt`
    - `stopwords_en.txt` this file should already be in there.
> These files can be copied from `<SolrRoot>\server\solr\configsets\data_driven_schema_configs\conf\lang` folder.  
All these files are used by Solr to parse language specific content properly. Sitecore `Core` database by default uses `DE`, `DA`, `JA` and `EN` languages which can be configured to use language specific stopwords.  
For solutions that have other languages defined, corresponding files must be added to the `lang` folder and language field types configured in `schema.xml` file.  

3. *[Optional]* Configure language specific dynamic fields and field types. Add field types for `DA`, `DE` and `JA` languages to the `schema.xml' file generated thru Sitecore app.  
    - add field types for each language. Here is the example for `DA` field type definition:
    ```XML
    <!-- Danish -->
    <fieldType name="text_da" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_da.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Danish"/>       
      </analyzer>
    </fieldType>
    ```
    Repeat this step for every language that needs to have its own type and refernece proper `stopwords` file.
    > Field type definitions could be copied from `<SolrRoot>\server\solr\configsets\data_driven_schema_configs\conf\managed-schema` file.
     
    - ensure language specific dynamic fields use proper field types. For example:
    ```XML
    <dynamicField name="*_t_en" type="text_general" indexed="true" stored="true" />
    <dynamicField name="*_t_da" type="text_da" indexed="true" stored="true" />
    <dynamicField name="*_t_de" type="text_de" indexed="true" stored="true" />
    <dynamicField name="*_t_ja" type="text_ja" indexed="true" stored="true" />
    ```
    
4. Replace `schema.xml` file in `sitecore_configs\conf` folder with the one generated thru Sitecore or modified on steps 2 and 3.

# Run SolrCloud instance locally
The easiest way to stand up SolrCloud instance is to run it locally. To do that open any command-line interface, navigate to Solr root folder and run the following command:  
```
bin\solr -e cloud
```  
This will launch an interactive command-line based process to get SolrCloud configured. Simply hitting the `<Enter>` thru the process steps will stand up 2 SolrCloud nodes on different ports running on the local machine. There will be a default collection called `gettingstarted` that is split into 2 shards with replication factor set to 2.  
> Local instance of SolrCloud by default gets placed into `<SolrRoot>\example\cloud` folder. Examine that forlder to see how SolrCloud distributes the collection(s) among its nodes. 

## Upload index configuration into ZooKeeper
Solr 5.2.1 provides ZooKeeper Command-line interface (a.k.a ZkCli) to work with ZooKeeper file system. The CLI is located at `<SolrRoot>\server\scripts\cloud-scripts` folder.  
Run the following command to upload Solr configuration into ZooKeeper:
```
zkcli -zkhost localhost:9973 -cmd upconfig -confdir E:\app\solr-5.2.1\server\solr\configsets\sitecore_configs\conf -confname scbasic
```   
Where
- `localhost:9973` is the server and port Zk runs on which is local in this case.
- `-cmd upconfig` is command to upload configuration into Zk.
> Run `zkcli --help` to see all Zk commands  

- `-confdir <dirPath>` should point to the folder that holds `conf` directory with Solr configuration (e.g. `<SolrRoot>\server\solr\configsets\sitecore_configs\conf`).
- `-confname <configurationName>` specifies configuration that will be.   
Once configuration is uploaded navigate to `http://localhost:<port>/solr/#/~cloud?view=tree` URL and expand `configs` node to see available configurations.

## Create collection
Each index collection must be linked to either existing configuration or should provide a path to configuration folder that will be uploaded into Zk and linked to the collection. Here are a few examples how one can create a collection:  

1. Run this command to create a collection based on existing configuration  
  ```
  bin\solr create -c scindex -n scbasic -shards 2 -replicationFactor 2 -p 8973
  ```
  <a name="create-collection-params"></a>Where
  - `create` is command that instructs Solr to create a collection
  - `-c` is collection name parameter
  - `-n` is configuration name parameter. The `scbasic` configuration was used in this example created in [previous paragraph](#upload-index-configuration-into-zookeeper)
  - `-shards` is the number of shards for the collection
  - `-replicationFactor` is the number of replicas for each shard of the collection
  - `-p` is the port that SolrCloud instance runs on

2. Run this command to upload configuration into Zk and create a collection based on it  
  ```
  bin\solr create -c scitems2 -d E:\app\solr-5.2.1\server\solr\configsets\scbasic_configs -n scitems2 -shards 1 -replicationFactor 1 -p 8973
  ```
  Where
  - `-d` is path to the folder that holds configuration directory
  - rest of the parameters are the same as in [step 1](#create-collection-params)  

> Note, when uploading index configuration into Zk using ZkCli, the path in `-confdir` parameter must point to the root of the folder that holds `solrconfig.xml` file (i.e. `sitecore_configs\conf`).  
When uploading index configuration using `bin\solr create -d <path>` command, the path should either point to the root of directory that contains `solrconfig.xml` file (e.g. `sitecore_configs\conf`) or to its parent container that contans `conf` directory which holds `solrconfig.xml` file (i.e. `sitecore_configs`).

# Run disdributed SolrCloud instance
Distributed SolrCloud environment consists of ZooKeeper (Zk) ensemble and SolrCloud cluster. Zk is used to orchestrate file management among all SolrCloud nodes. 
SolrCloud nodes will hold all collections and manage indexing/searching operations. Both Zk and SolrCloud need to have redundancy to provide higher fault tolerance.
> It's not uncommon to share machines to run SolrCloud nodes and Zk instances side by side.  
This section describes how to configure Zk ensemble and stand up a SolrCloud cluster.  

## Configuring ZooKeeper ensemble
Download ZooKeeper from [Zk distributive](http://archive.apache.org/dist/ZooKeeper/) resource.
> ZooKeeper 3.4.6 was used for this guide.

Unpack Zk distributive into a folder. For the sake of simplisity `E:\app\zk-3.4.6` will be used as a `<ZkRoot>` folder in this article.
Follow these steps to stand up Zk ensemble:  
1. Create `zkData` folder that Zk will use to run its operations (e.g. `e:\app\zkData`).
> If Zk instances share machines with SolrCloud nodes, it's highly recommended to place Zk and SolrCloud data folders on separate disks for the best performance.

2. Rename `zoo_sample.cfg` to `zoo.cfg` then modify these configuration settings in the file:
   - `dataDir=e:/app/zkData`
   - Add `server` entries that list all servers that run Zk instances. For example:
     + `server1=<server1.IP>:2888:3888`
     + `server2=<server2.IP>:2888:3888`
     + `server3=<server3.IP>:2888:3888`
   
   Rest of settings feel free to keep at default values or tweak as needed.
   
3. Create `myid` file (no extension) in the `zkData` folder (i.e. `e:\app\zkData`) and set server id number in that file.
For example, on `server1` the file should have `1`. On `server2` it should have `2` and so on.

4. *[Optional]* Use [NSSM](https://nssm.cc/) tool to configure Zk as a Windows service. Here are the steps to create ZooKeeper as a Win service: 
   - Download NSSM tool
   - Run `nssm install` in Win `CMD`
   - Configure service to use `<ZkRoot>\bin\zkServer.cmd`
   
5. Run the following command to start Zk instance manually
   ```
   <ZkRoot>\bin\zkServer.cmd
   ```
   > On Linux based systems it will be `bin\zkServer.sh`

6. Repeat steps 1-5 on all machines that run Zk instances.

## Configuring SolrCloud with ZooKeeper ensemble
Once Zk ensemble is configured and running, one can add SolrCloud nodes to it. To start SolrCloud instance and link it to existing Zk ensemble, execute the following command:
```
bin\solr -c -f -z "<zkHost1>:<zkPort>,<zkHost2>:<zkPort>,<zkHost3>:<zkPort>" -m 1g -d <solrNodeHome> -p 8983 
```
Where
- `-c` starts Solr in SolrCloud mode
- `-f` runs SolrCloud process in foreground. By default it starts in background
- `-z "<zkHost1>:<zkPort>,<zkHost2>:<zkPort>,<zkHost3>:<zkPort>"` specifies ZooKeeper connection string
  + `<zkHost>` is the IP address of each Zk instance
  + `<zkPort>` is the port number for each Zk instance
- `-m` memory cap for the SolrCloud instance. For example:
  + `-m 500m` allocates 500MB
  + `-m 1g` allocates 1GB
- `-p` port number for SolrCloud instance

Run the command on every server that hosts SolrCloud node to join the cluster.  

Once everything up and running one can start [uploading configuration into Zk](#upload-index-configuration-into-zookeeper) and [creating Solr collections](#create-collection).
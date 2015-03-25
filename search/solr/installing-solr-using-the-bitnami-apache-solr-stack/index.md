---
layout: default
title: Installing Solr using the Bitnami Apache Solr Stack
category: search
---

> This is a work in progress!

One of the simplest methods for getting Solr installed, especially in a development environment, is to use the <a href="https://bitnami.com/stack/solr" target="_blank">Bitnami Apache Solr Stack</a>. This installer handles installing <a href="https://www.apache.org/" target="_blank">Apache</a>, <a href="http://eclipse.org/jetty/" target="_blank">Jetty</a> and <a href="http://lucene.apache.org/solr/" target="_blank">Solr</a> and configuring it properly. No prior knowledge needed.

The installation process is not really all that different then a typical Windows installation, there are just a few things to be aware of as you perform this installation. To start, double-click on the installer (bitnami-solr-5.0.0-0-windows-installer.exe for the purposes of this article). The first screen you are greeted with looks like this:

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-1.png" alt="Bitnami Installation Step 1" title="Bitnami Installation Step 1" />

From here, click Next. The default installation path should be fine for most, change it if you must but this article will assume a default path of C:\Bitnami\solr-5.0.0-0:

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-2.png" alt="Bitnami Installation Step 2" title="Bitnami Installation Step 2" />

Clicking Next brings you to a screen allowing you to define the port that Apache should run on. On this screen, if you are setting up Solr for development use and installing locally it is important that you change the default port to something other then 80 (in use by IIS), for this article we used port 8080:

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-3.png" alt="Bitnami Installation Step 3" title="Bitnami Installation Step 3" />

Click Next, a screen shows offering up details about Bitnami Cloud Hosting. Feel free to leave that checked but this article will assume it was unchecked:

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-4.png" alt="Bitnami Installation Step 4" title="Bitnami Installation Step 4" />

After clicking Next, Windows Firewall will alert you that it has blocked some features of this installation. Ensure that the check boxes for <em>Domain networks, such as a workplace network</em> and <em>Private networks, such as my home or work network</em> are checked. Complete this step by clicking the <strong>Allow access</strong> button.

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-5.png" alt="Bitnami Installation Step 5" title="Bitnami Installation Step 5" />

Once the Bitnami installation has completed keep the <em>Launch Bitnami Apache Solr Stacak now?</em> check box checked and click <strong>Finish</strong>.

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-6.png" alt="Bitnami Installation Step 6" title="Bitnami Installation Step 6" />

Your browser of choice should open with a page that looks like this:

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-7.png" alt="Bitnami Installation Step 7" title="Bitnami Installation Step 7" />

Clicking on on the <em>Access Bitnami Apache Solr Stack</em> link which will launch the Solr dashboard and should look similar to this:

<img src="/docs/images/search/solr/installing-solr-using-the-bitnami-apache-solr-stack/bitnami-8.png" alt="Bitnami Installation Step 8" title="Bitnami Installation Step 8" />

That is it for this article, you now have Solr installed and waiting to be configured for use with Sitecore.

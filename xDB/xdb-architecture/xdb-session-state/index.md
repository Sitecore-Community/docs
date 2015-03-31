---
layout: default
title: Session State and the xDB
category: xdb
---

<div class="alert alert-warning" role="alert">This article is a work in progress and might be <strong>completely wrong</strong>! Proceed at your own risk. :)</div>

This article describes how session state fits into the xDB, and explains when and why you have to use `OutProc`	session state management.

## Where does session state fit in with the xDB?

As a visitor browses around your site, information about that visitor and their interaction is stored in session. When the session ends, this information is flushed to the xDB - but for the duration of an interaction, session is solely responsible for storing valuable information about a visitor's actions on your website. This reduces the number of calls to the collection database, but it means that session management should be as robust as possible.

There is nothing proprietary about session management in Sitecore - it is all built on standard ASP.NET session state.

### Shared vs Private session state

The xDB stores [two kinds of session information - **shared** and **private**](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/session%20state). You can think of shared session state as the **contact** store - it has information about the contact, devices used, and engagement plan states. Private session state contains information about interactions - such as goals triggered. When you install Sitecore on a single machine, both types of session data are stored `InProc`.

### Why do we need two kinds of session state?

There is a small chance that a visitor to your site will have **two or more concurrent sessions running**. Consider the following scenario:

* Bob visits a holiday site. He authenticates with Twitter and becomes a contact in the xDB. He triggers a number of goals and is moved from 'New Visitor' engagement state to 'Looking for Holidays'.
* Bob finishes work, leaves his computer, and immediately picks up his phone to continue the search on the commute home.
* He logs onto the same site, and contiues browsing. Bob now has **two sessions running at the same time**.
* We now have a potential problem. The information from session A is not yet in the xDB - how do we make sure that any changes to Bob's **contact record** or **engagement plan state** are in sync across sessions? This is where **shared session state data** comes in. If two concurrent sessions are running (and the contact is known to the xDB), both of those sessions look at shared session state for data that must be in sync across sessions.

If you have a single CD, all session state management can be done `InProc`. However, as soon as you begin to scale by adding more CDs to your cluster, you have to switch to `OutProc` session management.

## `InProc` vs `OutProc` session state management

`InProc` and `OutProc` session management is not specific to Sitecore. `InProc` is short for 'In Process', and means that all session data (both private and shared) is managed in memory. `OutProc`, conversely, means that session data is stored somewhere else - it might be written to disk as the user browses around your site. In Sitecore's case, there are two custom `OutProc` session providers; one for MongoDB and one for SQL. A default installation of Sitecore uses `InProc` session management for both shared and private session data. 

### Why do I have to use `OutProc` session state if I have multiple CDs in a cluster?

As soon as you scale to multiple CDs within a cluster, you must use `OutProc` session management for both private and shared session data. This is because **shared** session data needs to be available to all sessions for a single contact. This is done by storing shared session data in an `OutProc` session state database.

### Can I use `InProc` with sticky sessions if I have multiple CDs in a cluster?

This does not solve the problem of concurrent sessions. If device A (desktop) still has an open session when device B (mobile) accesses the site, there is no way for device B to know about changes to engagement plan state or other contact information unless shared session state data is available `OutProc`.

### Can I mix `InProc` (private) and `OutProc` (shared)?

*Theoretically* possible, but not recommended. You are getting the worst of both worlds in terms of reduced speed (`OutProc`) and reduced reliability (`InProc`).

### Which session state provider should I use?

That's up to you. There is no officially supported data that suggests one is faster than the other, although you should always perform your own tests. MongoDB is simpler to spin up, but if you are not comfortable supporting MongoDB, you can use the SQL provider. Configuration steps are available on the documentation site:

* [Walkthrough: Configuring a private session state database using the MongoDB provider](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/walkthrough%20configuring%20a%20private%20session%20state%20database%20using%20the%20mongodb%20provider)
* [Walkthrough: Configuring a private session state database using the SQL Server provider](https://doc.sitecore.net/Products/Sitecore%20Experience%20Platform/xDB%20configuration/Walkthrough%20Configuring%20a%20private%20session%20state%20database%20using%20the%20SQL%20Server%20provider)
* [Walkthrough: Configuring a shared session state database using the MongoDB provider](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/walkthrough%20configuring%20a%20shared%20session%20state%20database%20using%20the%20mongodb%20provider)
* [Walkthrough: Configuring a shared session state database using the SQL Server provider](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/walkthrough%20configure%20a%20shared%20session%20state%20database%20using%20the%20sql%20server%20provider)

### What about if I have *multiple* clusters of CDs?

In a geographically distributed setup, you have a cluster of CDs and session state server *per cluster*. The session state server needs to be as close to the CDs as possible to ensure the best possible performance. If for any reason a contact starts a session on cluster A, and a second, concurrent session on a different device in cluster B, they are *redirected to their original cluster* by the CD environment. This is possible because the first session causes a lock to be placed on the contact inside the **collection database**, which ties them to a particular cluster.

### What if session A is the visitor's *first* visit, and they open a concurrent session on another device?

In order for a lock to be placed 

*Coming soon*.

## Sample Scenarios feat. Bob

### Scenario 1: Single CD and `InProc`

In this example, session is managed in memory by a single CD:

![Session and a single CD]({{ site.baseurl }}/images/sesssion/local-env.PNG)

1. Bob browses to samplesitecore.com - it's a tiny site, so it can get away with having a single CD environment. Bob signs in with Twitter, thereby becoming a contact in the xDB.
2. He browses around, triggering goals and amassing session data about his interaction - the single CD uses `InProc` session management, so this is all done in memory.
3. When his session ends, the data is flushed to the xDB, where it will be processed and aggregated for reporting.

### Scenario 2: Multiple CDs, Single Cluster, and `OutProc`

In this example, there are *multiple* CDs in a single cluster.

![Session and a single CD]({{ site.baseurl }}/images/sesssion/single-cluster-session.PNG)

1. Bob browses to samplesitecore.com again - it has grown since his last visit, and there are now three CD instances
2. His request is routed to the least busy server via a non-sticky load balancer - because it is non-sticky, he is not attached to this server for the duration of his visit
3. As he browses, Bob bounces between CD instances - trigger goals, moving through engagement plans, and generally getting into internet trouble
4. No matter which CD his request is routed to, his session information is written to a shared **session database** that they all have access to
5. When Bob's session ends, this data is written to the xDB and eventually disappears from the session database

### Scenario 3: Two devices, two concurrent sessions

In this example, there is a sticky load balancer within a cluster. This scenario **will not work** with the xDB in a real production environment.

![Session and a single CD]({{ site.baseurl }}/images/sesssion/sticky-sessions-are-no.PNG)

1. (A) Bob browses to your site on his computer at work - he is looking for information about the LARP scene in Copenhagen, and authenticates himself with Twitter.
2. (A) Your environment is set up to use three CDs and a **sticky load balancer** within the cluster - once Bob's request is directed to a CD, it sticks to it until his session ends.
3. (A) All *seems* to be well - if Bob's session ends, he it should just be written to the xDB from session.

But Bob is an internet addict. Work finishes, and Bob immediately jumps on his phone to continue his search.

1. (B) Bob logs in on his phone, **whilst his first session is still going**, and information about that visit is not yet in the xDB.
2. (B) This session sticks to a CD as well - it may or may not be the same CD, there is no way of knowing.
3. (B) This is where things start to go horribly wrong..
  * When a request comes in to a cluster of CDs, a lock is placed on your contact - 'you belong to cluster A for the duration of this session'
  * But Bob has two sessions going at the same time, and if the cluster was using `OutProc` session state management, those two sessions would know about each other - they would share things like contact and engagement plan information.
  * You now have two conflicting sessions - Bob may have changed his contact data by using a form, or moved into different engagement plan states in either of his two sessions.
  * Which session wins? There is now way for the xDB to work that out, so your data is likely to be incomplete and/or inaccurate.

## Other advantages of `OutProc` session state management

`OutProc` session state is never going to be as fast as `InProc` session state. However, there are a number of advantages that start to pay off as you scale beyond 10 CD instances.

* You trade some speed for **increased reliability**
* You can share information across concurrent sessions on **multiple devices**
* No need for sticky sessions (sticky sessions may result in uneven splits of traffic across load-balanced CDs)

### Session data reliability and why it matters

In Sitecore's xDB, information about a visitor is built up during their session and flushed to MongoDB on session end. Imagine that you are using `InProc` session management - everything is stored in memory. If anything goes awry in your content delivery environment (for example, one out of three load-balanced instances goes down), visitors are at risk of losing their entire session. By contrast, if you are using OutProc session management, their session is maintained in a database - the information about that session is not lost.

Why does this matter? For marketers, Sitecore 8 is all about getting a full picture of the individual. Interfaces like the Experience Profile lets you use Sitecore like a CRM - it collects all manner of information about what a visitor has done over time, what part of the sales process they are in, and how they are interacting with your brand. This kind of detailed information might not matter as much to you if your orders rarely exceed £10 - but if you are a vendor of luxury holiday packages, it probably does. In this scenario, individual session data is likely to be worth a lot more; if even a single session is lost, a contact may not be seen as moving through the sales pipeline even though they are.

## What about content management (CM) environments?

You have to use `InProc` for CM environments - for both private and shared session state. There is no support for `OutProc`.
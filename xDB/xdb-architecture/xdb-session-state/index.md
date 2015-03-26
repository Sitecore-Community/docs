---
layout: default
title: Session State and the xDB
category: xdb
---

<div class="alert alert-warning" role="alert">This article is a work in progress and might be <strong>completely wrong</strong>! Proceed at your own risk. :)</div>

## Where does session state fit in with the xDB?

As a visitor browses around your site, information about that visitor and their interaction is stored in session. On session end, this information is flushed to the xDB - but for the duration of an interaction, session is solely responsible for storing valuable information about a visitor's actions on your website. This reduces the number of calls to the collection database, but it means that session management should be as robust as possible.

There is nothing proprietary about session management in Sitecore - it is all built on standard ASP.NET session state. If you look at the vanilla `Sitecore.Analytics.Tracking.config`, you will see that `sharedSessionState` uses the standard `System.Web.SessionState.InProcSessionStateStore`. Sitecore's two `OutProc` providers (MongoDB and SQL) are custom, as they need to support`Session_End`.

### Shared vs Private session state

The xDB stores [two kinds of session information - **shared** and **private**](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/session%20state). You can think of shared session state as the **contact** store - it has information about the contact, devices used, and engagement plan states. Private session state contains information about interactions - such as goals triggered. When you install Sitecore on a single machine, both types of session data are stored `InProc`.

## Scenario 1: Single CD and `InProc`

In this example, session is managed in memory by a single CD:

![Session and a single CD]({{ site.baseurl }}/images/sesssion/local-env.PNG)

1. Bob browses to awesomecore.net - it's a tiny site, so it can get away with having a single CD environment
2. He browses around, triggering goals and amassing session data about his interaction - the single CD uses `InProc` session management, so this is all done in memory
3. When his session ends, the data is flushed to the xDB, where it will be processed and aggregated for reporting


## Scenario 2: Multiple CDs, Single Cluster, and `OutProc`

In this example, there are *multiple* CDs in a single cluster.

![Session and a single CD]({{ site.baseurl }}/images/sesssion/local-env.PNG)

### Choosing `OutProc` or `InProc` session state management

In a content delivery environment, you can choose to use `InProc` or `OutProc` session state management. `InProc` is short for 'In Process', and means that any information about a visitor's session is stored in memory. This is the default configuration when you install Sitecore, and it is your *only* option for content management environments. `InProc` is always, always going to be faster than OutProc, because you are not writing anything to disk.

**OutProc**, short for 'Out of Process', is when you store session state information somewhere that *isn't* in memory. For example, you might write your session state information to a SQL database. Sitecore offers two OutProc session state providers: **MongoDB** and **SQL**.

##

#### Using `InProc` for both private and shared session state

This is the default setup, and works if you have a single CD instance. If you have more than one CD, you cannot use `InProc` - not even with sticky sessions enabled. This is because as soon as you have more than one CD, you open yourself up to the possibility of two concurrent sessions on separate CDs. In order to manage that kind of session data, all CDs need access to a single store of information about the contact, which can only be done `OutProc` using a session state database. You also run the risk of data being inaccurate, as the sessions do not know about each other and may write conflicting data back to the xDB (if the second device is able to get access at all).

#### Using `InProc` for private, `OutProc` for shared

*Theoretically* possible, not recommended. You are getting the worst of both worlds in terms of reduced speed (`OutProc`) and reduced reliability (`InProc`).

#### Using `OutProc` for private and shared

Slower, but most reliable, and the recommended option for scaled environments. No matter which CD a visitor hits within a cluster, their session data is available in the session database.

### Which session state provider should I use?

That's up to you. There is no officially supported data that suggests one is faster than the other, although you should always perform your own tests. MongoDB is simpler to spin up, but if you are not comfortable supporting MongoDB, you can use the SQL provider. Configuration steps are available on the documentation site:

* [Walkthrough: Configuring a private session state database using the MongoDB provider](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/walkthrough%20configuring%20a%20private%20session%20state%20database%20using%20the%20mongodb%20provider)
* [Walkthrough: Configuring a private session state database using the SQL Server provider](https://doc.sitecore.net/Products/Sitecore%20Experience%20Platform/xDB%20configuration/Walkthrough%20Configuring%20a%20private%20session%20state%20database%20using%20the%20SQL%20Server%20provider)
* [Walkthrough: Configuring a shared session state database using the MongoDB provider](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/walkthrough%20configuring%20a%20shared%20session%20state%20database%20using%20the%20mongodb%20provider)
* [Walkthrough: Configuring a shared session state database using the SQL Server provider](https://doc.sitecore.net/products/sitecore%20experience%20platform/xdb%20configuration/walkthrough%20configure%20a%20shared%20session%20state%20database%20using%20the%20sql%20server%20provider)

### What about content management (CM) environments

You have to use `InProc` for CM environments - for both private and shared session state. There is no support for `OutProc`.

## If OutProc is slower, why would I use it - and what does it have to do with analytics? 

There are two key advantages to full OutProc session management:

* You trade some speed for **increased reliability**
* You can share information across concurrent sessions on **multiple devices**
* No need for sticky sessions (sticky sessions may result in uneven splits of traffic across load-balanced CDs)

### Reliability

In Sitecore's xDB, information about a visitor is built up during their session and flushed to MongoDB on session end. Imagine that you are using `InProc` session management - everything is stored in memory. If anything goes awry in your content delivery environment (for example, one out of three load-balanced instances goes down), visitors are at risk of losing their entire session. By contrast, if you are using OutProc session management, their session is maintained in a database - the information about that session is not lost.

Why does this matter? For marketers, Sitecore 8 is all about getting a full picture of the individual. Interfaces like the Experience Profile lets you use Sitecore like a CRM - it collects all manner of information about what a visitor has done over time, what part of the sales process they are in, and how they are interacting with your brand. This kind of detailed information might not matter as much to you if your orders rarely exceed £10 - but if you are a vendor of luxury holiday packages, it probably does. In this scenario, individual session data is likely to be worth a lot more; if even a single session is lost, a contact may not be seen as moving through the sales pipeline even though they are.

### Sharing session data across devices

There is a small chance that a visitor will have two concurrent sessions running. Consider the following scenario (note that if Bob does not identify himself by logging in or similar, Sitecore has no way of knowing that he is the same person on both devices):

* Bob logs onto travelling website and browses around for holidays - he triggers a number of goals and is moved from 'New Visitor' engagement state to 'Looking for Holidays'.
* Bob finishes work, leaves his computer, and immediately picks up his phone to continue the search on the commute home.
* He logs onto the same site, and contiues browsing. Bob now has two sessions running at the same time.
* If shared session state is being managed **out of process**, the xDB knows that Bob already has an active session - it is able to use information about the contact and his engagement level state. If this information was not available in shared session state, Bob would be seen as being a 'New Visitor' on his mobile phone despite that not being the case.


Sharing session data across devices **in a multi-CD setup** requires `OutProc` session management. Every CD needs access to the shared session state in order to know about contact details and engagement states.

### Cluster-forwarding 

In a geographically distributed setup, you have a cluster of CDs and session state server *per cluster*. The session state server needs to be as close to the CDs as possible to ensure the best possible performance. If for any reason a contact starts a session on cluster A, and a second, concurrent session on a different device in cluster B, they are *redirected to their original cluster* by the CD environment. This is possible because the first session causes a lock to be placed on the contact, which ties them to a particular cluster. This behaviour is not possible without `OutProc` session management.

## Do I have to use OutProc session management?

No, not at all. Nothing is going to break, technically.
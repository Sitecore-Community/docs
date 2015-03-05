---
layout: default
title: How to test an Engagement Plan?
redirect_from: "/documentation/xDB/Engagement Automation/"
category: xdb
---
# How to test an Engagement Plan?

* * *

Debugging Engagement Plans can be tricky, if you do not know what exactly is happening in which period of time with contact in the Engagement Plan.

This guide should help you to find out, what’s going on and when.

_Note: this is a guide for developers, marketers probably don’t need to know all the internal details._

So, let’s imagine we have a simple engagement plan:

![Alt text]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/engPlan1.png)

## States, conditions and items configuration

1.   **Initial State**

	![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/InitialStatePageEventSubscription.png)

    Pay attention to **Page Event Subscription**. When you subscribe to exact goal in that field - in this case, Initial State subscribed for Sample Goal - it means that:

    *   when contact is in Initial State state
    *   and contact  triggers Sample Goal
    *   then and only then engagement automation processes further. In this example it will run a condition we have attached to Initial State.
    > **NB:** you won’t see the results in Marketing Control Panel immediately. A lot of work in Sitecore 8 is done in the background and inside the contact session. We’ll get to it later in chapter How it works.

    Often developers forget to set this Page Event Subscription and just wait that condition will be executed on itself. But no, it won’t.

2. **Condition**

    In this example it is a custom historical condition, but can be anything else:

    ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/Condition1.png)

3.  **Goal Triggered state**: doesn’t have any specific settings.
4.  **Home item**: nothing special, except of the link to Page1 item. 

    ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/home_item.png)
5.  **Home/Page1 item**: has Sample Goal assigned.

    ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/page1_item.png)
6.   **Additional buttons** on Sample Layout:

    * One of them identifies contact, by calling
     
	    `Tracker.Current.Session.Identify("somename")`
    
	    and sets its first name by calling
    
	    `var facet = 
	    Tracker.Current.Contact.GetFacet<Sitecore.Analytics.Model.Entities.IContactPersonalInfo>("Personal");
                    facet.FirstName = "somename";`
      
    * Second button - enrolls user in the plan's Initial State by calling

                            Tracker.Current.Contact.AutomationStates().EnrollInEngagementPlan(planID, stateId)
    * Third button - ends the session by calling
	    `Session.Abandon()`
7.  Everything is deployed, published or live mode (master database) is used.

## How it works

Have next things opened for successful debugging and understanding the dataflow:

*   Sitecore Marketing Control Panel
*   [Robomongo](http://robomongo.org/)

Steps during debugging, explained:

1.  Open the Anonymous browser session:

    ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks1.png)
2.  Identify your user. This step actually can be omitted, but it is recommended if you do not want to see only IDs in Marketing Control Panel and compare numbers and letters. After you have called Identify, you’ll have a new contact in db.Contacts in Analytics database. You can check how it looks in Robomongo by calling:

	`db.Contacts.find().skip(390)`

	Skip as many contacts as you have except the last one. 

	> **NB:** Actually, your contact is not certainly will be the last conact in the database, because of random mongo data access, but usually it is.

	This is what you should see there:

	![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks2.png)

	Note, that despite we have assigned FirstName to the contact, we don’t see it in database. This is because we assign FirstName after calling Identify. Identify calls FlushContactToXdb method that flushes the data we had by that moment. Rest of the changes will be saved in session and flushed when it ends.

	>**NB:**  never call FlushContactToXdb method yourself. It may cause instability of data.

3. Enroll contact in engagement plan. You won’t see any changes anywhere after you enrolled that contact, because this change exists only in session and is not yet flushed anywhere.

	Just to ensure, you may check db.Contacts, db.AutomationStates and db.Interactions collections in Analytics database, nothing will be changed for them.

4.   End the session.

    *   Now check your db.AutomationStates. You should see there a document like next:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks3.png)

        Note that this document has StateTransition field, where StateIdBefore is nullID, and StateIdAfter is an id of our Initial State. This document with StateTransition is created by `AutomationStateManager.SaveChanges` method, which is called by `SaveAutomationRecords` processor from `<submitContact>` pipeline. `<submitContact>` pipeline is called from `FlushContactToXdb`, that happens again on the session end.

        > **NB:**  never call AutomationStateManager.SaveChanges method yourself. It may cause instability of data.

        Now you should **wait** until this document looses its StateTransition field and becomes something like that:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks5.png)

        It means, that engagement automation has already processed StateTransition and moved contact to the Initial State. **/this needs to be checked, as I’m not sure if this is done by automation worker or aggregation part/**

    *   Now check Marketing Control Panel, plan’s Initial State. There should be our KateButenko contact:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks8.png)
    *   Now check your db.Interactions. It should have one additional interaction.

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks6.png)

        Note the query I use for checking latest interactions, you can use it too:

        `db.Interactions.find({StartDateTime: { $gte : new ISODate("2015-03-13T14:00:31Z")}})`
    *   Now check your db.Contacts. The contact that we saw after step 2 (identifying) now gets additional fields:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks7.png)

19.  Now let’s return to browser page and go to Page1, which as we remember has Sample Goal assigned and should move our contact through the Engagement Plan.
22.  End session again, for our data to get to xDB.

    *   Now check your db.AutomationStates. You should see there an old document, processed, and a new document like next:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks11.png)

        The new document should contain StateTransition with transferring from Initial State to Goal Triggered state.

                            Now you should **wait** until this document looses its StateTransition field and merges together with previous document:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks12.png)

        It means, that engagement automation has already processed StateTransition and moved contact from Initial State to Goal Triggered state. **/this needs to be checked, as I’m not sure if this is done by automation worker or aggregation part/**
    *   Now check Marketing Control Panel, plan’s Goal Triggered state. There should be our KateButenko contact:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks13.png)
    *   You can also check db.Interactions collection to reassure that your second interaction has appeared there:

        ![enter image description here]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/howitworks10.png)
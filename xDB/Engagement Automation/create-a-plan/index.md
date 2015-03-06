---
layout: default
title: Creating an Engagement Plan
category: xdb
---

Engagement plans lets you track visitors through a series of series of states based on their behaviour and status. You can find out more about the basics of Engagement Plans on doc.sitecore.net:

* [Engagement plans overview](https://doc.sitecore.net/Products/Sitecore%20Experience%20Platform/Engagement%20plans/Engagement%20plans)
* [Creating  an engagement plan](https://doc.sitecore.net/Products/Sitecore%20Experience%20Platform/Engagement%20plans/Walkthrough%20Creating%20an%20engagement%20plan)

The engagement plan walkthrough demonstrates how to create an engagement plan using a **design interface** that resembles Visio:

![Alt text]({{site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/engPlan1.png)

In the background, this creates a number of items - which is what we are goign to focus on.

## Initial State

The initial state is the state that visitors are added to when you subscribe them to your engagement plan. Even though we have called it 'Initial State', there is nothing stopping us from enrolling visitors in any state in the plan:

![alt]({{site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/InitialStatePageEventSubscription.png)

Pay attention to **Page Event Subscription** and **Time interval** fields - one or both of these fields **must** be filled in in order for the contact to progress. In this example, a contact will only progress if:

* The contact is in the Initial State
* The the contact triggers the Sample Goal whilst in that state

There is a dropdown on the condition that allows you to specify if you want to **evaluate always, on timeout, or when an event has been triggered**.

In this example, triggering Sample Goal whilst in the Initial State will run a **condition**, which is a child item of the state. You **must** specify a trigger or timeout - conditions will only be evaluated if something has triggered that to happen. You can [find out more about different types of triggers](https://doc.sitecore.net/Products/Sitecore%20Experience%20Platform/Engagement%20plans/Engagement%20plan%20triggers%20and%20conditions).

 > **Note:** You will **not** see the results in Marketing Control Panel immediately. A lot of work in Sitecore 8 is done in the background and inside the contact session.

## Conditions

This example uses a custom historical condition, but you can use any condition you want. Remember - this particular rule will only be run if you have set Page Event Subscription on the parent state. In our rule, when a goal is triggered, we are asking Sitecore to check if this goal has been triggered in the last 15 days. If yes, we might react differently compared to if this is the first time the visitor has triggered that goal:

![alt]({{ site.baseurl}}/images/Engagement%20Automation/Testing%20Plan/Condition1.png)

The wording in the condition is the reason developers sometimes forget to specify a trigger - the logic reads a little strangely:

* Trigger: Sample Goal has been triggered
* Condition: Where sample goal has been triggered...

It seems strange that the rule has to say 'where sample goal has been triggered' when we **know** we just triggered it. That is just the way that rules are worded. It makes more sense if the condition is for something else:

* Trigger: Sample Goal has been triggered
* Condition: Where user is male... 

## Goal Triggered state

No specific settings - we could mark this as the 'final' state by checking the checkbox.

## Checking that it works

Now for the fun part - checking that the engagement plan is doing what it is supposed to. See [debugging engagement plans]({{ site.baseurl }}/xDB/Engagement Automation/debugging) for more information.
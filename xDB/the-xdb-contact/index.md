---
layout: default
title: The xDB Contact
redirect_from: "/documentation/xDB/The xDB Contact/"
---

## What is a contact?
In the Experience Database (xDB), a contact is a visitor. Even if you are anonymous, or have never provided your e-mail address to Sitecore, you are still referred to and stored as a contact.

You can view individual contacts in the **Experience Profile** interface. Note that this interface does not necessarily pull all of its content directly from MongoDB.

## Where are contacts stored?
The **raw contact data** is stored in the **contacts** collection of the **analytics MongoDB**. MongoDB stores information in JSON format. Here is a contact that has provided a first name, surname, and e-mail address:

	{
	    "_id" : LUUID("ad72f93a-a071-1f40-ac68-c165faf21e91"),
	    "Identifiers" : {
	        "IdentificationLevel" : 2,
	        "Identifier" : "extranet\\jill_at_mail_dot_com"
	    },
	    "Lease" : {
	        "ExpirationTime" : ISODate("2015-02-06T11:32:21.381Z"),
	        "Owner" : {
	            "Type" : 0
	        }
	    },
	    "System" : {
	        "Classification" : 0,
	        "OverrideClassification" : 0,
	        "VisitCount" : 1,
	        "Value" : 0
	    },
	    "Personal" : {
	        "FirstName" : "Jill",
	        "Surname" : "Bean"
	    },
	    "Emails" : {
	        "Preferred" : "jill@mail.com",
	        "Entries" : {
	            "work_email" : {
	                "SmtpAddress" : "jillsmtp@mail.com"
	            }
	        }
	    }
	}

A bare bones contact that didn't do much on the site looks like this - they did not submit any information for us to use to identify them:

	{
	    "_id" : LUUID("96ef68cb-644a-8b43-a5e9-8567f7dc63bb"),
	    "System" : {
	        "Classification" : 0,
	        "OverrideClassification" : 0,
	        "VisitCount" : 1,
	        "Value" : 0
	    },
	    "Lease" : null
	}

Contact data is also aggregated down to the **reporting database** (which is used primarily by the reporting API and Engagement Analytics) and the **analytics index**, which is used by the Experience Profile search page and Email Experience Manager.

## What is the difference between a contact and a user?

When we talk about **users** in Sitecore, we tend to mean ASP.NET membership users. There is no direct link between a contact and a user in the xDB - you can be a contact without being a registered user. However, the xDB does store **identifiers** that you can use to link your contact to an ASP.NET user in code. The contact below is **'known'** and identified by their Sitecore extranet user:

	"Identifiers" : {
		        "IdentificationLevel" : 2,
		        "Identifier" : "extranet\\jill_at_mail_dot_com"
		    }

As can be seen from the ContactIdentificationLevel enum below, **2** denotes **known**.

	  public enum ContactIdentificationLevel
	  {
		    None = 0,
		    Anonymous = 1,
		    Known = 2,
	  }

Even though there is an option for 'Anonymous', you will find that the Identifiers section is simply missing from anonymous contacts. 

## Identifying a contact in code

Web Forms for Marketers will automatically 'identify' a contact to match a registered user if you use any of its 'log in' Save Actions. To identify a contact yourself, do the following:

	var domainUser = "extranet\\jill_at_mail_dot_com";
	Tracker.Current.Session.Identify(domainUser);

Remember to format the username correctly, including **domain** and double backslash.  The xDB will now associate your logged-in visitor with an existing xDB record, provided this is not their first visit.

## Extending a Contact

There are a number of ways to add more information to a contact.

* Use [facets]({{ site.baseurl }}/documentation/xDB/Facets) for permanent, business-critical information - such as 'Loyalty Card Number'
* Use [extensions]({{ site.baseurl }}/documentation/xDB/Extensions) for more ad-hoc information - such as 'Favourite Vacation Memory'
* Use [tags]({{ site.baseurl }}/documentation/xDB/Tags) for ad-hoc information that needs to be tracked over time




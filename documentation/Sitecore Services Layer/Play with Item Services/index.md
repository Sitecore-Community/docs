---
layout: default
title: Play with ItemServices
---

# Prerequisites

In order to get everything needed fro the "game", do following:

1. Install clean version of Sitecore 8.1
1. Install [Postman](https://www.getpostman.com/) tool
1. Download following Postman tool export file from [here]({{ site.baseurl }}/files/Sitecore.ItemServices.examples.postman_collection.json)
1. Update host names Postman to correspond your local Sitecore instance.

# Authentication

Few words about authentication: **it works in ItemServices**! But... your site should be available by HTTPS. Logging in works only over HTTPS ([configuring HTTPS binding and self-signed certificate](http://weblogs.asp.net/scottgu/tip-trick-enabling-ssl-on-iis7-using-self-signed-certificates) shouldn't be a big deal).

## Log in

In order to log in, you should do POST request to "https://<your_hostname>/sitecore/api/ssc/auth/login" method with some JSON in the request body (don't forget to set "Content-Type" header to be "application/json"). See an example in Postman export.

![Postman Login]({{ site.baseurl }}/images/SitecoreServicesClient/Postman_login.png)

**Note**: Please pay your attention to "Content-Type: application/json" in request header.
As soon as you are logged in, you will get a cookie ".ASPXAUTH" cookie. That cookie should be in every request in order to keep you logged in (**Note**: Postman tool shares somehow cookies, so you don't need to add that to every request explicitly) 

## Log out

As simple as it is: just POST request to "https://<your_hostname>/sitecore/api/ssc/auth/login". No specific request body or headers required.

## Get an item

Just take one of the example request from Postman export and try them. For example the one with the name "SSC: get item by path".
There are pretty much methods and parameters. They are described in the [official documentation](https://sdn.sitecore.net/upload/sitecore7/75/developer's_guide_to_sitecore.services.client_sc75-a4.pdf). However, please pay attention that it seems that the documentation is a bit outdated. At least I couldn't get some of the methods working. For example running a Sitecore search, described in chapter 3.4.9. there.

## Update an item

There is also such example in Postman export. In order to get an item updated you should be logged in as an "admin" user.

## Remove an item

Example in Postman export, removes an item "/sitecore/layout/Placeholder Settings/webedit". Please be careful with that and play with your custom items.

## Add an item

The example just adds an item underneath Home from "Simple item" template (see parameters in request body).
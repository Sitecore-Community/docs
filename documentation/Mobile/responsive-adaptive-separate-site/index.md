---
layout: default
title: Responsive, adaptive, or separate site?

---

# Responsive, adaptive, or separate site

## What can Sitecore do for me when it comes to mobile?

'Mobile' covers a wide variety of topics, from responsive vs adaptive to native mobile apps.  The following is a list of common questions asked on the subject of Sitecore and  mobile:

* What can Sitecore do to help me optimize my website for mobile?
* Can I still do responsive with Sitecore?
* How can I get data out of Sitecore for use with my own mobile apps?
* Can Sitecore help me scale media based on device?

## Responsive, adaptive, or stand-alone site?

You are starting a fresh Sitecore project. One of the requirements is that the website should be easily accessible for mobile users. What are your options?

### Responsive Design

Sitecore is not going to stop you from building a responsive website. From a development point of view, Sitecore is a platform - it only ships with a single, very simple homepage, and no pre-defined 'templates' (like Wordpress does, for example). 

**However**, you may not be taking full advantage of Sitecore's features if you choose to do responsive only:

* Sitecore users can use the Page Editor to modify the **appearance** of a page by adding and removing components to create uniquely designed pages. If you rely 100% on responsive, you have to make sure that these users are savvy enough to know that what they do on their desktop needs to work when the screen shrinks.
* Although Sitecore collects information about the user agent, reporting shows you engagement and traffic based on Sitecore **devices**, that a responsive site does not take advantage of.
* You may not want the same number or type of component - or hierarchy of information, or even the same view of the content - in the mobile view of your site. With Sitecore devices, you can add, remove, or re-order components to better suit a mobile audience.
* You may wish to personalize your content differently based on whether or not they are a mobile user. If your site is responsive only, you would have to set up every single personalization rule to check 'Is this user a mobile user? If so, do X'.

### Adaptive Design

When we talk about adaptive design in Sitecore, we are talking about **devices**. A device is a way of looking at content - Desktop, print, RSS, mobile, tablet.. you can create any number of devices you want.

An item's presentationd details can vary between devices. If you use the [Mobile Device Detection Module](https://marketplace.sitecore.net/Modules/Mobile_Device_Detector.aspx), you can force a visitor's context device to change when they first hit your site (this information is then stored in their session cookie).

This **does not mean that you have to create a completely different set of presentation details**. In reality, most projects use a blend of responsive and adaptive design - for the following reasons:

* I still get all the benefits of responsive - and more. 
* As a content author, I know that I'm designing my page for a particular device - I am more likely to check (in the Mobile Simulator, for example) that my page looks good in that device. 
* I can add/remove/move components and make my mobile pages lighter.
* As a developer, you have the opportunity to **target a particular device** and change Sitecore's behaviour. For example, you might want to make a change to the image rendering pipeline that sets the max image size to 320 for the mobile device - across the site.
* It is less messy to personalize based on device, and you can target each audience separately.
* You will see traffic and engagement reporting per device.

You can, of course, produce completely device-specific presentation for different devices - but that creates a development and management overhead.

### Separate Site

You can, of course, create a completely separate mobile site within Sitecore - this might be the best solution if your mobile content or design has to be drastically different. Sitecore will allow you to point m.mysite.com to a different starting Home node.

------------------------------

For information about how Sitecore can help you with adapative images, see the [Sitecore and Media section](/docs/documentation/Sitecore and Media/index.html).

# Blog Posts

* [Mobile Device Detection Module](https://marketplace.sitecore.net/Modules/Mobile_Device_Detector.aspx)
* [http://techitpro.com/sitecore-mobile-website-shared-content-tree-structure-part-1/](http://techitpro.com/sitecore-mobile-website-shared-content-tree-structure-part-1/)
* [http://techitpro.com/sitecore-mobile-website-separate-content-tree-structure-part-2/](http://techitpro.com/sitecore-mobile-website-separate-content-tree-structure-part-2/)
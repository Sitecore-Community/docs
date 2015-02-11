---
layout: default
title: Sitecore Authorizations
---
Sitecore uses authorizations to control permissions across the system. Sitecore's authorization system is fully extensible, which means you can create custom authorizations that apply to your custom functionality. 

* [Authorization Basics](#authorization_basics)
* [Configuring Authorizations](#configuring_authorizations)
* [Authorizations API](#authorizations_api)

## <a name="authorization_basics">Authorization Basics</a>
Authorizations allow functionality in Sitecore to be enabled or disabled based on specific conditions being met. The most common condition is whether a user is a member of a specific role, but virtually any state can be used as a condition for authorizations.

* [Terminology](#terminology)
* [Access Right Inheritance](#access_right_inheritance)

#### <a name="terminology">Terminology</a>
The following table covers the different terms used when describing authorizations. All classes listed are in the `Sitecore.SecurityAccessControl` namespace.

* [AccessRight](#accessright)
* [AccessRule](#accessrule)
* [AccessResult](#accessresult)
* [AccessPermission](#accesspermission)
* [AccessExplanation](#accessexplanation)
* [ISecurable](#isecurable)
* [AuthorizationProvider](#authorizationprovider)
* [AccessRightProvider](#accessrightprovider)

###### <a name="accessright">AccessRight</a>
Something that can or cannot be done.

Examples:

* Field read
* Field write
* Item rename
* Item create
* Language read

###### <a name="accessrule">AccessRule</a>
Specifies which items an AccessRight applies to.

Examples:

* All items based on a specific template
* All items that are descendants of a specific item
* The item at a specific path

###### <a name="accessresult">AccessResult</a>
When Sitecore evaluates an access right for a specific account at a specific time, the result of the evaluation is represented in an `AccessResult` object.

###### <a name="accesspermission">AccessPermission</a>
Property of an `AccessResult` object that specifies the permission level that should be applied.

Examples:

* NotSet
* Allow
* Deny

###### <a name="accessexplanation">AccessExplanation</a>
Property of an `AccessResult` object that explains why the specified permission level was determined.

Examples:

* The 'sitecore\Author' account has been denied the 'item:write' access right for the '/sitecore/content/Home' item

###### <a name="isecurable">ISecurable</a>
An object that an `AccessRight` can be assigned to.

Examples:

* Item
* Field
* Site

###### <a name="authorizationprovider">AuthorizationProvider</a>
Object used to evaluate access rights (meaning it returns an `AccessResult` object).

###### <a name="accessrightprovider">AccessRightProvider</a>
Object used to get a reference to an `AccessRight`.

#### <a name="access_right_inheritance">Access Right Inheritance</a>
Access rights applied to an item can be inherited by the item's descendants. This is controlled on the item the access right is applied to.

## <a name="configuring_authorizations">Configuring Authorizations</a>
In order for Sitecore to recognize an access right, the right must be registered. This is done using `Web.config` or a Sitecore patch file. Registering a custom access right requires two details be specified: which class represents a right and which items a right applies to.

* [Mapping Access Rights](#mapping_access_rights)
* [Assigning Access Rights to Items](#assigning_access_rights_to_items)

#### <a name="mapping_access_rights">Mapping Access Rights</a>
Within Sitecore access rights are referenced by name. The name is associated with a class. The mapping of a name to a class is defined under `/configuration/sitecore/accessRights/rights`.

The following are examples of how to map access rights. 

{% highlight xml %}
<add name="field:read" comment="Read right for fields." title="Field Read" />
<add name="field:write" comment="Write right for fields." title="Field Write" modifiesData="true" />
<add name="item:read" comment="Read right for items." title="Read" />
<add name="item:write" comment="Write right for items." title="Write" modifiesData="true" />
<add name="item:rename" comment="Rename right for items." title="Rename" modifiesData="true" />
{% endhighlight %}

When an access right is configured the following attributes are available.

* [`name`](#access_right_name)
* [`title`](#access_right_title)
* [`comment`](#access_right_comment)
* [`modifiesData`](#access_right_modifiesData)
* [`type`](#access_right_type)
* [`isFieldRight`](#access_right_isFieldRight)
* [`isItemRight`](#access_right_isItemRight)
* [`isLanguageRight`](#access_right_isLanguageRight)
* [`isSiteRight`](#access_right_isSiteRight)
* [`isWildcard`](#access_right_isWildcard)
* [`isWorkflowCommandRight`](#access_right_isWorkflowCommandRight)
* [`isWorkflowStateRight`](#access_right_isWorkflowStateRight)

###### <a name="access_right_name">`name`</a>
Name that is used with the Sitecore authorizations API to access the access right. 

By convention this value is in the format `[component]:[access type]`. This makes it easier to understand the relationship between an access right and the component it affects.

* Required: `yes`
* Example: `item:read`

###### <a name="access_right_title">`title`</a>
The value that appears in the Sitecore security configuration user interface.

* Required: `yes`
* Example: `Read`
 
###### <a name="access_right_comment">`comment`</a>
Descriptive text that can be accessed using the authorizations API.
###### <a name="access_right_modifiesData">`modifiesData`</a>
Indicates whether the access right may result in data in a Sitecore database being changed. 

This setting allows Sitecore automatically deny access when the database is in read-only mode. 

* Required: `no`
* Example: `false`

###### <a name="access_right_type">`type`</a>
If no class is specified, `Sitecore.Security.AccessControl.AccessRight` class is used.

* Required: `no`
* Example: `Testing.MyRight, Testing`

###### <a name="access_right_isFieldRight">`isFieldRight`</a>
Indicates whether the access right applies to fields.

If the access right is marked as a field right the `AuthorizationManager` allows the operation as long as the operation is NOT explicitly denied.

If the access right is NOT marked as a field right the operation is allowed only if access is explicitly allowed.

* Required: `no`
* Example: `false`

###### <a name="access_right_isItemRight">`isItemRight`</a>
Indicates whether the access right applies to items.

The Sitecore Access Viewer displays item access rights by default. Other access rights must be manually selected using the "Columns" button.

* Required: `no`
* Example: `false`

###### <a name="access_right_isLanguageRight">`isLanguageRight`</a>
Indicates whether the access right applies to languages.

* Required: `no`
* Example: `false`

###### <a name="access_right_isSiteRight">`isSiteRight`</a>
Indicates whether the access right applies to sites.

* Required: `no`
* Example: `false`

###### <a name="access_right_isWildcard">`isWildcard`</a>
Indicates whether the access right is a wildcard.

* Required: `no`
* Example: `false`

###### <a name="access_right_isWorkflowCommandRight">`isWorkflowCommandRight`</a>
Indicates whether the access right applies to workflow commands.

* Required: `no`
* Example: `false`

###### <a name="access_right_isWorkflowStateRight">`isWorkflowStateRight`</a>
Indicates whether the access right applies to workflow states.

* Required: `no`
* Example: `false`

#### <a name="assigning_access_rights_to_items">Assigning Access Rights to Items</a>
The Sitecore Client allows users to assign access rights to items. A user is able to assign access to rights to items, templates, fields and so on. While these are all items, they are different types of items, and they have different types of access rights that can be assigned.

In order to display the appropriate access rights to a user, Sitecore needs to be able to determine which access rights are appropriate for a specific item. Access rights are used to control this.

Access rights are defined under `/configuration/sitecore/accessRights/rules`.

The following are examples of how to specify rules for access rights. 

{% highlight xml %}
<add prefix="field:" ancestor="{3C1715FE-6A13-4FCF-845F-DE308BA9741D}" comment="/sitecore/templates" typeName="Sitecore.Data.Fields.Field" />
<add prefix="insert:" templateId="{35E75C72-4985-4E09-88C3-0EAC6CD1E64F}" comment="insert:show for Branch template" />
<add prefix="insert:" templateId="{B2613CC1-A748-46A3-A0DB-3774574BD339}" comment="insert:show for Command template" />
<add prefix="insert:" templateId="{AB86861A-6030-46C5-B394-E8F99E8B87DB}" comment="insert:show for Template template" />
<add prefix="item:" typeName="Sitecore.Data.Items.Item" />
<add prefix="language:" ancestor="{64C4F646-A3FA-4205-B98E-4DE2C609B60F}" comment="/sitecore/system/language" />
<add prefix="workflowState:" ancestor="{05592656-56D7-4D85-AACF-30919EE494F9}" comment="/sitecore/system/workflows" />
<add prefix="workflowCommand:" ancestor="{05592656-56D7-4D85-AACF-30919EE494F9}" comment="/sitecore/system/workflows" />
<add prefix="profile:" templateId="{8E0C1738-3591-4C60-8151-54ABCC9807D1}" comment="profile:customize for Profile items only" />
{% endhighlight %}

* [`prefix`](#item_access_right_prefix)
* [`typeName`](#item_access_right_typeName)
* [`templateId`](#item_access_right_templateId)
* [`comment`](#item_access_right_comment)
* [`path`](#item_access_right_path)
* [`descendants`](#item_access_right_descendants)
* [`ancestor`](#item_access_right_ancestor)
* [`action`](#item_access_right_action)

###### <a name="item_access_right_prefix">`prefix`</a>
If the access right's name begins with this value the rule will be applied.

* Required: `yes`
* Example: `item:`

###### <a name="item_access_right_typeName">`typeName`</a>
If the object the access right is being applied to is an instance of the type identified by this value the rule will be applied.

The value should be the type's full name (meaning the value returned by the `FullType` property).

* Required: `no`
* Example: `Sitecore.Data.Items.Item`

###### <a name="item_access_right_templateId">`templateId`</a>
If the object the access right is being applied to is an item and the item is based on the template specified by this value the rule will be applied.

* Required: `no`
* Example: `{AB86861A-6030-46C5-B394-E8F99E8B87DB}`

###### <a name="item_access_right_comment">`comment`</a>
Descriptive text that can be accessed using the authorizations API.

###### <a name="item_access_right_path">`path`</a>
If the object the access right is being applied to is an item whose path matches this value the rule will be applied.

* Required: `no`
* Example: `/sitecore/content/Home`

###### <a name="item_access_right_descendants">`descendants`</a>
If the object the access right is being applied to is a descendant of the item identified by other attributes the rule will be applied.

This setting is most often used in combination with a `path` value, but can also be used with other attributes.

* Required: `no`
* Example: `True`

###### <a name="item_access_right_ancestor">`ancestor`</a>
If the object the access right is being applied to has the specified item has an ancestor the rule will be applied.

Setting this value is equivalent to setting the path `value` and descendants value to `true`.

* Required: `no`
* Example: `/sitecore/Layout/Renderings`

###### <a name="item_access_right_action">`action`</a>
The only value that is supported is `stop`. If the other settings have resulted in the rule being applied, the value stop prevents the rule from being applied.

* Required: `no`
* Example: `stop`

## <a name="authorizations_api">Authorizations API</a>
* [Checking if Access Right Applies](#checking_if_access_right_applies)
* [Caching](#caching)

#### <a name="checking_if_access_right_applies">Checking if Access Right Applies</a>
The Sitecore security API is used to determine if a right is allowed to a specific user. The following is an example of how to use this API.

{% highlight csharp %}
var user = Sitecore.Security.Accounts.User.FromName("extranet\\anonymous", false);
var item = Sitecore.Context.Database.GetItem("/sitecore/content/Home");
var right = Sitecore.Security.AccessControl.AccessRight.FromName("testing:myright");
var access = Sitecore.Security.AccessControl.AuthorizationManager.GetAccess(item, user, right);
{% endhighlight %}

#### <a name="caching">Caching</a>
After an access result is read it is added to the access result cache. This improves performance by reducing the number of times Sitecore needs to read from its database. 

But there are cases where can cause problems. For example, what if you have a custom access right that depends on state, such as an access right that prevents a content author from editing an item until it is at least 5 days old. Caching this sort of access right is problematic because the cache doesn't know when that 5 day threshold has passed.

The `AuthorizationProvider` is the component responsible for caching access rights. The method `AddAccessResultToCache` adds the access result to the access rights cache. If you need to prevent an access right from being cached you must override this method.

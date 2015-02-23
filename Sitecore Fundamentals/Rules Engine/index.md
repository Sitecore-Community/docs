---
layout: default
title: Sitecore Rules Engine
---
Sitecore's Rules Engine provides the ability to evaluate conditions and perform actions that is usable for business users. Using the Rules Engine provides a consistent means for configuring complex, rule-based business logic within Sitecore. 

* [Terminology](#terminology)

## <a name="terminology">Terminology</a>
* [Condition](#condition)
* [Action](#action)
* [Rule](#rule)
* [Rule Editor](#rule_editor)
* [Rule Engine](#rule_engine)

#### <a name="condition">Condition</a>
A state that can be either true or false. 

A condition is configured by a business user who specifies values for parameters. The available parameters depend on the condition. An example of a condition is "where the visitor is logged in". In this condition the parameter is the "is" part of the condition. The business user can specify whether the condition is "where the visitor is logged in" or "where the visitor is not logged in".

A condition is implemented as a .NET class. The available parameters are exposed as properties on the class. The class has a method that evaluates the condition.

Each condition has a corresponding Sitecore item that defines the condition.

#### <a name="action">Action</a>
Logic that is performed. 

An action is configured by a business user who specifies values for parameters. The available parameters depend on the action. An example of an action is "set the data source to /sitecore/content/Promotions/Summer Holidays". In this action the parameter is the "/sitecore/content/Promotions/Summer Holidays" part of the action. The business user can specify the item that should be used.

An action is implemented as a .NET class. The available parameters are exposed as properties on the class. The class has a method that performs the action.

#### <a name="rule">Rule</a>
A set of conditions that, when met, result in a set of actions being performed.

A rule is configured by a business user who selects and configures conditions and actions. 

Sitecore stores rules in an XML format. Sitecore provides an API that allows developers to execute rules.

#### <a name="rule_editor">Rule Editor</a>
The user interface in the Sitecore Client that allows business users to define rules. Defining a rule entails configuring conditions and actions, which the Rule Editor facilitates.

#### <a name="rule_engine">Rule Engine</a>
The Sitecore component that is responsible for evaluating conditions and performing actions.

Sitecore provides an API that allows developers to access the Rules Engine.

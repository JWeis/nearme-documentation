---
title: Basic Concepts
permalink: /how-platformos-works/basic-concepts
---

## Pages, layouts, and partials 

**Pages** are the the most essential components of our platform, that define content displayed at a given path. Each page is represented by a single file with a liquid extension. 

**Layouts** are Liquid views that store code that would normally repeat on a lot of pages and is surrounding page content (e.g. header, footer). Without layouts, pages would share a lot of duplicated code, and changing anything would become a very time consuming and error prone process. You can create as many layouts as you need, and decide which page uses which layout. 

**Partials** (partial templates) allow you to easily organize and reuse your code by extracting pieces of code to their own files. They help you improve code readability and follow the principle of DRY (Don’t Repeat Yourself). You can parameterize partials and use them in various places, e.g. layouts, pages, Authorization Policies, Form Configurations.

[Learn how to use pages, layouts and partials in our Get Started guides]()

## Form Configurations

**Form Configurations** are the main tool for rendering forms, persisting data, and sending notifications (email/sms/api) in a secure and customizable way. 

They give you full control when defining: 

* which fields for a defined resource can be persisted 
* what authorization rules apply to be able to submit the form (i.e. if you want to edit a comment, you might want to specify that only the creator or the administrator is able to do it) 
* what should happen when the form is submitted successfully (i.e. without validation errors), e.g. send an email/sms notifications or API call to a third party system 
* where the user should be redirected 

On top of that, you can define callbacks (either synchronous or asynchronous) for further modifications to the system using GraphQL mutations. For example, you can define a signup form that creates User records, and if the user input is valid, also creates a few sample products for them, so that they don’t have to start from scratch. 

[Learn how to use Form Configurations in our Get Started guide]()

## Users, User Profiles

**Users** are accounts that any of your users can have. Users are identified by their unique email addresses. 

**User Profiles** are roles in the marketplace. Each User Profile can be associated with any number of Custom Attributes, Categories, and Custom Model Types. All users are assigned a User Profile named Default.

[Learn how to create and manage Users and User Profiles in our Get Started guide]()

## Custom Attributes and Custom Models 

**Custom Attributes** are fields that you attach to a User Profile, Transactable, Relationship, Custom Model Type, etc. We also provide some Custom Attributes to jumpstart your development. 

**Custom Model Types** have multiple use cases. Think of them as a custom DB table, which allows you to build highly customized features. Use them to group Custom Attributes, and allow the user to provide multiple values for each of them.

[Learn how to use Custom Attributes and Custom Model Types in our Get Started guides]()

## Authorization Policies

**Authorization Policies** allow you to restrict access to forms and pages in a flexible way. Each form or page can have multiple policies attached to it.

Each policy is parsed using Liquid, and the system checks them in order of their appearance in the code. The system redirects the user to a URL provided by the developer if the condition is not met. You can also add a message for the user who has been rejected because of insufficient access rights. 

[Learn how to use Authorization Policies in our Get Started guides]()

## Transactables, Transactable Types 

**Transactable** represents a resource around which any transaction is made. Transactables can be products (e.g. users selling products that other users want to buy), services (e.g. matching users who provide services with those who want to hire them), or projects (e.g. matching users with a project to experts who can accomplish it). 

**Transactable Types** allow you to define Transactables in terms of what custom attributes, images, addresses and attachments they have per business rules.

[Learn how to use Transactables and Transactable Types in our Get Started guides]()

## Orders

**Order** is an object against which you can create a Payment. It has utility methods to easily summarize the amount of all TransactableLineItems associated with it. One TransactableLineItem is always connected to one order and one Transactable.

**Order Types** allow you to specify Custom Attributes for Orders. For example, if you want to ask a user for some extra information during checkout, or you might want a service provider to be able to take notes per order.

[Learn how to use Orders and Order Types in our Get Started guides]()

## Translations 

You can use Platform OS to build sites in any language, and each site can have multiple language versions. **Translations** are yml files used for multilingual sites, but also used to define date formats, or flash messages. 

[Learn how to use Translations in our Get Started guides]()

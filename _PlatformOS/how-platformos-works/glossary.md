---
title: Glossary
permalink: /how-platformos-works/glossary
---

## Assets

Assets are files that can be served by an http web server without any backend/server processing. They are usually javascript, stylesheets, documents (html, pdf, doc), fonts, media (audio, video) etc. files.

## Assets, Asset Building Tools

Use any tool you want to provide static assets. We prefer webpack, which is arguably the most powerful and flexible. You might want to use rollup or any other set of tools you are comfortable with, as long as the output is placed into the `assets/` directory.

Read more about your options here: [https://survivejs.com/webpack/appendices/comparison/](https://survivejs.com/webpack/appendices/comparison/)

## Assets, Static Assets

To upload a static asset into our Content Delivery Network (CDN), place your assets into the `marketplace_builder/assets/` directory. They will be propagated in the most efficient way for user that is currently accessing them.

Read more about our CDN and adding static assets here: [http://documentation.near-me.com/getting-started/pages/adding-web-assets](http://documentation.near-me.com/getting-started/pages/adding-web-assets)

## Authorization Policies

Authorization policies allow you to restrict access to forms and pages in a flexible way. Each form or page can have multiple policies attached to it.

Each policy is parsed using Liquid and the system will check them in order of their appearance in the code.

The system redirects the user to a URL provided by the developer if the condition is not met. You can also add a message for the user who has been rejected because of insufficient access rights.

## CDN

We provide one of the best Content Delivery Networks in the world: CloudFront.

Everything you place in the `assets/` directory will be served by this performant CDN. You can nest directories however you want, the directory structure will be kept.

You access files using either the `asset_url` filter, `asset_url` hash, or composing the path yourself, since it is deterministic—it consists of cdnPath + path/to/asset.

Read more about CloudFront: [https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)

## content_for and yield

Inject dynamic content into a Layout from a Page or Partial using `content_for` and the `yield` tag. Use these to alter content that is higher from the structural point of view (Layout). It is very often used when setting metadata for a particular page (i.e. title tag contents), loading per-page javascript, per-page stylesheet.

Usage example:

Define what you want to yield in your Page:

```
{% content_for 'page_title' %}Platform OS Blog{% endcontent_for %}
```

Then use yield inside the Layout:

```
<title>{{ yield 'page_title' }}</title>
```

## Custom Attributes

Custom Attributes are fields that you attach to a User Profile, Transactable, Relationship, Custom Model Type, etc.

Some of them are provided by us to jumpstart your development—for example, we have a Custom Model Type called `custom_address` and it has multiple Custom attributes baked in.

Read more about custom_address here: [http://documentation.near-me.com/reference/custom-attributes/custom-addresses](http://documentation.near-me.com/reference/custom-attributes/custom-addresses)

## Custom Model Types

Custom Model Types have multiple use cases.
Think of them as a custom DB table, which allows you to build highly customized features. Use them to group Custom Attributes, and allow the user to provide multiple values for each of them.

For example you can build a table that will store a user's favorite books. Each book has an author, title and a number of pages. These three fields are Custom Attributes. That’s why you can use Custom Model Type to group custom attributes.

Now you can build a form that allows users to add multiple books attached to their user profile (using GraphQL).

Custom address, for example, is a Custom Model with Custom Attributes attached to it for your convenience. Custom Models you create are used in the same way as our built-in one.

## Environments

Each marketplace has at least two environments: staging and production.

Staging is used to develop and test your application before it goes live—it is a place to catch and fix bugs.

If you are a Partner, you most likely will want to use a sandbox environment to develop your application and then use staging to show the client the progress, and get final sign-off before promoting changes to production.

## Form Configuration

Form Configuration is a concept, which gives you full control over both the look & feel of a form, along with its behavior.

## FrontMatter (YAML)

The triple dashes `---` you see in various places (e.g. Form Configurations) are called FrontMatter.

They are used to define variables in a YML format. In our case you can use Liquid and GraphQL in them, and they resolve before those variables are interpreted by the server.

There are various implementations of FrontMatter, but they have one aspect in common: they parse YML embedded in a different file, and return configuration and content of that file. Configuration is between `---` & `---` and content is the rest of it.

Read more about YAML here: [https://en.wikipedia.org/wiki/YAML](https://en.wikipedia.org/wiki/YAML)

See one of the implementations of FrontMatter: [https://www.npmjs.com/package/frontmatter](https://www.npmjs.com/package/frontmatter)

## GraphQL

A query language used to communicate with our data storages.

To learn more, check out the [Official GraphQL Documentation](http://graphql.org/learn/).

## Instance

The sites created on the Partner Portal are called Instances. Instances have a URL, and they represent different development environments, like staging or production.

## Layout

Layout is a special kind of Liquid view that stores code that would normally repeat on a lot of pages and is surrounding page content.

Usual use case for Layouts is storing html doctype, header, footer, javascripts.

Read more about Layouts here: [http://documentation.near-me.com/getting-started/pages/layouts](http://documentation.near-me.com/getting-started/pages/layouts)

## Liquid

A template language used in Platform OS to build dynamic pages, and to provide dynamic configuration (e.g. based on currently logged in user). Use Liquid to provide Authorization Policies for forms and pages, or to specify Notifications (email, sms, API call).

If you are not familiar with Liquid, a good starting point to learn is their [Official Liquid Documentation](https://shopify.github.io/liquid/). We have added a lot of filters and tags to make your life easier.

Read more about Liquid for designers here: [https://github.com/Shopify/liquid/wiki/Liquid-for-Designers](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers)

## Marketplace Kit

Marketplace Kit (marketplace-kit) is a tool that helps you quickly:
develop your application (sync command)
deploy your application (deploy command)

Read more about the Node.js version of marketplace-kit here: [https://github.com/mdyd-dev/marketplace-kit/tree/node-version](https://github.com/mdyd-dev/marketplace-kit/tree/node-version)

## Node.js

Node.js is a javascript runtime for servers based on Chrome's V8 engine. By itself, it allows developers to write and run javascript on the server.

Currently Long Term Support version is 8.x, and we always recommend you to use newest LTS version of Node for both stability and security reasons.

Read more about Node.js here: [https://nodejs.org/en/about/](https://nodejs.org/en/about/)

## Notifications

Notifications are messages sent to marketplace users (including admins) when something happens. A message can be an email, sms or programmatic call to a 3rd party API.

They can be delayed, you can use Liquid, GraphQL, and trigger conditions to decide if a Notification should be sent. It is a very powerful mechanism used for example to welcome your new users, and then follow up after they added their first item, or even if they have been inactive for some time.

Read more about Notifications here: [http://documentation.near-me.com/reference/notifications/](http://documentation.near-me.com/reference/notifications/)

## NPM and NPM scripts

NPM is a Node Package Manager that allows you to install packages published in the NPM registry. There are many different packages that you can install, some of them written by the Platform OS team, like the Marketplace Kit.

Read more about NPM here: [https://www.npmjs.com/](https://www.npmjs.com/)

## NVM

Node Version Manager is an NPM package that helps you manage multiple versions of node in your system, and allows you to quickly switch between them. Install any version.

Read more about nvm here: [https://github.com/creationix/nvm](https://github.com/creationix/nvm)

## Order

Order is an object against which you can create a Payment. It has utility methods to easily summarize the amount of all TransactableLineItems associated with it. One TransactableLineItem is always connected to one order and one Transactable.

## Order Types

OrderType allows you to specify Custom Attributes for Orders. For example, if you want to ask a user for some extra information during checkout, or you might want a service provider to be able to take notes per order.

## Page

Pages are the most essential components of our platform, that define content displayed at a given path.

Pages have to be located in the `views/pages` directory, and their content is rendered in place of `{{ content_for_layout }}` variable in the layout they’re using.

Read more about pages here: [http://documentation.near-me.com/getting-started/pages/page](http://documentation.near-me.com/getting-started/pages/page)

## Partial

Partial is a piece of code extracted to its own file to maintain readability and rule of DRY—Don’t Repeat Yourself.

Parameterize partials and use them in various places, e.g. Layout, Pages, Authorization Policies, Form Configurations.

Example usage:

```
{% include 'layouts/blog/header' %}
```

With variable passed to the partial:

```
{% include 'layouts/shared/javascripts', include_analytics: false %}
```

## Partner Portal

Our Partner Portal is an online interface where our Partners can create, manage, and configure sites built with Platform OS, and manage other users of the Partner Portal. The site created on the Partner Portal will be the site you deploy and sync your changes to during development.

## Partner

Users of the Partner Portal are called Partners. Partners have the permissions to create, manage, and configure Instances. Partners can also create and manage other Partners.

## Push (deploy)

Pushing code to an Instance means it will pack your marketplace_builder into a zip file and send it to the server. In the future only modified files will be compressed and pushed to the server.

A special case of deploy is a deploy with a `--force` (or `-f`) flag. It means it will deploy changes and additionally it will remove all files from the server that are not present in the currently pushed version.

## Sync

Syncing to any environment means that marketplace-kit is watching your filesystem for changes. Whenever you change a file, it automatically picks it up and sends it to the server. If this operation fails, you will see a message in your console—we have some validations on the server side to prevent you from deploying corrupted code and breaking your marketplace.

## Transactable

Transactable is the core concept in our platform, it represents a resource around which any transaction is made. This model should be used to represent for example:

* Product: If you want to build a marketplace matching people who want to sell or rent something with the ones who want to borrow or buy it, then the product is a Transactable.
* Service: If you want to build a marketplace matching people who provide services with those who want to hire them, the services are Transactables. Technically speaking, the system does not really allow to hire people per se (Users or UserProfiles)—you’ll always need a Transactable object, even if it's invisible from the UI level.
* Project: If you want to build a marketplace for users with a particular idea or task, who would like to get offers from experts, and then choose one expert, then they have to describe the task/job/project they want to have completed. This task/job/project is a Transactable.

## Transactables, Transactable Type

Transactable Types allow you to define Transactables in terms of what custom attributes, images, addresses and attachments they have per business rules.

## Translations

Translations are yml files used for multilingual sites, but also used to define date format, or flash messages.

## User Profiles

User Profiles are roles in the marketplace. Each User Profile can be associated with any number of Custom Attributes, Categories, and Custom Model Types. All users are assigned a User Profile named Default.

## Version Control System (Git)

Version Control System is a tool that helps you store a history of your changes so that you can go back when things go wrong. Additionally, if you work in a team, they help you keep track of who did what, resolve potential code conflicts, discuss code, etc.

Platform OS recommends Git as it is decentralized and widely supported by many tools.

Read more about version control systems here: [https://en.wikipedia.org/wiki/Version_control](https://en.wikipedia.org/wiki/Version_control)

## Views

The usual structure of a webpage with the possibility to use Layouts, Pages and Partials:

* Create a Layout: `marketplace_builder/views/layouts/application.liquid`
* Create Pages with different slugs: `marketplace_builder/pages/about-us.liquid`
* Create Partials that are used both in Layout and Pages: `marketplace_builder/views/layouts/shared/_javascripts.liquid`, `marketplace_builder/views/partials/shared/_contact-form.liquid`

Because `_contact-form.liquid` is a Partial it can be used in multiple places, about-us page, contact-us page, and in a configuration form.

## YAML

A human friendly data serialization standard used in Platform OS for setting properties in configuration files. To learn more, visit the [Official YAML Documentation](http://www.yaml.org/start.html).

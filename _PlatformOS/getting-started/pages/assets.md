---
title: Assets
permalink: /getting-started/pages/assets
---

Assets are files that can be served by an http web server without any backend/server processing. They are usually Javascript files, stylesheets (CSS), documents (html, pdf, doc), fonts, or media (audio, video) files.

## Assets directory

The directory for assets is: `marketplace_builder/assets`

In order to correctly communicate with the Platform OS engine and API, your code base should be organized into a specific directory structure. The root directory of your project should contain the `marketplace_builder` directory, and assets should be placed into the `assets` directory inside `marketplace_builder`. 
 
Although only the `assets` directory is required and you can put your assets there, we recommend you further organize your assets into subdirectories inside the `assets` directory, e.g. `images`, `scripts` for Javascript files, `styles` for CSS files, etc. This is also how the `marketplace-kit init` command will create the required directory structure.  

## Content Delivery Network 
Assets are uploaded to a Content Delivery Network (CDN). The directory structure on the CDN corresponds to the required directory structure of your code base, except for the beginning of the URL. 

**Example**

Location of image asset in code base: 
`marketplace_builder/assets/images/logo.svg`

URL of image asset on CDN:
`https://dmtyylqvwgyxw.cloudfront.net/instances/163/assets/images/logo.svg` 

## Accessing assets 
You can access assets through their relative path on the CDN, or with the `{{ asset_url }}` helper. 

**Examples**

Accessing an image from a CSS file:
`background: transparent url('../images/logo.svg') top center no-repeat;`

Accessing a Javascript file from a layout:
`<script src="{{ 'assets/scripts/app.js' | asset_url }}"></script>`

Accessing a CSS file from a layout:
`<link rel="stylesheet" href="{{ 'assets/styles/app.css' | asset_url }}">`

Accessing an HTML file from a page:
`<a href="{{ 'assets/test.html' | asset_url }}">Test</a>`

## Syncing and deploying assets 

Syncing and deploying without force mode only add files on the CDN, and all the added assets will stay in the database even if you delete them on your computer. 

To remove files from the database that you deleted on your computer, deploy with the `-f` flag. See [Deploying and Syncing Changes](). 

## Related topics

* [Using Static Assets on Your Pages]()
* [Adding Visuals to Your Pages: CSS]()
* [Adding Visuals to Your Pages: Liquid]()
* [Adding Visuals to Your Pages: Javascript]()

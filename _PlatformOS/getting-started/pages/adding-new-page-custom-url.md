---
title: Adding a New Page at a Custom URL
permalink: /get-started/pages/adding-new-page-custom-url
---
This guide will help you add a new page to your site at the URL you specify. 

## Requirements
To follow the steps in this tutorial, you should understand how to create a page. 

* [Creating a Page]()

## Steps 

Adding a new page at a custom URL is a two-step process:

1. Create link to new page
2. Create new page 

### Step 1: Create link to new page

Add a link to the previously created `home.liquid` page, that links to the About page: 

{% raw %}

```liquid
---
slug: /
---

<a href="/about">About</a>

Homepage
```

{% endraw %}

Sync or deploy. You should see the About link appear on your Homepage. 

### Step 1: Create new Page

Create the `about.liquid` page in the `marketplace_builder/views/pages` directory. Add a short description ("About"), that shows you this is the About page, and also a link back to the Homepage.  

{% raw %}

```liquid
---
slug: about
---

About page

<a href="/">Home</a>
```

{% endraw %}

Sync or deploy. You should see that the About link on your Homepage now links to the newly created About page. The Home link on your About page links to your Homepage, so you can switch back and forth between the two pages. 

## Next steps
Congratulations! You have created a new page at a custom URL. Now you can learn how to inject dynamic content into a layout. 

* [Injecting Dynamic Content into a Layout]()

## Questions?

We are always happy to help with any questions you may have. Consult our  [documentation](), [contact support](), or  [connect with our sales team](). 

---
title: Creating a Page
permalink: /get-started/pages/creating-page
---
This guide will help you create a page. 

## Requirements
So that you can follow the steps in this tutorial, you have to have a layout that the page will use. You should also understand the concepts behind pages and layouts. To check what you've created, you'll need to know how to deploy your changes. 
    
* [Pages]()
* [Creating a Layout]()
* [Deploying and Syncing Changes]()

## Steps 

Creating a page is a four-step process:

1. Create a directory for pages
2. Create a page file
3. Edit the page file 
4. Deploy and check

### Step 1: Create a directory for pages

Pages should be placed into the `views/pages` directory inside `marketplace_builder`. 

If you are starting from scratch (without having created the required directory structure), navigate to the `views` directory you created for the `layouts` directory inside `marketplace_builder`, then create a directory called `pages` inside `views`. 

If you have already installed the required directory structure, you can skip this step, and just locate your `marketplace_builder/views/pages` directory. 

### Step 2: Create a page file
In the `pages` directory, create a Liquid file called `home.liquid`. 

### Step 3: Edit the Page file
Edit the `home.liquid` page file. 

See a sample page file with explanations below:

{% raw %}

```liquid
---
slug: /
---

Homepage
```

{% endraw %}


Explanation: 

* Pages have two required parameters: `slug` and `format`, but the default format is HTML. 
* `---` separate configuration from content. 
* `/` marks the root page, which is the homepage. 

Save your page file.

### Step 4: Deploy and check 

Deploy or sync your changes, and check the source code of your homepage. You should see the layout file with the page content injected into it, like this:

{% raw %}

```liquid
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Layout title</title>
</head>

<body>
<h1>Layout</h1>

Homepage

</body>

</html>

```

{% endraw %}

## Next steps
Congratulations! You have created a page file. Now you can add new pages at custom URLs. 

* [Adding New Pages at Custom URLs]()

## Questions?

We are always happy to help with any questions you may have. Consult our  [documentation](), [contact support](), or  [connect with our sales team](). 




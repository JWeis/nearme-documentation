---
title: Reusing Code Across Multiple Pages 
permalink: /get-started/pages/reusing-code-across-multiple-pages
---
This guide will help you reuse code across multiple pages using partials. 
Partials are pieces of code extracted to their own files to maintain code readability, and follow the rule of DRY—Don’t Repeat Yourself. 

## Requirements
To follow the steps in this tutorial, you should have created a page and a layout before. 

* [Creating a Page]()
* [Creating a Layout]()

## Steps 

Reusing code across multiple pages using partials is a two-step process:

1. Create a partial
2. Include the partial 

### Step 1: Create a partial 

This tutorial uses the previously created `application.liquid` layout:  

{% raw %}

```liquid
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>
  {% yield 'meta_title' %}
  </title>
</head>

<body>
<h1>Layout</h1>
{{ content_for_layout }}

</body>

</html>

```

{% endraw %}

Create a partial file `meta_tags.liquid` in the `marketplace_builder/views/partials` directory. The content of the partial is the extracted meta tags from the layout:

{% raw %}

```liquid 
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

```

{% endraw %}

### Step 2: Include the partial

In the original layout, include the `meta_tags.liquid` partial. Partials resolve from `views/partials`, so in the include you only have to specify the name of the partial in the `views/partials` directory. 

{% raw %}

```liquid
<!doctype html>
<html lang="en">
<head>
{% include 'meta_tags' %}
  <title>
  {% yield 'meta_title' %}
  </title>
</head>

<body>
<h1>Layout</h1>
{{ content_for_layout }}

</body>

</html>

```

{% endraw %}

Deploy or sync your changes. You can see that pages using the layout are displayed the same. When you check their source code, you can see that the meta tags have been injected into the layout and thus the pages from the partial.  

You can use partials with CSS, Javascript, etc. or include `yield`, `content_for` tags, etc.  

## Next steps
Congratulations! You have reused code across multiple pages using partials. Now you can learn about using assets.   

* [Using Static Assets on Your Pages]()

## Questions?

We are always happy to help with any questions you may have. Consult our  [documentation](), [contact support](), or  [connect with our sales team](). 


---
title: Using Static Assets on Your Pages
permalink: /get-started/pages/using-static-assets-pages
---
This guide will help you use static assets (e.g. CSS, Javascript, or HTML files) on your pages. 


## Requirements
To follow the steps in this tutorial, you should be familiar with the required directory structure for your code base, and understand the concepts of pages, layouts, and assets. You'll extend code samples from the previous tutorials.      

* [Required Directory Structure]()
* [Pages]()
* [Layouts]()
* [Assets]()
* [Reusing Code Across Multiple Pages]() (previous tutorial)

## Steps 

Using static assets on your pages is a four-step process:

1. Create assets directory and subdirectories
2. Create assets 
3. Check assets
4. Access assets 

### Step 1: Create assets directory and subdirectories
If you are starting from scratch (without having created the required directory structure), create an `assets` directory inside `marketplace_builder`.

If you have already installed the required directory structure, you can skip this step, and just locate your `marketplace_builder/assets` directory. 

Create subdirectories for different assets inside the `assets` directory: for this tutorial, create `scripts` for storing Javascript files, and `styles` for storing CSS files.  

### Step 2: Create assets 

Create a couple of assets. 

Create a CSS file `app.css` in the `styles` directory:

```css
body {
background-color: #ccc;
}
```

Create a Javascript file `app.js` in the `scripts` directory:

```javascript
console.log('Hello from JS!')
```

Create an HTML file `test.html` in the `assets` directory: 

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Document</title>
</head>

<body>

Hello from test.html

</body>
</html>

```

### Step 3: Check assets
Use `{{ asset_url }}` to check your assets. This will list the full URL of your assets on our content delivery network, including the time of the latest update (used for caching). 

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

{{ asset_url }}

{{ content_for_layout }}

</body>

</html>

```

{% endraw %}

### Step 4: Access assets 

To access assets, use the `asset_url` helper in your layout file:

{% raw %}

```liquid
<!doctype html>
<html lang="en">
<head>
{% include 'meta_tags' %}

<link rel="stylesheet" href="{{ 'assets/styles/app.css' | asset_url }}">

<script src="{{ 'assets/scripts/app.js' | asset_url }}"></script>

  <title>
  {% yield 'meta_title' %}
  </title>
</head>

<body>
<h1>Layout</h1>

{{ content_for_layout }}

<a href="{{ 'assets/test.html' | asset_url }}">Test</a>

</body>

</html>

```

{% endraw %}  
 
Sync or deploy. You should see that the background color of the page has changed to the color specified in the `app.css` file, and the link to `test.html` works. If you check the developer console, you can see that the Javascript is there. 

{% include alert/note.html content="If you are syncing or deploying without force mode, you are only adding files, and they will stay in the database even if you delete them on your computer as long as you don't do a deploy with the `-f` flag." %} 

## Next steps
Congratulations! You have learned how to use static assets on your pages. Now you can learn about adding visuals to your pages using CSS, Liquid, or Javascript. 

* [Adding Visuals to Your Pages: CSS]()
* [Adding Visuals to Your Pages: Liquid]()
* [Adding Visuals to Your Pages: Javascript]()

## Questions?

We are always happy to help with any questions you may have. Consult our  [documentation](), [contact support](), or  [connect with our sales team](). 

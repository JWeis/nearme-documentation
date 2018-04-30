---
title: Adding Visuals to Pages: CSS
permalink: /get-started/pages/adding-visuals-pages-css
---
This guide will help you add visuals (images) to your pages using a CSS file, and accessing and displaying the image through its relative path. 

## Requirements
To follow the steps in this tutorial, you should be familiar with the required directory structure for your code base, and understand the concepts of pages, layouts, and assets.

* [Required Directory Structure]()
* [Pages]()
* [Layouts]()
* [Assets]()

## Steps 

Adding visuals to your pages using a CSS file is a three-step process:

1. Create `styles` directory
2. Create CSS file
3. Link to the CSS file in your layout

### Step 1: Create `styles` and `images` directories 
If you are starting from scratch (without having created the required directory structure), create an `assets` directory inside `marketplace_builder`, then a `styles` and an `images` directory inside `assets`.

If you have already installed the required directory structure, you can skip this step, and just locate your `marketplace_builder/assets/styles` and `marketplace_builder/assets/images` directories. 

Put an image in the images directory (e.g. logo.svg). 

### Step 2: Create CSS file
In the `styles` directory, create a `page.css` file:

```css
.logo {
   height: 100px;
   background: transparent url('../images/logo.svg') top center no-repeat;
}
```

Here, in a static CSS file, you can't use the `{{ asset_url }}` helper to get the URL of the image on the CDN, so you have to refer to it with its relative path. 

On your computer, the CSS file is in the `marketplace_builder/assets/styles` directory, so to point to the image file in the `marketplace_builder/assets/images` directory, you have to go two levels up (`..`) to the `assets` directory , and then write the path from there. 

This directory structure corresponds to the directory structure on the CDN, so the relative path works the same way on your Instance.  

### Step 3: Link to the CSS file in your layout

{% raw %}

```liquid
<!doctype html>
<html>
<body>
   <head>
      <link rel="stylesheet" href=" {{ styles/page.css | asset_url }}"> 
   </head>

<div class="logo"></div>

</body>
</html>

```

Sync or deploy. You should see the image displayed on your page. 

## Next steps
Congratulations! You have learned how to add an image to your pages using CSS. You can also learn about adding visuals to your pages in Liquid or Javascript. 

* [Adding Visuals to Your Pages: Liquid]()
* [Adding Visuals to Your Pages: Javascript]()

## Questions?

We are always happy to help with any questions you may have. Consult our  [documentation](), [contact support](), or  [connect with our sales team](). 

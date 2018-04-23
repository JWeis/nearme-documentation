---
title: Pages
slug: /getting-started/pages/pages
---

**Pages** are the most essential components of our platform, that define content displayed at a given path. All pages have to be located in the `views/pages` directory. Each page is represented by a single file with `liquid` extension. 

## Page configuration
See below a sample page configuration file, with explanations for each element:  

{% raw %}

### views/pages/my-page.html.liquid

```liquid
---
slug: my-page
layout_name: my_custom_layout
---
<h1>Welcome to My Page</h1>
<p>A paragraph explaining what I do.</p>
```

{% endraw %}


| Property      | Description                                                                                                                                                                                                                                                                                                | Default     | Example          |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ---------------- |
| `slug`        | Defines the url at which this page will be accessible. Assuming your site domain is https://example.com, you will be able to access the page at https://example.com/`<slug>`. | n/a         | `my-page`          |
| `layout_name` | Defines which layout from `views/layouts/` you would like to use. If you don't want to use any layout, set it to empty string. It will be equivalent to just rendering page content.                                                                                                                        | application | `my_custom_layout` |

Everything after the front matter is the body of the page.

## Homepage
The Homepage slug is `/`, which will work for both https://example.com and https://example.com/. See this sample file for configuring the home page:  

{% raw %}

### views/pages/home.html.liquid

```liquid
---
slug: /
---
<h1>Welcome to my home page</h1>
<p>A paragraph explaining what we do</p>
```

{% endraw %}


## Formats

To define which format the endpoint will be available for, place `.<format>` before the file extension.

Examples:

* about-us.html.liquid
* orders.xml.liquid
* users-report.csv.liquid
* coordinates.json.liquid
* feed.rss.liquid
* datepicker.css.liquid
* server-constants.js.liquid
* purchase-order.pdf.liquid

## Accessing different formats

You can have multiple pages with the same slug, but with different formats, and access them at the same time.

For example you can have both `html`, `pdf` and `txt` version of a page with `Hello world`:

{% raw %}

### views/pages/hello.html.liquid

```liquid
---
slug: hello
---
Hello world
```

{% endraw %}

{% raw %}

### views/pages/hello.pdf.liquid

```liquid
---
slug: hello
---
Hello world
```

{% endraw %}

{% raw %}

### views/pages/hello.txt.liquid

```liquid
---
slug: hello
---
Hello world
```

{% endraw %}

Those will be accessible under the URLs:

* https://example.com/hello
* https://example.com/hello.pdf
* https://example.com/hello.txt

Note that the `html` format is implicit, default, you don't need to specify it in the URL.


## Related topics
* [Layouts]()
* [Creating a Page]()


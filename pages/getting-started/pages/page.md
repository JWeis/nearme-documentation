---
title: Pages
permalink: /getting-started/pages/page
---

Page is the fundament of our platform. It allows you to define which content will be shown at given path. All pages have to be located in `views/pages` directory. Each page is represented by a single file with extension liquid. Here is a sample file for configuring home page:
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

| Property      | Description                                                                                                                                                                                                                                                                                                | Default     | Example          |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ---------------- |
| `slug`        | defines the url at which this page will be accessible. Assuming your marketplace domain is https://example.com, you will be able to access the page at https://example.com/`<slug>`. Homepage is exception - for homepage use '/', which will work for both https://example.com and https://example.com/ ] | n/a         | my-page          |
| `layout_name` | defines which layout from `views/layouts/` you would like to use. If you dont want to use any layout, set it to empty string. It will be equivalent to just rendering page content.                                                                                                                        | application | my_custom_layout |

Everything after the front matter is the body of the page.

## Formats

To define for which format the endpoint will be available place the `.<format>` before the file extension.

Available formats: `html`, `xml`, `csv`, `json`, `rss`, `css`, `js`, `pdf`, `txt`

Examples:

* about-us.html.liquid
* orders.xml.liquid
* users-report.csv.liquid
* coordinates.json.liquid
* feed.rss.liquid
* datepicker.css.liquid
* server-constants.js.liquid
* purchase-order.pdf.liquid
* notes.txt.liquid

## Accessing different formats

You can have multiple pages with the same slug, but with different formats and access them at the same time.

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

Those will be accessible under urls:

* https://example.com/hello
* https://example.com/hello.pdf
* https://example.com/hello.txt

Note that html format is implicit, default, you dont need to specify it in the url.

### Redirects

See [Redirects](./redirects) to redirect user to a different page.

### Metadata

A page can be extended using `metadata` property to store any kind of key-value pairs, for example:

```yaml
---
slug: sign-up/choose-role
format: html
layout_name: application
name: Choose Role
metadata:
  title: "This it the title"
  description: "A description"
  tags: ["signup", "choose", "landing"]
---
```

#### Displaying metadata on the page

Metadata is available through Liquid as `page.metadata`

{% raw %}
```iquid

<div class="col">
    <h1> {{ page.metadata.title }} </h1>

    <section>{{ page.metadata.description }}</section>

    <ul>
        {% for tag in page.metadata.tags %}
            <li> {{ tag }} </li>
        {% endfor %}
    </ul>

    <strong>
        {{ page.metadata.tags | join: "," }}
    </strong>
</div>
```
{% endraw %}

#### Searching for a page using it's metadata in GraphQL

```graphql
query find_page_matching_metadata(
  $metadata: String
)
 {
  pages: pages(
    metadata: $metadata
  ) {
    id
    slug
    metadata
    format
    page_url
    title
    content
  }
}
```

There are also a couple of more complex queries available (all support `page` and `per_page` pagination arguments).

* Find pages WITH word `TITLE` somewhere in metadata (in keys or values)

{% raw %}
```graphql
{% execute_query strony, page: 1, per_page: 20, metadata: "TITLE", result_name: res %}
```
{% endraw %}

* Find pages WITHOUT word `TITLE` in metadata (in keys or values)

{% raw %}
```graphql
{% execute_query strony, exclude: 'true', metadata: "TITLE", result_name: res %}
```
{% endraw %}

* Match pages having top-level key `tags`

{% raw %}
```graphql
{% execute_query strony, has_key: 'tags', result_name: res %}
```
{% endraw %}

* Match pages withouth "tags" key

{% raw %}
```graphql
{% execute_query strony, exclude: 'true', has_key: 'tags', result_name: res %}
```
{% endraw %}

* Match pages with key `tags` having (or including) value `bar`

{% raw %}
```graphql
{% execute_query strony, name: 'tags', value: 'bar', result_name: res %}
```
{% endraw %}

* Match pages that do not have key `tags` equal (or including) to `bar`

{% raw %}
```graphql
{% execute_query strony, exclude: 'true', name: 'tags', value: 'bar', result_name: res %}
```
{% endraw %}

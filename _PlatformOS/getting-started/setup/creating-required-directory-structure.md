---
title: Creating the Required Directory Structure
slug: /get-started/creating-required-directory-structure
---

This guide will help you create the required directory structure using the Marketplace Kit. 

In order to correctly communicate with the Platform OS engine and API, your code base should be organized into a specific directory structure. The root directory of your project should contain the `marketplace_builder` directory. All directories other than the `marketplace_builder` will be ignored by the Marketplace Kit when deploying and syncing, so you can keep all your JS and CSS files outside of the `marketplace_builder` directory, and use any pre-processors you want to automatically generate the end result files in a proper path inside `marketplace_builder`.

## Requirements

You can create the required directory structure using the Marketplace Kit, so you have to have it installed on your computer. This funcionality is available from version 1.0.6, so make sure you update your Marketplace Kit to the latest version. 

* [Installing the Marketplace Kit]()
* [Updating the Marketplace Kit]() 

## Steps

Creating the required directory structure with the Marketplace Kit is a two-step process:

1.  Create the directory structure
2.  Explore your directory structure

### Step 1: Create the directory structure

To create the required directory structure, enter:

```
marketplace-kit init
```

Marketplace Kit downloads the directory structure in a zip file, and extracts it into the current directory. 

### Step 2: Explore your directory structure

Once you've downloaded the required directory structure, locate and explore it—this is how your code base for your Platform OS Instances should be organized.

To learn more about the required directories and files, see [Platform OS Components]().

## Next steps

Congratulations! You have created the required file structure for your code base using the Marketplace Kit. You can now deploy and sync changes to your Instance.

* [Deploying and Syncing Changes]()

## Questions?

We are always happy to help with any questions you may have. Consult our [documentation](), [contact support](), or [connect with our sales team]().

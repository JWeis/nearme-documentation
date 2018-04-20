---
title: Quickstart Guide
permalink: /get-started/quickstart-guide
---

Welcome to the Platform OS Quickstart Guide!

This guide will get you set up and ready to develop your site on Platform OS. After you get access to our Partner Portal in step 1, following and finishing the steps in this guide should take less than half an hour. Each step includes tips for learning more: recommendations for further reading, links to our glossary and to in-depth explanations of concepts you might not be familiar with.

Let's get started!

## Step 1: Get access to our Partner Portal

Our [Partner Portal](https://portal.apps.near-me.com) is an online interface, where you can create, manage and configure your sites (called [Instances]()), and create and manage the permissions of other users (called [Partners]()).

Send us an email, or call us to register an account for you on our Partner Portal.

* Email: TO BE ADDED
* Call: +64 1337 128 MPP

You can also get access to our Partner Portal if a registered Partner creates an account for you.

Once registered, you will get an email invitation. Click on the `Accept invitation` link to activate your account.

Clicking on the link redirects you to a page where you can set your password. Enter a password in the `Password` field, then repeat your password in the `Password confirmation` field.

Click on the `Set my password` button. If the two passwords you entered match, you are logged in to our Partner Portal.

## Step 2: Set up a site on our platform

To be able to deploy your site, you have to create an Instance on our Partner Portal. Instances have a URL, and they represent different development environments, like staging or production. We recommend to create a staging environment for going through the steps in this tutorial.

On our Partner Portal, locate your Partner account in the list, and click on the `Instances` link next to it.

You see a list of your Instances (or none, if you haven't created one yet). Click on the `New Instance` button. Add a Name, and select an endpoint. Endpoints for staging sites have a "staging-" prefix.

Click on the `Create` button. We create the Instance, and once it's done (in a couple of seconds), send you an email with further instructions.

In the email you receive, click on the link of your newly created Instance. You now see your Instance—click on the `Log In` button.

To set your password for the Instance, click on the `Reset your password` link. Enter your email, and click on the `Reset Password` button. Follow the instructions we send you in email to set your password.

## Step 3: Install the Marketplace Kit

The Marketplace Kit is a tool that helps you develop and deploy your application.

{% include alert/note.html content="You will need NPM (Node Package Manager) installed on your computer to install the Marketplace Kit. NPM is distributed with Node.js, which means that by installing Node.js, you automatically get NPM installed on your computer. If you haven't installed Node.js yet, follow our tutorials that walk you through the process on [Mac]() or [Windows](). " %}

Start your command-line tool (e.g. Terminal on a Mac, or Git Bash on Windows), and enter:

```
npm i -g @platform-os/marketplace-kit
```

If your node is installed for all users you might need to use `sudo` to install npm packages globally:

```
sudo npm i -g @platform-os/marketplace-kit
```

You can follow the installation process in your command-line (something similar to this will be displayed during installation):

```
/usr/local/bin/marketplace-kit -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit
/usr/local/bin/marketplace-kit-env -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-env
/usr/local/bin/marketplace-kit-archive -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-archive
/usr/local/bin/marketplace-kit-env-add -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-env-add
/usr/local/bin/marketplace-kit-deploy -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-deploy
/usr/local/bin/marketplace-kit-env-list -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-env-list
/usr/local/bin/marketplace-kit-push -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-push
/usr/local/bin/marketplace-kit-sync -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-sync
/usr/local/bin/marketplace-kit-watch -> /usr/local/lib/node_modules/@platform-os/marketplace-kit/marketplace-kit-watch
+ @platform-os/marketplace-kit@1.0.5
added 88 packages in 6.719s
```

Use the following command to test the Marketplace Kit:

```
marketplace-kit -V
```

If the Marketplace Kit has been installed correctly, running this command displays the version of your Marketplace Kit. If the Marketplace Kit hasn't been installed, running this command gives a `command not found` error.

## Step 4: Create the Required Directory Structure

In order to correctly communicate with the Platform OS engine and API, your code base should be organized into a specific directory structure. The root directory of your project should contain the `marketplace_builder` directory. All directories other than the `marketplace_builder` will be ignored by the Marketplace Kit when deploying and syncing, so you can keep all your JS and CSS files outside of the `marketplace_builder` directory, and use any pre-processors you want to automatically generate the end result files in a proper path inside `marketplace_builder`.

You can create the required directory structure using the marketplace-kit.

    marketplace-kit init

{% include alert/note.html content="Make sure you invoke this command where you have permissions to create a directory." %}

Once you've installed the required directory structure, locate and explore it—this is how your code base for your Platform OS Instances should be organized. To learn more about the required directories and files, see [Platform OS Components]().

## Step 5: Change something and deploy your change

In this final step, you'll make a small change on your home page, and deploy it.

Locate the `home.liquid` file inside your marketplace directory (`marketplace_builder/views/pages/home.liquid`). Open it in a code editor of your choice, and change the text to anything you'd like to, but don't edit the first 3 lines:

```
---
slug: /
---
```

Save your changes.

Now, you have to authenticate your environment to be able to deploy your changes.

{% include alert/note.html content="Run all commands discussed in this tutorial in the project root directory, i.e. one level above the `marketplace_builder` directory" %}

To add your environment to the `.marketplace-kit` config file, run the `env add` command, and authenticate with your credentials:

```
marketplace-kit env add <environment> --email <your email> --url <your marketplace url>
```

To deploy all changes, run the `deploy` command:

```
marketplace-kit deploy <environment>
```

For example:

```
# deploy changes to staging
marketplace-kit deploy staging
```

Now, refresh your Instance in you browser, and you can see the change you made.

Congratulations! You have set up all the basic components you need for working with Platform OS, and successfully deployed your first site.

## Next steps

Delve into developing your site by following our step-by step [Get Started]() tutorials, or learn more about the concepts behind Platform OS in [How Platform OS Works]().

We are always happy to help with any questions you may have. Consult our [documentation](), [contact support](), or [connect with our sales team]().

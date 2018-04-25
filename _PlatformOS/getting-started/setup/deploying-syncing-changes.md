---
title: Deploying and Syncing Changes
permalink: /get-started/deploying-syncing-changes
---

This guide will help you deploy and sync changes you make in your code base to your Instance.

## Requirements

In order to deploy and sync changes to your Instance, you will need an Instance set up on our Partner Portal, and the Marketplace Kit installed on your computer. You will also need to have the code base for your Instance organized into the required directory structure—a way to set it up is by using the Blank Marketplace Module.

* [Setting Up a Site on Our Platform]()
* [Installing the Marketplace Kit]()
* [Creating the Required Directory Structure]()

## Steps

Deploying and syncing changes is a two-step process:

1.  Authenticate environments
2.  Deploy or sync changes

### Step 1: Authenticate environments

{% include alert/note.html content="Run all commands discussed in this tutorial in the project root directory, i.e. one level above the `marketplace_builder` directory" %}

Authentication is done with your **Partner Portal** account credentials.
See this [guide](https://github.com/mdyd-dev/nearme-documentation/blob/master/_PlatformOS/getting-started/setup/accessing-partner-portal.md) if you don't have Partner Portal account yet.

To add your environment to a config file, run the `env add` command, and authenticate with your **Partner Portal** credentials:

```
marketplace-kit env add <environment> --email <your email> --url <your marketplace url>
```

### Step 2: Deploy or sync changes

#### Deploying

To deploy all changes, run the `deploy` command:

```
marketplace-kit deploy <environment>
```

Example:

```
#deploy changes to staging
marketplace-kit deploy staging
```

We recommend to first deploy to staging, test, and only then trigger a deployment to production. In practice, deploy creates a zip file that contains all your files, and sends it to the API. It is then processed in the background. We store each zip file, so that you can roll back in case something goes wrong.

#### Syncing

To immediately push changes in your code base to the environment, run the `sync` command:

```
marketplace-kit sync <environment>
```

Example:

```
#sync changes to staging
marketplace-kit sync staging
```

Using the sync command feels like working on localhost. It is dangerous to use it on production (on a live site)—it is recommended to use it only for staging. Please note, that unlike deploy, this command will not delete resources when you delete the file.

#### Deploying and overriding

To deploy the whole `marketplace_builder` directory to environment overriding everything there was, use the `-f` flag. This will also remove files from the server that are not present in your currently deployed source directory.

```
marketplace-kit deploy <environment> -f
```

Example:

```
#deploy to and override everything on staging
marketplace-kit deploy staging -f
```

## Next steps

Congratulations! You can deploy and sync your code base to your Instance. Now you can delve into learning more about development on Platform OS.

* [Pages]()

## Questions?

We are always happy to help with any questions you may have. Consult our [documentation](), [contact support](), or [connect with our sales team]().

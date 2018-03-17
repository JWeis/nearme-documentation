---
title: Automatic sign in after sign up
permalink: /getting-started/users/sign-in-after-sign-up
---

This tutorial will show you how can you add automatic sign in to a signup form so new user will be logged in after account creation.

## Requirements

This tutorial assumes that you already have working Sign up form where user can create new account.

* [Sign up forms](./sign-up-forms)

## Steps

Automatic sign in after sign up is a three-step process:

* Add `callback_actions` key to Sign up form
* Create `user_session_create` graphql mutation
* Create `session_create_form` form

### Step 1: Add `callback_actions` key to Sign up form

In your `sign_up` form configuration add `callback_actions` at the end (order doesn't matter) of the YML definition.

##### form_configurations/sign_up.liquid

{% raw %}

```liquid
---
...
callback_actions: "{% execute_query user_session_create, email: @form.email, password: @form.password %}"
---
```

{% endraw %}

We are executing `user_session_create` query, so we need to create it.

### Step 2: Create `user_session_create` graphql mutation

This mutation takes two obligatory arguments: `email` and `password` - both strings.

##### graph_queries/user_session_create.graphql

```graphql
mutation user_session_create($email: String!, $password: String!) {
  user_session_create(
    form_configuration_name: "session_create_form" # must match with `name` of your form
    email: $email
    password: $password
  ) {
    email
  }
}
```

We are calling form called `session_create_form` with the same arguments we have received from the `callback_actions`.

Lets create that form now.

### Create `session_create_form` form

SessionForm is supported by the server, so you don't need to define anything - server will take care of handling user credentials and authenticate user.

##### form_configurations/session_create_form

```yml
---
name: session_create_form
base_form: SessionForm
---
```

## Next steps

Congratulations! You have automatic user login after sign up.

You can continue with adding other flow-control or informational features, example:

* [manual sign in](./authentication)
* [email notification to welcome your new user](../notifications/emails)
* [create redirection to an edit profile page instead of homepage after signup](../pages/redirects)
* flash message that will help user decide what to do

## Questions?

We are always happy to help with any questions you may have. Consult our [documentation](/), [contact support](), or [connect with our sales team]().

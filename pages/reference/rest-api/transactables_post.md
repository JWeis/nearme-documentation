---
title: Create a Transactable
permalink: /reference/rest-api/transactables_post
---

To create a transactable send a POST request to /api/user/transactables

**HTTP request**

POST /api/user/transactables

**Parameters**

| Parameter               | Type               | Description                                                                       | Required | Notes                      |
| ----------------------- | ------------------ | --------------------------------------------------------------------------------- | -------- | -------------------------- |
| form_configuration_name | String             | Name of the form configuration                                                    | Required | underscored                |
| form                    | TransactableForm   | TransactableForm parameters that corresponds with FormConfiguration configuration | Required |                            |
| parent_resource_id      | ID (Int or String) | Id or name of definced TransactableType                                           | Required | name should be underscored |

**Transactable Parameters**

{% include resources/TransactableForm.html %}

**Example request**

{% include reference/request_headers.md %}

```json
{
  "form_configuration_name": "reference_rest_api_create_transactable",
  "parent_resource_id": "boat",
  "form": {
    "name": "Boat"
    "creator_id": 1
  }
}
```

| Element                 | Type             | Description                                                                                | Required? |
| ----------------------- | ---------------- | ------------------------------------------------------------------------------------------ | --------- |
| form_configuration_name | String           | Name of the defined FormConfiguration                                                      | Required  |
| form                    | TransactableForm | Attributes for user, should match configuration defined in corresponding FormConfiguration | Required  |

**Example response**

{% include reference/response_headers.md %}

{% include reference/response_post_body.md %}

| Element                             | Type                                       | Description                                                    |
| ----------------------------------- | ------------------------------------------ | -------------------------------------------------------------- |
| [Element as it appears in response] | [Array, Object, String, Integer, or Float] | [Brief description of what information the element represents] |
| […]                                 | […]                                        | […]                                                            |

{% include reference/error_and_status_codes_post.md %}

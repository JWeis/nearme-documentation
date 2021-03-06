---
title: Delete Relationship Transactable
permalink: /reference/rest-api/relationship_transactables_delete
---

To remove relationship transactable, send a DELETE request to /api/user/relationship_transactables/:relationship_transactable_id

**HTTP request**

DELETE /api/transactable/relationship_transactables/:relationship_transactable_id

**Parameters**

| Parameter               | Type   | Description                    | Required | Notes |
| ----------------------- | ------ | ------------------------------ | -------- | ----- |
| form_configuration_name | String | Name of the form configuration | Required |       |

**Example request**

{% include reference/request_headers.md %}

```
{
  "form_configuration_name": "reference_rest_api_relationship_transactable_delete"
}
```

| Element                 | Type   | Description                           | Required? |
| ----------------------- | ------ | ------------------------------------- | --------- |
| form_configuration_name | String | Name of the defined FormConfiguration | Required  |

**Example response**

{% include reference/response_headers.md %}

```

```

| Element                             | Type                                       | Description                                                    |
| ----------------------------------- | ------------------------------------------ | -------------------------------------------------------------- |
| [Element as it appears in response] | [Array, Object, String, Integer, or Float] | [Brief description of what information the element represents] |
| […]                                 | […]                                        | […]                                                            |

{% include reference/error_and_status_codes_delete.md %}

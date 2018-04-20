---
title: Create a Bank Account
permalink: /reference/rest-api/bank_accounts_post
---

To create a bank_account send a POST request to /api/user/bank_accounts

**HTTP request**

POST /api/user/bank_accounts

**Parameters**

| Parameter               | Type            | Description                                                                      | Required | Notes       |
| ----------------------- | --------------- | -------------------------------------------------------------------------------- | -------- | ----------- |
| form_configuration_name | String          | Name of the form configuration                                                   | Required | underscored |
| form                    | BankAccountForm | BankAccountForm parameters that corresponds with FormConfiguration configuration | Required |             |

**Bank Account Parameters**

{% include resources/BankAccountForm.html %}

**Example request**

{% include reference/request_headers.md %}

```json
{
  "form_configuration_name": "reference_rest_api_bank_account_create",
  "form": {
    "payment_method_id": 1,
    "account_id": user.id,
    "public_token": "1234567"
  }
}
```

| Element                 | Type             | Description                                                                                | Required? |
| ----------------------- | ---------------- | ------------------------------------------------------------------------------------------ | --------- |
| form_configuration_name | String           | Name of the defined FormConfiguration                                                      | Required  |
| form                    | Bank AccountForm | Attributes for user, should match configuration defined in corresponding FormConfiguration | Required  |

**Example response**

{% include reference/response_headers.md %}

{% include reference/response_post_body.md %}

| Element                             | Type                                       | Description                                                    |
| ----------------------------------- | ------------------------------------------ | -------------------------------------------------------------- |
| [Element as it appears in response] | [Array, Object, String, Integer, or Float] | [Brief description of what information the element represents] |
| […]                                 | […]                                        | […]                                                            |

{% include reference/error_and_status_codes_post.md %}

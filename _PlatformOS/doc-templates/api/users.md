---
title: [USERS, users management, format: json, Create/Edit/Verify user]
permalink: [/api/users]
---
To [TITLE, e.g. update an image], [what the user should do, e.g. send a PUT request to /v2/images/$IMAGE_ID.]

**HTTP request wihtout authorization**

[POST] creates new user

[PUT] update current user (pre authorization required)


**Request parameters**

| Parameter               | Type   | Example Value | Description | Required |
|-------------------------|--------|---------------|-------------|----------|
| form_configuration_id   | Int    | 1        | Id of previously created UserForm object | unless form_configuration_name is set |
| form_configuration_name | String | new_user | custom name of the form                  | unless form_configuration_id is set   |
| object_id               | String | new      |                                          | true |
| form                    | JSON   | {}       | UserForm properties in JSON format       | true |

**User Form Predefined Properties**

Predefined properties are those that are already defined for all objects of UserForm type. You don't have to inlude them in configuration options. Please note that overwriting configuration for those properties can cause unexpected behavour of your form and can lead to internal application errors.  

| Parameter      | Type          | Description | Validation  | Notes    |
|----------------|---------------|-------------|-------------|----------|
| email          | String        | | presence, uniqueness, email format ||
| password       | String        | | Min 6 char| |
| external_id    | String        | | | Deprecated |
| id             | Int           | | | Deprecated |

**User Form Optional Properties**

| Parameter                       | Type              | Description  | Notes |
|---------------------------------|-------------------|--------------|------------------|
| accept_terms_of_service         |                   | | Deprecated |
| accept_emails                   | Boolean           | Enables email communication  | Default: true |
| avatar                          |                   | | Deprecated |
| banned_at                       | DateTime          | | Deprecated |
| click_to_call                   | Boolean           | Enables Click to Call functionality | Default: false
| cover_image                     |                   | | Deprecated |
| company_name                    |                   | | Deprecated |
| country_name                    |                   | | Deprecated |
| current_address                 | AddressForm       | link to AddressForm | |
| email                           | String            | Custom configuration for email Predefined Attribute | |
| featured                        |                   || Deprecated |
| first_name                      | String            | | |  
| feed_followed_transactable_ids  | Array[Integer]    | IDs of transactables followed by user ||
| feed_followed_user_ids          | Array[Integer]    | IDs of users followed by user ||
| feed_followed_topic_ids         | Array[Integer]    | IDs of topics followed by user  ||
| group_member_ids                | -                 || Deprecated
| last_name                       | String            |||
| language                        | String            | Translation library symbol |default: "en"
| name                            | String            |||
| middle_name                     | String            |||
| mobile_number                   | String            | Used for SMS Notifications ||
| phone                           | String            |||
| profiles                        | UserProfilesForm  | | |
| public_profile                  | Boolean           || Deprecated|
| password                        | String            | ||
| relationship_ids                | Array[Integer]    |||
| sms_notifications_enabled       | Boolean           | Enables sms communication | default: false|
| saved_searches_alerts_frequency |                   |||
| time_zone                       | String            | time zone used for converting logged in users time | Inherited from Instance configuration, if blank default is `Pacific Time (US & Canada)` |
| transactables                   | TransactablesForm ||||


**Example form configuration**

```
---
name: new_user
base_form: UserForm
configuration:
  password:
    validation:
      presence: true
  first_name:
    validation:
      presence: false
---
```


# Note to Diana
Next 2 paragraphs are typical for REST API. The problem is 98% of our API usage is not going to be REST so I am not sure if we want to document it here and now.
What is typical scenario is that we create a form as above that is API endpoint configuration - we defined what kind of Attributes should be accessible when a call to given FromConfiguration object is made.

**Example request**

[Example of a complete request for this endpoint, including header and body, followed by a table that lists each element in the example request]

```
curl -X POST https://staging-california.near-me.com/api/users.json \
  -H "Authorization: Token token=[YOUR-API-KEY]"\
  -H "Accept: application/vnd.nearme.v4+json"\
  -H "Content-Type: application/json"\
  -d \
  '
  {
    "form_configuration_name": "new_user",
    "object_id": "new",
    "object_class": "UserForm",
    "form": {
      "first_name": "Example",
      "email": "example@platformos.com",
      "password": "somepassword"
    }
  }
  '
```

see [Request parameters]() for explanation


**Example response**

```
{  
   "fields":{  
      "id":null,
      "tag_list":[  

      ],
      "email":"example@platformos.com",
      "external_id":null,
      "password":"somepassword",
      "first_name":"Example"
   },
   "model":{  
      "id":47448,
      "email":"example@platformos.com",
      "created_at":"2018-03-06T00:13:46.511Z",
      "updated_at":"2018-03-06T00:13:46.602Z",
      "name":"Example",
      "admin":null,
      "deleted_at":null,
      "authentication_token":"fK2f1x5dagFhSXn6tXVn",
      "avatar":{  
         "url":"",
         "transformed":{  
            "url":""
         },
         "thumb":{  
            "url":""
         },
         "medium":{  
            "url":""
         },
         "big":{  
            "url":""
         },
         "bigger":{  
            "url":""
         }
      },
      "phone":null,
      "country_name":null,
      "mobile_number":null,
      "notified_about_mobile_number_issue_at":null,
      "referer":null,
      "source":null,
      "campaign":null,
      "verified_at":null,
      "google_analytics_id":null,
      "browser":null,
      "browser_version":null,
      "platform":null,
      "avatar_transformation_data":{  

      },
      "avatar_original_url":null,
      "avatar_versions_generated_at":null,
      "avatar_original_height":null,
      "avatar_original_width":null,
      "current_location":null,
      "company_name":null,
      "slug":"example-47448",
      "last_geolocated_location_longitude":null,
      "last_geolocated_location_latitude":null,
      "partner_id":null,
      "instance_id":1,
      "domain_id":502,
      "time_zone":"UTC",
      "sms_notifications_enabled":false,
      "sms_preferences":{  
         "user_message":true,
         "reservation_state_changed":true,
         "new_reservation":true
      },
      "instance_unread_messages_threads_count":{  

      },
      "metadata":{  

      },
      "payment_token":null,
      "sso_log_out":false,
      "first_name":"Example",
      "middle_name":null,
      "last_name":null,
      "billing_address_id":null,
      "shipping_address_id":null,
      "seller_average_rating":0.0,
      "banned_at":null,
      "instance_profile_type_id":1,
      "old_properties":null,
      "reservations_count":0,
      "transactables_count":0,
      "buyer_average_rating":0.0,
      "public_profile":false,
      "accept_emails":true,
      "saved_searches_alerts_frequency":"daily",
      "language":"en",
      "saved_searches_count":0,
      "saved_searches_alert_sent_at":null,
      "left_by_seller_average_rating":0.0,
      "left_by_buyer_average_rating":0.0,
      "featured":false,
      "onboarding_completed":false,
      "cover_image":{  
         "url":"",
         "transformed":{  
            "url":""
         }
      },
      "cover_image_original_height":null,
      "cover_image_original_width":null,
      "cover_image_transformation_data":{  

      },
      "cover_image_original_url":null,
      "cover_image_versions_generated_at":null,
      "tutorial_displayed":false,
      "followers_count":0,
      "following_count":0,
      "external_id":null,
      "project_collborations_count":0,
      "click_to_call":false,
      "orders_count":0,
      "transactable_collaborators_count":0,
      "wish_list_items_count":0,
      "product_average_rating":0.0,
      "expires_at":null,
      "ui_settings":"{}",
      "accept_group_notifications":true,
      "accept_transactable_notifications":true,
      "properties":[  
         [  
            "gender",
            null
         ],
         [  
            "job_title",
            ""
         ],
         [  
            "drivers_licence_number",
            null
         ],
         [  
            "gov_number",
            null
         ],
         [  
            "skills_and_interests",
            null
         ],
         [  
            "biography",
            null
         ],
         [  
            "twitter_url",
            null
         ],
         [  
            "linkedin_url",
            null
         ],
         [  
            "facebook_url",
            null
         ],
         [  
            "google_plus_url",
            null
         ]
      ]
   },
   "mapper":{  
      "model":{  
         "id":47448,
         "email":"example@platformos.com",
         "created_at":"2018-03-06T00:13:46.511Z",
         "updated_at":"2018-03-06T00:13:46.602Z",
         "name":"Example",
         "admin":null,
         "deleted_at":null,
         "authentication_token":"fK2f1x5dagFhSXn6tXVn",
         "avatar":{  
            "url":"",
            "transformed":{  
               "url":""
            },
            "thumb":{  
               "url":""
            },
            "medium":{  
               "url":""
            },
            "big":{  
               "url":""
            },
            "bigger":{  
               "url":""
            }
         },
         "phone":null,
         "country_name":null,
         "mobile_number":null,
         "notified_about_mobile_number_issue_at":null,
         "referer":null,
         "source":null,
         "campaign":null,
         "verified_at":null,
         "google_analytics_id":null,
         "browser":null,
         "browser_version":null,
         "platform":null,
         "avatar_transformation_data":{  

         },
         "avatar_original_url":null,
         "avatar_versions_generated_at":null,
         "avatar_original_height":null,
         "avatar_original_width":null,
         "current_location":null,
         "company_name":null,
         "slug":"example-47448",
         "last_geolocated_location_longitude":null,
         "last_geolocated_location_latitude":null,
         "partner_id":null,
         "instance_id":1,
         "domain_id":502,
         "time_zone":"UTC",
         "sms_notifications_enabled":false,
         "sms_preferences":{  
            "user_message":true,
            "reservation_state_changed":true,
            "new_reservation":true
         },
         "instance_unread_messages_threads_count":{  

         },
         "metadata":{  

         },
         "payment_token":null,
         "sso_log_out":false,
         "first_name":"Example",
         "middle_name":null,
         "last_name":null,
         "billing_address_id":null,
         "shipping_address_id":null,
         "seller_average_rating":0.0,
         "banned_at":null,
         "instance_profile_type_id":1,
         "old_properties":null,
         "reservations_count":0,
         "transactables_count":0,
         "buyer_average_rating":0.0,
         "public_profile":false,
         "accept_emails":true,
         "saved_searches_alerts_frequency":"daily",
         "language":"en",
         "saved_searches_count":0,
         "saved_searches_alert_sent_at":null,
         "left_by_seller_average_rating":0.0,
         "left_by_buyer_average_rating":0.0,
         "featured":false,
         "onboarding_completed":false,
         "cover_image":{  
            "url":"",
            "transformed":{  
               "url":""
            }
         },
         "cover_image_original_height":null,
         "cover_image_original_width":null,
         "cover_image_transformation_data":{  

         },
         "cover_image_original_url":null,
         "cover_image_versions_generated_at":null,
         "tutorial_displayed":false,
         "followers_count":0,
         "following_count":0,
         "external_id":null,
         "project_collborations_count":0,
         "click_to_call":false,
         "orders_count":0,
         "transactable_collaborators_count":0,
         "wish_list_items_count":0,
         "product_average_rating":0.0,
         "expires_at":null,
         "ui_settings":"{}",
         "accept_group_notifications":true,
         "accept_transactable_notifications":true,
         "properties":[  
            [  
               "gender",
               null
            ],
            [  
               "job_title",
               ""
            ],
            [  
               "drivers_licence_number",
               null
            ],
            [  
               "gov_number",
               null
            ],
            [  
               "skills_and_interests",
               null
            ],
            [  
               "biography",
               null
            ],
            [  
               "twitter_url",
               null
            ],
            [  
               "linkedin_url",
               null
            ],
            [  
               "facebook_url",
               null
            ],
            [  
               "google_plus_url",
               null
            ]
         ]
      }
   },
   "_changes":{  
      "email":true,
      "password":true,
      "first_name":true
   },
   "errors":{  

   },
   "email_changed":true
}
```

| Element | Type | Description |
|-------------------------------------|--------------------------------------------|----------------------------------------------------------------|
| [Element as it appears in response] | [Array, Object, String, Integer, or Float] | [Brief description of what information the element represents] |
| […] | […] | […] |

**Error and Status Codes**

| Code | Message | Meaning |
|----------------------|---------------------------------------------|-----------------------------------------------------------|
| {"errors":{"email":["has already been taken"]}} |

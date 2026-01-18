# {{api_name}} API Reference

**Version:** {{version}}
**Base URL:** `{{base_url}}`

---

## Overview

{{api_description}}

## Authentication

{{authentication_method}}

**Example:**
```
Authorization: Bearer {{token_example}}
```

## Rate Limits

| Tier | Requests/Minute | Requests/Day |
|------|-----------------|--------------|
| Free | {{free_rate}} | {{free_daily}} |
| Pro | {{pro_rate}} | {{pro_daily}} |

---

## Endpoints

### {{resource_name}}

#### Create {{resource_name}}

Creates a new {{resource_name_lower}}.

**Request**

`POST {{endpoint_path}}`

**Headers:**
| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer token |
| Content-Type | Yes | application/json |

**Body Parameters:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| {{field_1}} | {{type_1}} | {{required_1}} | {{description_1}} |
| {{field_2}} | {{type_2}} | {{required_2}} | {{description_2}} |

**Example Request:**
```json
{
  "{{field_1}}": "{{example_value_1}}",
  "{{field_2}}": "{{example_value_2}}"
}
```

**Response**

**Success (201 Created):**
```json
{
  "id": "{{example_id}}",
  "{{field_1}}": "{{example_value_1}}",
  "{{field_2}}": "{{example_value_2}}",
  "createdAt": "{{example_timestamp}}"
}
```

**Errors:**
| Code | Description |
|------|-------------|
| 400 | Invalid request body |
| 401 | Authentication required |
| 403 | Insufficient permissions |
| 422 | Validation error |
| 500 | Internal server error |

---

#### Get {{resource_name}}

Retrieves a {{resource_name_lower}} by ID.

**Request**

`GET {{endpoint_path}}/{{id_param}}`

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| {{id_param}} | string | {{resource_name}} ID |

**Response**

**Success (200 OK):**
```json
{
  "id": "{{example_id}}",
  "{{field_1}}": "{{example_value_1}}",
  "{{field_2}}": "{{example_value_2}}",
  "createdAt": "{{example_timestamp}}",
  "updatedAt": "{{example_timestamp}}"
}
```

**Errors:**
| Code | Description |
|------|-------------|
| 401 | Authentication required |
| 404 | {{resource_name}} not found |

---

#### List {{resource_name_plural}}

Retrieves a paginated list of {{resource_name_lower_plural}}.

**Request**

`GET {{endpoint_path}}`

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | integer | 1 | Page number |
| limit | integer | 20 | Items per page (max 100) |
| sort | string | createdAt | Sort field |
| order | string | desc | Sort order (asc/desc) |

**Response**

**Success (200 OK):**
```json
{
  "data": [
    {
      "id": "{{example_id}}",
      "{{field_1}}": "{{example_value_1}}"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

---

#### Update {{resource_name}}

Updates an existing {{resource_name_lower}}.

**Request**

`PATCH {{endpoint_path}}/{{id_param}}`

**Body Parameters:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| {{field_1}} | {{type_1}} | No | {{description_1}} |
| {{field_2}} | {{type_2}} | No | {{description_2}} |

**Response**

**Success (200 OK):**
```json
{
  "id": "{{example_id}}",
  "{{field_1}}": "{{updated_value_1}}",
  "updatedAt": "{{example_timestamp}}"
}
```

---

#### Delete {{resource_name}}

Deletes a {{resource_name_lower}}.

**Request**

`DELETE {{endpoint_path}}/{{id_param}}`

**Response**

**Success (204 No Content)**

No response body.

---

## Error Format

All errors follow this format:

```json
{
  "error": {
    "code": "{{error_code}}",
    "message": "{{error_message}}",
    "details": [
      {
        "field": "{{field_name}}",
        "message": "{{field_error}}"
      }
    ]
  }
}
```

## Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| INVALID_REQUEST | 400 | Request body is malformed |
| UNAUTHORIZED | 401 | Missing or invalid authentication |
| FORBIDDEN | 403 | Insufficient permissions |
| NOT_FOUND | 404 | Resource does not exist |
| VALIDATION_ERROR | 422 | Request validation failed |
| RATE_LIMITED | 429 | Too many requests |
| INTERNAL_ERROR | 500 | Internal server error |

---

## SDKs and Libraries

- [JavaScript/TypeScript]({{sdk_js_url}})
- [Python]({{sdk_python_url}})
- [Go]({{sdk_go_url}})

## Support

- Documentation: {{docs_url}}
- Status Page: {{status_url}}
- Support Email: {{support_email}}

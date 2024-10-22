# Gitlab Apis'

# The below Script will enable the gitlab container registry cleanup policyy
```
- Keep the most recent: 10 tags per image name
- Keep tags matching: ^v\d+\.\d+\.\d+-rc$
- Remove tags older than: 60 days
- Remove tags matching: ^\d{8}$
```
```
curl --fail-with-body --request PUT --header 'Content-Type: application/json;charset=UTF-8' \
     --header "PRIVATE-TOKEN: " \
     --data-binary '{
       "container_expiration_policy_attributes": {
         "cadence": "1month",
         "enabled": true,
         "keep_n": 10,
         "older_than": "60d",
         "name_regex": ".*",
         "name_regex_keep": "^v\\d+\\.\\d+\\.\\d+-rc$",
         "name_regex_remove": "^\\d{8}$"
       }
     }' \
     "https://example.gitlab.com/api/v4/projects/<project-id>"
```
For multiple projects, use this script:-

```
#!/bin/bash

# Your GitLab access token
ACCESS_TOKEN="<your_access_token>"

# Array of project IDs
PROJECT_IDS=(123 456 789)

# Loop through each project ID and make the curl request
for PROJECT_ID in "${PROJECT_IDS[@]}"; do
    echo "Updating project ID: $PROJECT_ID"

    curl --fail-with-body --request PUT --header 'Content-Type: application/json;charset=UTF-8' \
         --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
         --data-binary '{
           "container_expiration_policy_attributes": {
             "cadence": "1month",
             "enabled": true,
             "keep_n": 10,
             "older_than": "60d",
             "name_regex": ".*",
             "name_regex_keep": "^v\\d+\\.\\d+\\.\\d+-rc$",
             "name_regex_remove": "^\\d{8}$"
           }
         }' \
         "https://gitlab.example.com/api/v4/projects/$PROJECT_ID"

    echo "Updated project ID: $PROJECT_ID"
done

```

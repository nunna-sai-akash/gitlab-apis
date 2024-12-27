#!/bin/bash

# Function to get GitLab group info
get_gitlab_group_info() {
    local group_id=$1  # The ID of the GitLab group
    local gitlab_token=$2  # The private token for GitLab API authentication
    local base_url="https://example.gitlab.com/api/v4"  # Base URL for GitLab API
    local headers="PRIVATE-TOKEN: $gitlab_token"  # Header for authentication

    # Get all subgroups of the group
    local subgroups_url="$base_url/groups/$group_id/subgroups"  # URL to fetch subgroups
    local subgroups_response=$(curl -s --header "$headers" "$subgroups_url")  # API call to get subgroups

    echo "Subgroups response: $subgroups_response"  # Print the response for debugging

    if [ $? -ne 0 ]; then  # Check if the curl command was successful
        echo "Error fetching subgroups"  # Print error message if curl failed
        return  # Exit the function
    fi

    if ! echo "$subgroups_response" | jq empty; then  # Check if the response is valid JSON
        echo "Invalid JSON response for subgroups: $subgroups_response"  # Print error message if JSON is invalid
        return  # Exit the function
    fi

    local subgroups=$(echo "$subgroups_response" | jq -c '.[]')  # Parse the subgroups from the JSON response

    # Iterate over each subgroup to get its projects
    echo "$subgroups" | while IFS= read -r subgroup; do  # Loop through each subgroup
        local subgroup_name=$(echo "$subgroup" | jq -r '.name')  # Extract the subgroup name
        local subgroup_id=$(echo "$subgroup" | jq -r '.id')  # Extract the subgroup ID
        echo "Subgroup: $subgroup_name (ID: $subgroup_id)"  # Print the subgroup name and ID

        # Get the projects for this subgroup
        local projects_url="$base_url/groups/$subgroup_id/projects"  # URL to fetch projects for the subgroup
        local projects_response=$(curl -s --header "$headers" "$projects_url")  # API call to get projects

        echo "Projects response for subgroup $subgroup_name: $projects_response"  # Print the response for debugging

        if [ $? -ne 0 ]; then  # Check if the curl command was successful
            echo "Error fetching projects for subgroup $subgroup_name"  # Print error message if curl failed
            continue  # Skip to the next subgroup
        fi

        if ! echo "$projects_response" | jq empty; then  # Check if the response is valid JSON
            echo "Invalid JSON response for projects: $projects_response"  # Print error message if JSON is invalid
            continue  # Skip to the next subgroup
        fi

        local projects=$(echo "$projects_response" | jq -c '.[]')  # Parse the projects from the JSON response

        # List each project in the subgroup
        echo "$projects" | while IFS= read -r project; do  # Loop through each project
            local project_name=$(echo "$project" | jq -r '.name')  # Extract the project name
            local project_id=$(echo "$project" | jq -r '.id')  # Extract the project ID
            local project_description=$(echo "$project" | jq -r '.description // "No description available"')  # Extract the project description
            echo "  Project Name: $project_name"  # Print the project name
            echo "  Project ID: $project_id"  # Print the project ID
            echo "  Project Description: $project_description"  # Print the project description
            echo "----------------------------------------"  # Print a separator
        done
    done
}

# Example Usage
group_id='01234'  # Example group ID - replace with your own group ID
gitlab_token='<access-api-token>'  # Example GitLab token - replace with your own token

get_gitlab_group_info $group_id $gitlab_token  # Call the function with example parameters

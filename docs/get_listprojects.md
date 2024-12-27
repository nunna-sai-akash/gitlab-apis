# get_listProjects.sh

This script retrieves and lists all projects within a specified GitLab group and its subgroups. It uses the GitLab API to fetch the necessary information and displays it in a readable format.

## Prerequisites

- `curl`: Command-line tool for transferring data with URLs.
- `jq`: Command-line JSON processor.

## Usage

Set the `group_id` and `gitlab_token` variables:

- `group_id`: The ID of the GitLab group you want to query.
- `gitlab_token`: Your GitLab private token for authentication.

Run the script:

```sh
./scripts/shell/get_listProjects.sh
```

## Example

```sh
group_id='01234'
gitlab_token='api-access-token'
./scripts/shell/get_listProjects.sh
```

## Script Details

### Functions

#### get_gitlab_group_info

Fetches and processes the subgroups and projects within a specified GitLab group.

**Parameters:**

- `group_id`: The ID of the GitLab group.
- `gitlab_token`: The GitLab private token.

**Example:**

```sh
get_gitlab_group_info $group_id $gitlab_token
```

### Workflow

#### Fetch Subgroups

The script fetches all subgroups of the specified group using the GitLab API.

**Example API URL:** `https://example.gitlab.com/api/v4/groups/$group_id/subgroups`

#### Fetch Projects

For each subgroup, the script fetches all projects.

**Example API URL:** `https://example.gitlab.com/api/v4/groups/$subgroup_id/projects`

#### Display Information

The script displays the name, ID, and description of each project.

### Error Handling

The script checks for errors in the API responses and invalid JSON responses. If an error occurs, it prints an error message and continues with the next subgroup or project.

### Example Output

```sh
Subgroup: Subgroup1 (ID: 12345)
  Project Name: Project1
  Project ID: 67890
  Project Description: This is a sample project.
----------------------------------------
  Project Name: Project2
  Project ID: 67891
  Project Description: No description available.
----------------------------------------
```

## Notes

- Ensure that your GitLab token has the necessary permissions to access the group and its subgroups.
- The script uses `jq` to parse JSON responses. Make sure `jq` is installed on your system.
- Please refer to:- [`get_listProjects.sh`](../scripts/shell/get_listProjects.sh)

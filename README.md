# git.corp identity checker

Checks for the identity of a git user before a commit is made, to prevent
committing as a non corporate identity (such as their public github account).

## Usage

- Clone the repo
- Alias `git` to `git.corp.sh`

`git.corp.sh` checks the `origin/master` ref of the local git repo for a
specified match (specified in your global git config). If a *corporate* repo is detected
it outputs a notice and sets the local user value for repo.

## Config

Set the following values:

    git config --global corp.org "value to grep for in .git/config to identify a corporate repo"
    git config --global corp.user "your username in the corporation"
    git config --global corp.email "your email in the corporation"

The `corp.org` supports multiple values to search for, separated by `;`, like `org1;org2`

## See also

[git-ssh](https://github.com/matthewhadley/git-ssh) to ensure your corp ssh key is used with git
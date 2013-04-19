# git.corp identity checker

Checks for the identity of a git user before a commit is made, to prevent
committing as a non corporate identity (such as their public github account).

## Usage

- Clone the repo
- Alias `git` to `git.corp.identity.sh`

`git.corp.identity` checks the `origin/master` ref of the local git repo for a
specified match (specified in your global git config). If a *corporate* repo is detected
it outputs a notice and sets the local user value for repo.

## Config

Set the following values:

    git config --global corp.org "value to grep for in .git/config to identify a corporate repo"
    git config --global corp.user "your username in the corporation"
    git config --global corp.email "your email in the corporation"
#!/bin/bash
# Check to see if committing to a git repo as corp user
if [ "$1" == "commit" ];then
  GIT_CORP_ORG=$(git config --global corp.org)
  if [ ! -z "$GIT_CORP_ORG" ]; then
    GIT_CORP_USER=$(git config --global corp.user)
    GIT_CORP_EMAIL=$(git config --global corp.email)
    CONFIG=$(git rev-parse --show-toplevel 2> /dev/null)

    IFS=';' read -ra ADDR <<< "$GIT_CORP_ORG"
    for i in "${ADDR[@]}"; do
      CORP_GIT=$(grep "${i}" ${CONFIG}/.git/config | wc -l)
      if [ "$CORP_GIT" -ge "1" ]; then
        if [ $(git config user.email) != "$GIT_CORP_EMAIL" ]; then
          echo -e "notice: corp repo detected," \
                  "updating local git user to be ${GIT_CORP_USER}"
          git config --local user.name "$GIT_CORP_USER"
          git config --local user.email "$GIT_CORP_EMAIL"
        fi
        break
      fi
    done
  fi
fi
exec git "$@"
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
        NOTICE="notice: corp repo detected\n"
        if [ $(git config user.email) != "$GIT_CORP_EMAIL" ]; then
          echo -e "${NOTICE}- updating local git user to be ${GIT_CORP_USER}"
          NOTICE=""
          git config --local user.name "$GIT_CORP_USER"
          git config --local user.email "$GIT_CORP_EMAIL"
        fi

        if [ ! -f "${CONFIG}/.git/hooks/commit-msg" ]; then
          echo -e "${NOTICE}- adding commit-msg hook"
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          cp "$DIR/commit-msg" "${CONFIG}/.git/hooks/"
          NOTICE=""
          echo ""
        fi

        break
      fi
    done
  fi
fi
exec git "$@"

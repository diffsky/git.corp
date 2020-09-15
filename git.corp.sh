#!/bin/bash
# Check to see if committing to a git repo as corp user
if [ "$1" == "commit" ];then
  GIT_CORP_ORG=$(git config --global corp.org)
  if [ -n "$GIT_CORP_ORG" ]; then
    GIT_CORP_EMAIL=$(git config --global corp.email)
    if ! CONFIG=$(git rev-parse --show-toplevel); then
      exit $?
    fi
    IFS=';' read -ra ADDR <<< "$GIT_CORP_ORG"
    for i in "${ADDR[@]}"; do
      CORP_GIT=$(grep -c "${i}" "${CONFIG}/.git/config")
      if [ "$CORP_GIT" -ge "1" ]; then
        GIT_CORP_USER=$(git config --global corp.user)
        if [[ $(git config user.name) != "$GIT_CORP_USER" || $(git config user.email) != "$GIT_CORP_EMAIL" ]]; then
          echo -e "notice: corp repo detected"
          echo -e "updating local git user to be ${GIT_CORP_USER}"
          git config --local user.name "$GIT_CORP_USER"
          git config --local user.email "$GIT_CORP_EMAIL"
        fi

        if [ ! -f "${CONFIG}/.git/hooks/commit-msg" ]; then
          echo -e "- adding commit-msg hook"
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          cp "$DIR/commit-msg" "${CONFIG}/.git/hooks/"
        fi

        break
      else
        GIT_USER=$(git config --global personal.user)
        GIT_EMAIL=$(git config --global personal.email)
        if [[ $(git config user.name) != "$GIT_USER" || $(git config user.email) != "$GIT_EMAIL" ]]; then
          echo -e "notice: non-corp repo detected"
          echo -e "- updating local git user to be ${GIT_USER}"
          git config --local user.name "$GIT_USER"
          git config --local user.email "$GIT_EMAIL"
        fi
      fi
    done
  fi
fi
exec git "$@"

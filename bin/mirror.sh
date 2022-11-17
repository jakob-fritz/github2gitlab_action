#!/bin/sh

set -u
##################################################################
urlencode() (
    i=1
    max_i=${#1}
    while test $i -le $max_i; do
        c="$(expr substr $1 $i 1)"
        case $c in
            [a-zA-Z0-9.~_-])
		printf "$c" ;;
            *)
		printf '%%%02X' "'$c" ;;
        esac
        i=$(( i + 1 ))
    done
)

##################################################################
DEFAULT_POLL_TIMEOUT=10
POLL_TIMEOUT=${POLL_TIMEOUT:-$DEFAULT_POLL_TIMEOUT}

# git checkout "${GITHUB_REF_NAME}"

branch="+refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/* +refs/pull/*:refs/heads/pull/*"
# branch_uri="$(urlencode ${branch})"

sh -c "pwd"
# Removing all cached credentials
sh -c "git credential-cache exit"
sh -c "git config --global --unset-all credential.username"
sh -c "git config --global --unset-all core.askPass"
# sh -c "git config --global credential.helper cache"
echo "length of username: "
echo -n ${GITLAB_USERNAME} | wc -c
echo "length of token: "
echo -n ${GITLAB_TOKEN} | wc -c
echo "adding gitlab-repo as remote"
git remote add gitlab "https://${GITLAB_USERNAME}:${GITLAB_TOKEN}@${GITLAB_REPO_URL}"
# sh -c "git remote add gitlab $GITLAB_REPO_URL"
sh -c "git fetch --force origin +refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/*"
sh -c "git fetch origin +refs/pull/*:refs/heads/pull/*"
# sh -c "echo pushing to $branch branch at $(git remote get-url --push gitlab)"
if [ "${FORCE_PUSH:-}" = "true" ]
then
  sh -c "git push --prune --force gitlab $branch"
else
  sh -c "git push --prune gitlab $branch"
fi

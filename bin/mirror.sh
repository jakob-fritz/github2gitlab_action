#!/bin/sh

set -u
##################################################################
DEFAULT_POLL_TIMEOUT=10
POLL_TIMEOUT=${POLL_TIMEOUT:-$DEFAULT_POLL_TIMEOUT}


branch="+refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/* +refs/pull/*:refs/heads/pull/*"

# sh -c "pwd"
# Removing all cached credentials
# sh -c "git credential-cache exit"
# sh -c "git config --global --unset-all credential.username"
# sh -c "git config --global --unset-all core.askPass"
# sh -c "git config --global credential.helper cache"
# echo "length of username: "
# echo -n ${GITLAB_USERNAME} | wc -c
# echo "length of token: "
# echo -n ${GITLAB_TOKEN} | wc -c
echo "adding gitlab-repo as remote"
git remote add gitlab "https://${GITLAB_USERNAME}:${GITLAB_TOKEN}@${GITLAB_REPO_URL}"
# sh -c "git remote add gitlab $GITLAB_REPO_URL"
sh -c "git fetch --force origin +refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/* +refs/pull/*:refs/heads/pull/*"
# sh -c "git fetch origin +refs/pull/*:refs/heads/pull/*"
# sh -c "echo pushing to $branch branch at $(git remote get-url --push gitlab)"
if [ "${FORCE_PUSH:-}" = "true" ]
then
  sh -c "git push --prune --force gitlab $branch"
else
  sh -c "git push --prune gitlab $branch"
fi

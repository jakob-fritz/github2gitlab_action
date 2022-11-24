#!/bin/sh

set -u
##################################################################
DEFAULT_POLL_TIMEOUT=10
POLL_TIMEOUT=${POLL_TIMEOUT:-$DEFAULT_POLL_TIMEOUT}


branch="+refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/* +refs/pull/*:refs/heads/pull/*"

echo "adding gitlab-repo as remote"
git remote add gitlab "https://TOKENUSER:${GITLAB_TOKEN}@${GITLAB_REPO_URL}"
sh -c "git fetch --force origin +refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/* +refs/pull/*:refs/heads/pull/*"
# sh -c "git fetch origin +refs/pull/*:refs/heads/pull/*"
# sh -c "echo pushing to $branch branch at $(git remote get-url --push gitlab)"
if [ "${FORCE_PUSH:-}" = "true" ]
then
  sh -c "git push --prune --force gitlab $branch"
else
  sh -c "git push --prune gitlab $branch"
fi

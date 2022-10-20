#!/bin/sh

sh -c "git config --global credentials.username $GITLAB_USERNAME"
sh -c "git config --global core.askPass /getpasswd.sh"
sh -c "git config --global credential.helper cache"
sh -c "git remote add gitlab $GITLAB_REPO_URL"
sh -c "echo pushing to $branch branch at $(git remote get-url --push mirror)"
sh -c "git push --force gitlab $branch"

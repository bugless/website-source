#!/bin/bash
set -euo pipefail

function log {
  echo -e "\033[0;32m$1\033[0m"
}

log "Checking out master"

git checkout master
git pull origin master

log "Init/updating git submodules"

git submodule init && git submodule update

cd public
git checkout master
cd ..

log "Deploying updates to GitHub..."

# Build the project.
hugo

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..

log "Commiting submodule version to master"

git add public
git commit -m "$msg"
git push

#!/bin/sh

# Update a specific branch to include content from specific directory
BRANCH='gh-pages'
DIRECTORY='gh-pages'
BRANCH_SHA=$(git show-ref -s refs/heads/${BRANCH})
DIRECTORY_SHA=$(git ls-tree -d HEAD ${DIRECTORY} | awk '{print $3}')
COMMIT=$(echo 'Auto-update.' | git commit-tree ${DIRECTORY_SHA} -p ${BRANCH_SHA})
git update-ref refs/heads/${BRANCH} ${COMMIT}

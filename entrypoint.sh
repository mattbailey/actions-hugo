#!/usr/bin/env sh

set -e

echo "Setting up git"
[ -z "${GITHUB_TOKEN}" ] && \
  (echo "ERROR: Missing GITHUB_TOKEN." ; exit 1)
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

echo "Deleting old publication"
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo "$@"

echo "Updating gh-pages branch"
cd public && git add --all && git commit -am "Publishing to gh-pages (mattbailey/actions-hugo)."
git push --all

echo "Triggering second commit (for some gh-pages builds, two commits are required)."
date -u > last_deploy.txt
git add last_deploy.txt
git commit -am "Second commit trigger for gh-pages bug."
git push

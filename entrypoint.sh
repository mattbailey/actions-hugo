#!/usr/bin/env sh

set -e

echo "Setting safe workspace directory"
git config --global --add safe.directory /github/workspace

echo "Generating site"
hugo "$@"

[ "${GITHUB_EVENT_NAME}" == "pull_request" ] && \
  (echo "WARN: not deploying on pull_request" ; exit 0)

echo "Setting up git"
[ -z "${GITHUB_TOKEN}" ] && \
  (echo "ERROR: Missing GITHUB_TOKEN." ; exit 1)
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
echo "machine github.com login ${GITHUB_ACTOR} password ${GITHUB_TOKEN}" > ~/.netrc

echo "cloning"
git clone --depth=1 --single-branch --branch gh-pages https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git /tmp/gh-pages

echo "copying"
rm -rf /tmp/gh-pages/*
cp -av public/* /tmp/gh-pages/

echo "commit & push"
cd /tmp/gh-pages
git add -A && git commit --allow-empty -am "Publishing from mattbailey/actions-hugo ${GITHUB_SHA}"
git push

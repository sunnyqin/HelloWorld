#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

echo "********************"
echo "*    fastlane      *"
echo "********************"

# Travis fetches a shallow clone. We use commit count until HEAD for build number. In order to assure that the count is correct we have to `unshallow` Travis' clone.
git fetch --unshallow
gem update fastlane
fastlane beta
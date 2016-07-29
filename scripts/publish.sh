#/bin/sh

set -o errexit -o nounset

if [ "$TRAVIS_REPO_SLUG" = "patternfly/patternfly" ]
then
  echo "This build is running against patternfly/patternfly."
  if [ -z "$TRAVIS_TAG" -a "$TRAVIS_BRANCH" != "master" ]
  then
    echo "This commit was made against $TRAVIS_BRANCH and not the master or tag! Do not deploy!"
    exit 1
  fi
fi

# User info
git config user.name "Admin"
git config user.email "patternfly@redhat.com"
git config --global push.default simple

# Add upstream authentication token
git remote add upstream https://$AUTH_TOKEN@github.com/$TRAVIS_REPO_SLUG.git

# Commit generated files
git add dist --force
git commit -m "Added files generated by Travis build"

# Push to dist branch
git push upstream $TRAVIS_BRANCH:$TRAVIS_BRANCH-dist --force -v

exit $?
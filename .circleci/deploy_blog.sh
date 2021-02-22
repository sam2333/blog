#!/bin/bash

# hugo env
export HUGO_HOME=/tmp/hugo/
export PATH=$PATH:$HUGO_HOME

# generate public resources
hugo

# public source dir
cd public

# git config
git init
git config user.name ${GIT_USERNAME}
git config user.email ${GIT_EMAIL}
git config --global push.default simple

# add all files
git add -A .

# mock commit date
THIS_YEAR=`date '+%Y'`
MOCK_YEAR=`expr $THIS_YEAR - 4`
MOCK_DATE="`date '+%b %d %H:%M:%S'` $MOCK_YEAR +0000"

# commit and push
git commit --date="${MOCK_DATE}" -m "update blog from CircleCI"
git push --quiet -f "https://${GITHUB_TOKEN}@github.com/samsuse/blog.git" master:gh-pages

echo Publish blog to gh-pages successfully

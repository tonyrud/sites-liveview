#!/bin/bash


export CODEBUILD_GIT_BRANCH=`git symbolic-ref HEAD --short`
echo "==> CODEBUILD_GIT_BRANCH = $CODEBUILD_GIT_BRANCH "
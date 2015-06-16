#!/bin/bash

set -x
set -e

start_dir=$(pwd)

VRCODEBASE_GIT_URL='https://github.com/sanger-pathogens/vr-codebase.git'

# Make an install location
if [ ! -d 'git_repos' ]; then
  mkdir git_repos
fi
cd git_repos

git clone $VRCODEBASE_GIT_URL

#Add lovations to PERL5LIB
VRCODEBASE_LIB=${start_dir}'/git_repos/vr-codebase/modules'
SELF_LIB=${start_dir}'/modules'

export PERL5LIB=${VRCODEBASE_LIB}:${SELF_LIB}:$PERL5LIB

cd $start_dir

set +eu
set +x

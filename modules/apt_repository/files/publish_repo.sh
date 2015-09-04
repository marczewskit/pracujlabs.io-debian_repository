#!/bin/bash

repo_name=$1
repo_architecture=$2

text_to_find="[$repo_name]"
repos="$(/usr/bin/aptly publish list)"

if [[ $repos == *"$text_to_find"* ]]
then
  #do nothing - already published
  echo 0;
else
  /usr/bin/aptly -architectures=$repo_architecture -skip-signing=true publish repo $repo_name
fi
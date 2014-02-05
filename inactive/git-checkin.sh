#! /bin/bash
# script that should check in a single file given as ARGV[1] to the git repo at 
# string ARGV[2]
initialdir=$(pwd)
cd $2
git add "$1"
cd $initialdir

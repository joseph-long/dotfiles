#!/bin/bash
if [ $(command -v fortune) ]; then
  echo
  number=$RANDOM
  let "number %= 2"
  if [ "$number" -eq 1 ]; then
    fortune
  else
    fortune oblique
  fi
fi
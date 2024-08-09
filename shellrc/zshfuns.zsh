#!/usr/bin/env zsh

# Read paths from input, zsh and bash are different, so we need to define this function.
function read_paths() {
    IFS=': ' read -r -A paths <<< "$@"
}
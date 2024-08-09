#!/bin/bash

# Read paths from input, zsh and bash are different, so we need to define this function.
function read_paths() {
    IFS=': ' read -r -a paths <<< "$@"
}
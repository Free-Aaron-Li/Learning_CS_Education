#!/usr/bin/env bash

file_path=$(cat ~/.path)
cd "$file_path" || exit
rm ~/.path
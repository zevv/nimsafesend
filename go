#!/bin/sh

set -e
set -x

nim c --verbosity:0 -d:usemalloc --mm:arc -d:danger main.nim && valgrind --quiet --tool=helgrind ./main 
nim c --verbosity:0 -d:usemalloc --mm:orc -d:danger main.nim && valgrind --quiet --tool=helgrind ./main 
nim c --verbosity:0 -d:usemalloc --mm:arc -d:danger main.nim && valgrind --quiet ./main 
nim c --verbosity:0 -d:usemalloc --mm:orc -d:danger main.nim && valgrind --quiet ./main 
nim c --verbosity:0 --mm:arc -d:danger main.nim && valgrind --quiet --tool=helgrind ./main 
nim c --verbosity:0 --mm:orc -d:danger main.nim && valgrind --quiet --tool=helgrind ./main 
nim c --verbosity:0 --mm:arc -d:danger main.nim && valgrind --quiet ./main 
nim c --verbosity:0 --mm:orc -d:danger main.nim && valgrind --quiet ./main 

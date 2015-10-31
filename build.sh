#!/bin/sh
set -e

git submodule update --recursive --init

# Official Microsoft/TypeScript clone
cd ./TypeScript

git clean -xfd
git fetch origin
git reset --hard origin/master

# Fix jakefile to expose the internal APIs to service
< Jakefile.js > Jakefile.new.js sed -E "s/\*stripInternal\*\/ true/\*stripInternal\*\/ false/"
mv Jakefile.new.js Jakefile.js

# Install jake and everything else
npm install

# Build once to get a new LKG
./node_modules/.bin/jake release LKG --trace

# Update bin/lib
rm -R ../lib
mkdir ../lib
cp ./built/local/* ../lib/

rm -R ../bin
mkdir ../bin
cp ./bin/* ../bin/

# Reset sub typescript
git clean -xfd
git reset --hard origin/master
cd ..

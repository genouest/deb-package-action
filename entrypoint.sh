#!/bin/bash

set -e
version=`dpkg-parsechangelog --show-field Version`

apt-get update && apt-get -y install devscripts git-buildpackage
mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' debian/control
mkdir -p ../build-area
rm ../build-area/*.deb
echo y | gbp buildpackage --git-ignore-branch --no-sign --git-export-dir=../build-area --git-no-create-orig
cp ../build-area/*.deb ./
ls -l *.deb
echo ::set-output name=debversion::$version
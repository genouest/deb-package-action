#!/bin/bash

set -e

echo "deb http://deb.debian.org/debian/ stable main contrib" > /etc/apt/sources.list && rm /etc/apt/sources.list.d/debian.sources
apt-get update && apt-get -y install devscripts git-buildpackage
sourceversion=`dpkg-parsechangelog --show-field Version | cut -d'-' -f1`
version=`dpkg-parsechangelog --show-field Version`
package=`dpkg-parsechangelog --show-field Source`


mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' debian/control

mkdir -p ../build-area

echo "create source tarball"
mkdir -p /tmp/${package}_${sourceversion}.orig
cp -a . /tmp/${package}_${sourceversion}.orig/
rm -rf /tmp/${package}_${sourceversion}.orig/.git
rm -rf /tmp/${package}_${sourceversion}.orig/debian
tar cvfz ../build-area/${package}_${sourceversion}.orig.tar.gz -C /tmp ${package}_${sourceversion}.orig
rm -rf /tmp/${package}_${sourceversion}.orig

echo "build package"
rm *.deb *.buildinfo *.changes

ls -lha
sh -c "git config --global --add safe.directory $PWD"
git status


echo y | gbp buildpackage --git-ignore-branch --no-sign --git-export-dir=../build-area --git-no-create-orig
cp ../build-area/*.deb ./
ls -l *.deb
echo ::set-output name=debversion::$version

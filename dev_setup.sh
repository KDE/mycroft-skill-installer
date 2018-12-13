#!/usr/bin/env bash

# exit on any error
set -Ee

# Enter the directory that contains this script file
cd $(dirname $0)
TOP=$( pwd -L )

# Installation
sudo apt-get install qml-module-qmltermwidget
if [[ ! -d build-testing ]] ; then
   mkdir build-testing
fi
cd build-testing
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release   -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
make -j4
sudo make install

echo "Installation complete!"
echo "To run, invoke:  MycroftSkillInstaller"

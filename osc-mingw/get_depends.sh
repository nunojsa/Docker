#!/bin/bash

rm -rf iio-osc-x86_64-build-deps.tar.xz sysroot-i686 iio-osc-i686-build-deps.tar.xz sysroot-x86_64
wget https://github.com/analogdevicesinc/iio-osc-mingw/releases/latest/download/iio-osc-x86_64-build-deps.tar.xz > /dev/null 2>&1
tar -xf iio-osc-x86_64-build-deps.tar.xz

wget https://github.com/analogdevicesinc/iio-osc-mingw/releases/latest/download/iio-osc-i686-build-deps.tar.xz > /dev/null 2>&1
tar -xf iio-osc-i686-build-deps.tar.xz

exec $@

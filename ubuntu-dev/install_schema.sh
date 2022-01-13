#!/bin/bash

export PATH=$PATH:$HOME/.local/bin
pip3 install git+https://github.com/devicetree-org/dt-schema.git@master

exec $@

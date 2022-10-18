#!/bin/bash -eux

./configure
make -j$(nproc)

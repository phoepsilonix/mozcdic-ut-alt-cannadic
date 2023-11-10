#!/bin/bash

# Author: UTUMI Hirosi (utuhiro78 at yahoo dot co dot jp)
# License: Apache License, Version 2.0

ruby convert_alt_cannadic_to_mozcdic.rb

mkdir -p ../release
tar cjf ../release/mozcdic-ut-alt-cannadic.txt.tar.bz2 mozcdic-ut-alt-cannadic.txt

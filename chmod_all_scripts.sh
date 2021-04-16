#!/bin/bash
for file in $(find . -iname "*.sh")
do
chmod +x $file
done

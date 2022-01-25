#!/bin/bash

qctool=/fullpath/qctool

for i in {1:22} X
do
  ${qctool} -g ${i}.bgen -s ${i}.sample -incl-samples trace_element_fid.txt -bgen-bits 8 -og ${i}_subset.bgen -os ${i}_subset.sample -log ${i}_subset.log
done

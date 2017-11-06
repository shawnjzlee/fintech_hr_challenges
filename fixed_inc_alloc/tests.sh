#!/bin/bash
for i in {00..09}
  do ruby ./fixed_inc_alloc.rb $i
  echo "=================="
done
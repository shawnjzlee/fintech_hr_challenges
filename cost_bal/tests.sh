#!/bin/bash
for i in {00..15}
  do ruby ./cost_bal.rb $i
  echo "=================="
done
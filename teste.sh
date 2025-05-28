#!/usr/bin/env bash
while IFS= read -r line || [[ -n $line ]]; do
  echo "Linha: [$line]"
done < resources.txt

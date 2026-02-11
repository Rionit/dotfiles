#!/usr/bin/env bash

PORT=10000

nc 127.0.0.1 $PORT | while read -r line; do
    case "$line" in
        *base*)      echo "base" ;;   
        *gaming*)    echo "gaming" ;;   
        *navigation*) echo "navigation" ;; 
    esac
done


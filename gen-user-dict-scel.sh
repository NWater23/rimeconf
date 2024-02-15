#!/usr/bin/bash
echo "---
name: ${1%.dict.yaml}
version: \"$(date)\"
sort: by_weight
use_preset_vocabulary: true
import_tables:" > $1
printf '  - %s\n' "$2"/*.yaml >> $1
echo "...
" >> $1
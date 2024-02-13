#!/usr/bin/bash
echo "---
name: ${1%.dict.yaml}
version: \"$(date)\"
sort: by_weight
use_preset_vocabulary: true
...
" > $1
cat $2/*.txt >> $1
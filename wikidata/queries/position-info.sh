#!/bin/bash

POSITIONS=$(mktemp)
RESULTS=$(mktemp)

qsv cat rows wikidata/*positions.csv | qsv select position | qsv search "^Q" | qsv dedup | qsv behead > $POSITIONS

cat $POSITIONS | xargs wd sparql wikidata/templates/position-info.js -f csv > $RESULTS
sed -e 's#http://www.wikidata.org/entity/##g' -e 's/T00:00:00Z//g' \
  -e 's|http://www.wikidata.org/.well-known/genid/[[:alnum:]]*|<noval>|g' $RESULTS > wikidata/results/position-info.csv

cat $POSITIONS | xargs wd sparql wikidata/templates/aliases.js -f csv |
  sed -e 's%http://www.wikidata.org/entity/%%' |
  qsv rename position,title > wikidata/results/position-aliases.csv

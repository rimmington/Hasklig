#!/bin/bash -e

family=Hasklig
romanWeights='Black ExtraLight Regular'
italicWeights='BlackIt BoldIt ExtraLightIt LightIt MediumIt It SemiboldIt'

# path to Python script that adds the SVG table
addSVG=$(cd $(dirname "$0") && pwd -P)/addSVGtable.py

# clean existing build artifacts
rm -rf target/
otfDir="target/"
mkdir -p $otfDir

# Copy Regular glyphs
cp RegularGlyphs/* Roman/Regular/font.ufo/glyphs/
checkOutlinesUFO -e Roman/Regular/font.ufo/
autohint -q Roman/Regular/font.ufo/

for w in $romanWeights
do
  makeotf -f Roman/$w/font.ufo -r -o $otfDir/$family-$w.otf
  rm Roman/$w/current.fpr # remove default options file from the source tree after building
  "$addSVG" $otfDir/$family-$w.otf svg
done

echo 'Not making italic fonts'
exit 0

for w in $italicWeights
do
  makeotf -f Italic/$w/font.ufo -r -o $otfDir/$family-$w.otf
  rm Italic/$w/current.fpr # remove default options file from the source tree after building
  "$addSVG" $otfDir/$family-$w.otf svg
done

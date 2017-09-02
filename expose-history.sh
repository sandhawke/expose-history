#!/bin/sh

# quick and dirty for now...

root=activitystreams
hisdir=$root-history
mkdir -p $histdir

# should work okay over several suffixes, but Overview.html might need some work
suffix=.jsonld

file=$root$suffix
tags=`cvs log $file | grep '^revision' | cut -b 10-`

cat <<EOF > $histdir/Overview.html
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xht
ml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head><title>Document Version History</title></head><body>
<h2>Document Versions</h2>
EOF

for tag in $tags; do
  out=$histdir/v$tag$suffix
  echo checking out $out
  cvs -Q update -p -r $tag $file > $out
  hash=sha256hex-`sha256sum $out | cut -c 1-64`
  cp -a $out $histdir/$hash$suffix

  echo "<p><a href=\"v$tag$suffix\">v$tag$suffix</a> or <a href=\"$hash$suffix\">$hash$suffix</a></p>" >> $histdir/Overview.html  
done

cat <<EOF >> $histdir/Overview.html
</body></html>
EOF

# cvs add $histdir/*.*
# cvs commit -mgenerated $histdir/*.*



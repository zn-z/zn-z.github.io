#!/bin/bash

ncol=4
libdir=$HOME/Pictures/hp/lib
htmldir=$HOME/Pictures/hp/html
for tag in $(cut -f5 $libdir/desc.tsv| awk '!a[$0]++'); do
  cat $libdir/desc.tsv| awk -F"\t" -v ncol=$ncol -v tag="$tag" '
  BEGIN {
    print "<!DOCTYPE html>"
    print "<html lang=\"ja\">"
    print "  <head>"
    print "    <meta charset=\"utf-8\">"
    print "    <title>My Tabi</title>"
    print "    <link rel=\"shortcut icon\" href=\"../icon/favicon.ico\">"
    print "    <link rel=\"stylesheet\" href=\"../css/lightbox.min.css\">"
    print "    <link rel=\"stylesheet\" href=\"../css/style.css\">"
    print "  </head>"
    print "  <body>"
    print "    <section>"
    print "      <h1>@ "tag"</h1>"
  } $5 == tag {
    $4 = "../"$4
    n++
    link = link"__SEP__"$4
    desc = desc"__SEP__"$3
  } END {
    sub("__SEP__", "", link)
    sub("__SEP__", "", desc)
    
    amari = n % ncol
    baseRow = int(n / ncol)
    for (i=1; i<=ncol; i++) {
      row[i] = baseRow
      if (i<=amari) row[i]++
    }
    
    print "      <div class=\"gallery\">"
    c = split(link, linkArray, "__SEP__")
        split(desc, descArray, "__SEP__")
    rowStart = 1
    for (i=1; i<=ncol; i++) {
      print "        <div class=\"gallery__column\">"
      rowEnd = rowStart + row[i] - 1
      for (j=rowStart; j<=rowEnd; j++) {
        print "          <a href=\""linkArray[j]"\" data-lightbox=\""tag"\" data-title=\""descArray[j]"\" class=\"gallery__link\">"
        print "            <figure class=\"gallery__thumb\">"
        print "              <img src=\""linkArray[j]"\" class=\"gallery__image\">"
        print "              <figcaption class=\"gallery__caption\">"descArray[j]"</figcaption>"
        print "            </figure>"
        print "          </a>"
      }
      print "        </div>"
      rowStart = rowEnd + 1
    }
    print "      </div>"
    print "    </section>"
    print "    <script src=\"../js/lightbox-plus-jquery.min.js\"></script>"
    print "    <script>"
    print "      lightbox.option({"
    print "        \"imageFadeDuration\": 0,"
    print "        \"wrapAround\": true,"
    print "        \"disableScrolling\": true"
    print "      })"
    print "    </script>"
    print "  </body>"
    print "</html>"
  }' > $htmldir/$tag.html
done

#!/bin/bash

ncol=5
cat $libdir/desc.tsv| awk -F"\t" -v ncol=$ncol '
BEGIN {
  print "<!DOCTYPE html>"
  print "<html lang=\"ja\">"
  print "  <head>"
  print "    <meta charset=\"utf-8\">"
  print "    <title>My Tabi</title>"
  print "    <link rel=\"stylesheet\" href=\"css/lightbox.min.css\">"
  print "    <link rel=\"stylesheet\" href=\"css/style.css\">"
  print "  </head>"
  print "  <body>"
  print "    <section>"
} {
  gsub("/Users/zou/Pictures/hp", "https://raw.githubusercontent.com/zn-z/zn-z.github.io/main", $6)
  if ($5 == "new") {
    n["new"]++
    link["new"] = link["new"]"__SEP__"$4
    desc["new"] = desc["new"]"__SEP__"$3
  } else {
    n["old"]++
    link["old"] = link["old"]"__SEP__"$4
    desc["old"] = desc["old"]"__SEP__"$3
  }
} END {
  sub("__SEP__", "", link["new"])
  sub("__SEP__", "", desc["new"])
  sub("__SEP__", "", link["old"])
  sub("__SEP__", "", desc["old"])
  
  amari["new"] = n["new"] % ncol
  amari["old"] = n["old"] % ncol
  baseRow["new"] = int(n["new"] / ncol)
  baseRow["old"] = int(n["old"] / ncol)
  
  for (i=1; i<=ncol; i++) {
    newRow[i] = baseRow["new"]
    if (i<=amari["new"]) newRow[i]++
    oldRow[i] = baseRow["old"]
    if (i<=amari["old"]) oldRow[i]++
  }
  
  if (n["new"] > 0) {
    print "      <div class=\"gallery\">"
    c = split(link["new"], newLink, "__SEP__")
        split(desc["new"], newDesc, "__SEP__")
    rowStart = 1
    for (i=1; i<=ncol; i++) {
      print "        <div class=\"gallery__column\">"
      rowEnd = rowStart + newRow[i] - 1
      for (j=rowStart; j<=rowEnd; j++) {
        print "          <a href=\""newLink[j]"\" data-lightbox=\"new\" data-title=\""newDesc[j]"\" class=\"gallery__link\">"
        print "            <figure class=\"gallery__thumb\">"
        print "              <img src=\""newLink[j]"\" class=\"gallery__image\">"
        print "              <figcaption class=\"gallery__caption\">"newDesc[j]"</figcaption>"
        print "            </figure>"
        print "          </a>"
      }
      print "        </div>"
      rowStart = rowEnd + 1
    }
    print "      </div>"
    print "      <hr />"
  }
  print "      <div class=\"gallery\">"
  c = split(link["old"], oldLink, "__SEP__")
      split(desc["old"], oldDesc, "__SEP__")
  rowStart = 1
  for (i=1; i<=ncol; i++) {
    print "        <div class=\"gallery__column\">"
    rowEnd = rowStart + oldRow[i] - 1
    for (j=rowStart; j<=rowEnd; j++) {
      print "          <a href=\""oldLink[j]"\" data-lightbox=\"old\" data-title=\""oldDesc[j]"\" class=\"gallery__link\">"
      print "            <figure class=\"gallery__thumb\">"
      print "              <img src=\""oldLink[j]"\" class=\"gallery__image\">"
      print "              <figcaption class=\"gallery__caption\">"oldDesc[j]"</figcaption>"
      print "            </figure>"
      print "          </a>"
    }
    print "        </div>"
    rowStart = rowEnd + 1
  }
  print "      </div>"
  print "    </section>"
  print "    <script src=\"js/lightbox-plus-jquery.min.js\"></script>"
  print "  </body>"
  print "</html>"
}' > $HOME/Pictures/hp/test.html

n_col=5
cat $libdir/desc.tsv| awktt -v n_col=$n_col '
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
  column = $1 % n_col
  if (column == 0) column = n_col
  gsub("/Users/zou/Pictures/hp", "https://raw.githubusercontent.com/zn-z/zn-z.github.io/main", $6)
  if      ($7 == "new") {new[column] = new[column]"__SEP__"$6; n++}
  else if ($7 == "old") {old[column] = old[column]"__SEP__"$6}
  desc[$6] = $5
} END {
  if (n > 0) {
    print "      <div class=\"gallery\">"
    for (i=1; i<=n_col; i++) {
      c = split(new[i], newlink, "__SEP__")
      print "        <div class=\"gallery__column\">"
      for (j=2; j<=c; j++) {
        print "          <a href=\""newlink[j]"\" data-lightbox=\"new\" data-title=\""desc[newlink[j]]"\" class=\"gallery__link\">"
        print "            <figure class=\"gallery__thumb\">"
        print "              <img src=\""newlink[j]"\" class=\"gallery__image\">"
        print "              <figcaption class=\"gallery__caption\">"desc[newlink[j]]"</figcaption>"
        print "            </figure>"
        print "          </a>"
      }
      print "        </div>"
    }
    print "      </div>"
    print "      <hr />"
  }
  print "      <div class=\"gallery\">"
  for (i=1; i<=n_col; i++) {
    c = split(old[i], oldlink, "__SEP__")
    print "        <div class=\"gallery__column\">"
    for (j=2; j<=c; j++) {
      print "          <a href=\""oldlink[j]"\" data-lightbox=\"new\" data-title=\""desc[oldlink[j]]"\" class=\"gallery__link\">"
      print "            <figure class=\"gallery__thumb\">"
      print "              <img src=\""oldlink[j]"\" class=\"gallery__image\">"
      print "              <figcaption class=\"gallery__caption\">"desc[oldlink[j]]"</figcaption>"
      print "            </figure>"
      print "          </a>"
    }
    print "        </div>"
  }
  print "      </div>"
  print "    </section>"
  print "    <script src=\"js/lightbox-plus-jquery.min.js\"></script>"
  print "  </body>"
  print "</html>"
}' > $HOME/Pictures/hp/index.html

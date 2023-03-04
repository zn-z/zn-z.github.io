cat desc_filePath.tsv| awktt '
BEGIN {
  while (getline < "tmp.tsv") link[$1] = $2
} $4 == "jpeg" {
  gsub("/Users/zou/Pictures/hp/img", "https://raw.githubusercontent.com/zn-z/tabi/main", $5)
  line[$5] = $0
} END {
  for (i in link) {
    print i, line[link[i]]
  }
}'| awktt '
BEGIN {
  n_col = 4
  print "<!DOCTYPE html>"
  print "<html lang=\"ja\" >"
  print "  <head>"
  print "    <meta charset=\"UTF-8\">"
  print "    <title>Album</title>"
  print "    <link rel=\"stylesheet\" href=\"css/style.css\">"
  print "  </head>"
  print "  <body>"
  print "    <div class=\"gallery\">"
} {
  column = $1 % n_col
  if (column == 0) column = n_col
  url[column] = url[column]"__SEP__"$6
  desc[$6] = $4
} END {
  for (i=1; i<=n_col; i++) {
    c = split(url[i], link, "__SEP__")
    print "      <div class=\"gallery__column\">"
    for (j=2; j<=c; j++) {
      print "        <a href=\""link[j]"\" target=\"_blank\" class=\"gallery__link\">"
      print "          <figure class=\"gallery__thumb\">"
      print "            <img src=\""link[j]"\" class=\"gallery__image\">"
      print "            <figcaption class=\"gallery__caption\">"desc[link[j]]"</figcaption>"
      print "          </figure>"
      print "        </a>"
    }
    print "      </div>"
  }
  print "    </div>"
  print "  </body>"
  print "</html>"
}'


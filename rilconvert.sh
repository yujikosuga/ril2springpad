#!/bin/bash
# (c) Vinzenz Vietzke <vietzke@b1-systems.de>
# 
# ugly hack for importing readitlater to springpad:
# convert readitlater export files to delicious import format
#
# usage: ./rilconvert.sh input-filename.html outpad-filename.html

echo -e "<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>" > $2
cat $1 | grep "<a href" | sed -e s/li\>/DT\>/g | sed -e s/time_added/ADD_DATE/g | sed -e s/tags/TAGS/g \
| sed -e s/'a href'/'A HREF'/g | sed -e s/TAGS/PRIVAT=\"0\"\ TAGS/g >> $2
echo -e "</DL><p>" >> $2
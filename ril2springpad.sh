#!/bin/bash
# (c) Vinzenz Vietzke <vietzke@b1-systems.de>
# 
# ugly hack for importing readitlater to springpad:
# convert readitlater export files to delicious import format
#

# This version was modified by Yuji Kosuga <yujikosuga43@gmail.com>
# Thanks Vinzenz for the original version.
#
# usage: ./ril2springpad.sh [-a value] [-p] input-filename.html output-filename.html
#   a) Attach a specified tag to each converted bookmark.   
#   p) Convert the bookmarks as public. Do not use this option if you want to make them private.
#   ?) Show this help menu."
#

help(){
    echo -e "Usage: $1: [-a value] [-p] input-filename.html output-filename.html
\ta) Attach a specified tag to each converted bookmark.
\tp) Convert the bookmarks as public. Do not use this option if you want to make them private.
\t?) Show this help menu."
}

PROG=$0
PUBLIC=0

while getopts a:p opt
do
    case ${opt} in
        a) ADDITIONAL_TAG=${OPTARG},;;
	p) PUBLIC=1;;
	\?) help "${PROG}"; exit 1;;
    esac
done

shift `expr $OPTIND - 1`

if [ "$#" -ne 2 ] ;then
    help "${PROG}"
    exit 1
fi

echo -e "\t- ADDITIONAL_TAG=${ADDITIONAL_TAG}
\t- PUBLIC=${PUBLIC}
\t- INPUT_FILE=$1
\t- OUTPUT_FILE=$2"

echo -e "<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>" > $2

cat $1 \
    | grep "<a href" \
    | sed -e s/li\>/DT\>/g \
    | sed -e s/time_added/ADD_DATE/g \
    | sed -e s/tags='"\([^"]*\)\"'/TAGS="\"${ADDITIONAL_TAG}\1\""/g \
    | sed -e s/'a href'/'A HREF'/g \
    | sed -e s/TAGS/PRIVATE=\"${PUBLIC}\"\ TAGS/g >> $2
echo -e "</DL><p>" >> $2

echo "Done."

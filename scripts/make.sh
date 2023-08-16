#!/bin/sh

SRCTXT=mozcdic-ut-alt-cannadic.txt
USERDIC=user_dic-ut-alt-cannadic

tar xf ../$SRCTXT.tar.bz2

ruby user_dict.rb -i user_dic_id.def -f ${SRCTXT} > ../${USERDIC}

split -d -l 1000000 --additional-suffix=.txt ../$USERDIC $USERDIC-
rm ../$USERDIC

[[ -e ../${USERDIC}.tar.xz ]] && rm ../${USERDIC}*.xz

tar cf ../${USERDIC}.tar ${USERDIC}-*.txt
xz -9 ../${USERDIC}.tar

rm $SRCTXT $USERDIC-*.txt


#!/bin/sh

SRCTXT=mozcdic-ut-alt-cannadic.txt
USERDIC=user_dic-ut-alt-cannadic.txt

tar xf ../$SRCTXT.tar.bz2

ruby user_dict.rb -i user_dic_id.def -f ${SRCTXT} > ../${USERDIC}

[[ -e ../${USERDIC}.xz ]] && rm ../${USERDIC}.xz
xz -9 ../${USERDIC}

rm $SRCTXT

#!/bin/sh

SRCTXT=mozcdic-ut-alt-cannadic.txt
USERDIC=user_dic-ut-alt-cannadic

tar xf ../release/$SRCTXT.tar.bz2

ruby user_dict.rb -E -i user_dic_id.def -f ${SRCTXT} > ../${USERDIC}

split --numeric-suffixes=1 -l 1000000 --additional-suffix=.txt ../$USERDIC $USERDIC-
rm ../$USERDIC

[[ -e ../release/${USERDIC}.tar.xz ]] && rm ../release/${USERDIC}.tar.xz

tar cf ../release/${USERDIC}.tar ${USERDIC}-*.txt ../LICENSE.user_dic
xz -9 -e ../release/${USERDIC}.tar

rm $SRCTXT $USERDIC-*.txt

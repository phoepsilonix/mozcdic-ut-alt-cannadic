#!/bin/sh

echo $@
(cd ../src; bash make.sh)
SYSTEMDIC=mozcdic-ut-alt-cannadic
USERDIC=user_dic-ut-alt-cannadic

curl -LO https://github.com/phoepsilonix/dict-to-mozc/releases/download/v0.3.0/dict-to-mozc-0.3.0-x86_64-unknown-linux-gnu.tar.gz
tar xf dict-to-mozc-0.3.0-x86_64-unknown-linux-gnu.tar.gz --strip-component=1

curl -LO https://github.com/google/mozc/raw/refs/heads/master/src/data/dictionary_oss/id.def
# ut dic
PATH=$HOME/.cargo/bin:$PATH
./dict-to-mozc -u -U -i ./id.def -f ../$SYSTEMDIC.txt > ./$USERDIC
ls -la $USERDIC*
split --numeric-suffixes=1 -l 1000000 --additional-suffix=.txt $USERDIC $USERDIC-

mkdir -p ../release
[[ -e ../release/${USERDIC}.tar.xz ]] && rm ../release/${USERDIC}.tar.xz

mv ../${SYSTEMDIC}.txt.tar.bz2 ../release/
tar cf ../release/${USERDIC}.tar ${USERDIC}-*.txt ../LICENSE.user_dic
xz -9 -e ../release/${USERDIC}.tar

rm $USERDIC $USERDIC-*.txt ../$SYSTEMDIC.txt

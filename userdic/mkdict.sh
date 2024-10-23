#!/bin/sh

echo $@
DIC=alt-cannadic
SYSTEMDIC=mozcdic-ut-$DIC
USERDIC=user_dic-ut-$DIC
BASE=$PWD
git clone --filter=tree:0 https://github.com/utuhiro78/merge-ut-dictionaries.git
(cd merge-ut-dictionaries/src/$DIC/;bash make.sh)
mv ./merge-ut-dictionaries/src/merge/*.bz2 $BASE/
tar xf ./$SYSTEMDIC.txt.tar.bz2

curl -LO https://github.com/phoepsilonix/dict-to-mozc/releases/download/v0.3.1/dict-to-mozc-x86_64-unknown-linux-gnu.tar.gz
tar xf dict-to-mozc-x86_64-unknown-linux-gnu.tar.gz --strip-component=1

curl -LO https://github.com/google/mozc/raw/refs/heads/master/src/data/dictionary_oss/id.def
# ut dic
PATH=$HOME/.cargo/bin:$PATH
./dict-to-mozc -u -U -S -p -i ./id.def -f ./$SYSTEMDIC.txt > ./$USERDIC
ls -la $USERDIC*
split --numeric-suffixes=1 -l 1000000 --additional-suffix=.txt $USERDIC $USERDIC-

mkdir -p ../release
[[ -e ../release/${USERDIC}.tar.xz ]] && rm ../release/${USERDIC}.tar.xz

mv ../${SYSTEMDIC}.txt.tar.bz2 ../release/
tar cf ../release/${USERDIC}.tar ${USERDIC}-*.txt ../LICENSE.user_dic
xz -9 -e ../release/${USERDIC}.tar

rm $USERDIC $USERDIC-*.txt ./$SYSTEMDIC.txt

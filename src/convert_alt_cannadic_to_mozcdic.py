#!/usr/bin/env python
# coding: utf-8

# Author: UTUMI Hirosi (utuhiro78 at yahoo dot co dot jp)
# License: Apache License, Version 2.0
# Modified: Masato TOYOSHIMA (phoepsilonix at phoepsilonix dot love)

import re
import codecs
import urllib.request
from unicodedata import normalize

urllib.request.urlretrieve('https://github.com/takayuki/natume/raw/refs/heads/master/alt-cannadic-110208/g_fname.ctd', 'g_fname.ctd')
urllib.request.urlretrieve('https://github.com/takayuki/natume/raw/refs/heads/master/alt-cannadic-110208/gcanna.ctd', 'gcanna.ctd')
file = codecs.open("gcanna.ctd", 'r', 'euc-jp')
lines = file.read()
file = codecs.open("g_fname.ctd", 'r', 'euc-jp')
lines = lines + file.read()

lines = lines.splitlines()

# Mozc の一般名詞のID
url = "https://raw.githubusercontent.com/google/mozc/master/src/data/dictionary_oss/id.def"
with urllib.request.urlopen(url) as response:
    id_mozc = response.read().decode()

id_mozc = id_mozc.split(" 名詞,一般,")[0].split("\n")[-1]

dict_name = "mozcdic-ut-alt-cannadic.txt"
l2 = []

for line in lines:
    line = line.split(" ")

    # あきびん #T35*202 空き瓶 空瓶 #T35*151 空きビン 空ビン
    yomi = line[0]
    yomi = yomi.replace("う゛", "ゔ")

    # 読みがひらがな以外を含む場合はスキップ
    # 読みが2文字以下の場合はスキップ
    if yomi != ''.join(re.findall('[ぁ-ゔー]', yomi)) or \
            len(yomi) < 3:
        continue

    hinsi = ""
    cost_anthy = 0

    # 読みを抜いたエントリを作る
    line = line[1:]

    for c in range(len(line)):
        # 「#」で始まるエントリの場合は品詞とコストを取得
        # #T35*202 空き瓶 空瓶 #T35*151 空きビン 空ビン
        if line[c][0] == "#":
            entry = line[c].split("*")
            hinsi = entry[0]
            cost_anthy = int(entry[1])
            continue

        hyouki = normalize("NFKC", line[c])

        # 表記が1文字の場合はスキップ
        if len(hyouki) < 2:
            continue

        # alt-cannadic のコストから Mozc 辞書のコストを作る
        # 「#T35*202 空き瓶 空瓶 #T35*151 空きビン 空ビン」の場合、
        # 「空き瓶 空瓶 空きビン 空ビン」の順に優先されるようにする。
        # Mozc 辞書のコストは 8000 台にする。
        cost_mozc = (9000 - cost_anthy) + c

        # 収録する品詞を選択
        if hinsi.startswith("#T3") or \
                hinsi.startswith("#T0") or \
                hinsi.startswith("#JN") or \
                hinsi.startswith("#KK") or \
                hinsi.startswith("#CN"):
            entry = [yomi, hyouki, id_mozc, id_mozc, str(cost_mozc)]
            l2.append(entry)

lines = sorted(l2)
l2 = []

for i in range(len(lines)):
    # 読みと表記が重複する場合はスキップ
    if lines[i][:2] == lines[i - 1][:2]:
        continue

    # Mozc 辞書の並びに変更
    entry = lines[i].copy()
    entry.append(entry[1])
    entry.pop(1)
    l2.append(entry)

lines = l2
l2 = []

with open(dict_name, "w", encoding="utf-8") as dict_file:
    for line in lines:
        dict_file.write("\t".join(line) + "\n")

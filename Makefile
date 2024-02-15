
build: prepare rime-symbols rime-emoji rime-aca convert

prepare: imewlconverter/publish/ImeWlConverterCmd

imewlconverter_Linux.tar.gz:
	wget "https://github.com/studyzy/imewlconverter/releases/latest/download/imewlconverter_Linux.tar.gz" -O imewlconverter_Linux.tar.gz

imewlconverter/publish/ImeWlConverterCmd: imewlconverter_Linux.tar.gz
	mkdir -p imewlconverter
	tar -zxvf imewlconverter_Linux.tar.gz -C imewlconverter --keep-newer-files

SCEL2RIME_BIN := scel2rime/target/release/scel2rime
$(SCEL2RIME_BIN):
	cd scel2rime && cargo build --release

# 下载和转换操作需要手动执行，因为无法让 GNU Makefile 自行检查是否已经完成下载和转换

download: download-sogoucel download-qqpyd

download-sogoucel:
	rm sogoucel/url.lst
	cd sogoucel && python sogou_dict_dl.py
	aria2c -i sogoucel/url.lst -d sogoucel

convert-sogoucel: prepare
	mkdir -p sogoucel_output
	# ./imewlconverter/publish/ImeWlConverterCmd -i:scel "./sogoucel/*.scel" -o:rime "./sogoucel_output/*" -ct:pinyin -os:linux
	# rename -v '\' '' "sogoucel_output/"*".txt"
	cd sogoucel_output && for i in ../sogoucel/*.scel ; do ../$(SCEL2RIME_BIN) "$$i" >/dev/null ; done

download-qqpyd:
	aria2c -i qqpyd/url.lst -d qqpyd

convert-qqpyd: prepare
	mkdir -p qqpyd_output
	./imewlconverter/publish/ImeWlConverterCmd -i:qcel "./qqpyd/*.qcel" -o:rime "./qqpyd_output/*" -ct:pinyin -os:linux
	rename -v '\' '' "qqpyd_output/"*".txt"
# 由于深蓝题库转换器是为 Windows 设计的，因此输出文件名的时候会多出一个反斜杠在文件名头部，不知道这个bug什么时候修复

rime-symbols: opencc/symbol_category.txt opencc/symbol.json opencc/symbol_word.txt
opencc/symbol_category.txt opencc/symbol.json opencc/symbol_word.txt: rime-symbols/symbol_category.txt rime-symbols/symbol.json rime-symbols/symbol_word.txt
	mkdir -p opencc
	ln -t opencc -f $?
rime-symbols/symbol_category.txt rime-symbols/symbol.json rime-symbols/symbol_word.txt: rime-symbols/rime-symbols-gen
	cd rime-symbols && python rime-symbols-gen

rime-emoji: opencc/emoji_category.txt opencc/emoji.json opencc/emoji_word.txt
opencc/emoji_category.txt opencc/emoji.json opencc/emoji_word.txt: rime-emoji/opencc/emoji_category.txt rime-emoji/opencc/emoji.json rime-emoji/opencc/emoji_word.txt
	ln -t opencc -f $?

rime-aca: luna_pinyin.hanyu.dict.yaml luna_pinyin.cn_en.dict.yaml luna_pinyin.extended.dict.yaml luna_pinyin.poetry.dict.yaml
luna_pinyin.hanyu.dict.yaml luna_pinyin.cn_en.dict.yaml luna_pinyin.extended.dict.yaml luna_pinyin.poetry.dict.yaml: rime-aca-dict/luna_pinyin.dict/luna_pinyin.hanyu.dict.yaml rime-aca-dict/luna_pinyin.dict/luna_pinyin.cn_en.dict.yaml rime-aca-dict/luna_pinyin.dict/luna_pinyin.extended.dict.yaml rime-aca-dict/luna_pinyin.dict/luna_pinyin.poetry.dict.yaml
	ln -t . -f $?

convert: luna_pinyin_simp.sogoucel.dict.yaml luna_pinyin_simp.qqpyd.dict.yaml

luna_pinyin_simp.sogoucel.dict.yaml:
	echo '' > sogoucel_output/example.txt
	bash gen-user-dict-scel.sh luna_pinyin_simp.sogoucel.dict.yaml sogoucel_output

luna_pinyin_simp.qqpyd.dict.yaml:
	bash gen-user-dict.sh luna_pinyin_simp.qqpyd.dict.yaml qqpyd_output

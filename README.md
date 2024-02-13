# Rime 配置文件

我自己使用的中州韵（Fcitx5-Rime）配置，有需要的人也可以自行下载然后合并到自己的配置里。

随缘更新，因为是我自己使用的嘛，所以只有当我觉得有需要的时候才会增加内容。

默认是处于 Linux 环境下。

## 下载仓库

```bash
git clone --recursive https://github.com/nwater/rimeconf
# 如果你忘记了 --recursive，或者正在更新现有的仓库
git submodule init
git submodule update
```

## 准备依赖环境

```bash
make prepare
```

Windows 用户请从 https://github.com/studyzy/imewlconverter/releases 下载深蓝词库转换软件.

## 下载和转换词库

一个一个列出要下载的项目未免太过复杂，如有需要的话还请仔细观察本仓库内的文件结构和内容吧，应该还算比较容易理解的。
```bash
make download
make convert-sogoucel
```

## 构建

```bash
make build 
```

## Copyrights / Licensing

**出于方便起见，文件名使用正则表达式匹配来表示**

- `luna_pinyin(_simp)?.custom.yaml`: [【朙月拼音】模糊音定製模板](https://gist.github.com/2320943) ©️ 佛振
  - 有改动，针对我自己的情况做了调整
- `luna_pinyin(_simp)?.custom.yaml|opencc/symbol_((category|word).txt|.json)`: [rime-symbols - 为rime输入法设计的中文转符号模块](https://github.com/fkxxyz/rime-symbols) ©️ 四叶草
  - 若您愿意，可以重新一次执行 `rime-symbols-gen` 然后将生成文件搬过去
- `luna_pinyin(_simp)?.custom.yaml|opencc/emoji_((category|word).txt|.json)`: [Rime Emoji / 繪文字輸入方案](https://github.com/rime/rime-emoji) 多位贡献者 (LGPL-3.0)
- `luna_pinyin.(hanyu|extended).dict.yaml`: 明月拼音擴充詞庫 ©️ 瑾昀 <cokunhui@gmail.com>
  - 注：我未能找到该文件的原始出处
- `qqpyd/`: 从 [QQ输入法-词库平台](https://cdict.qq.pinyin.cn/) 下载的词库
  - `qqpyd/output/`: 使用 [深蓝词库转换](https://github.com/studyzy/imewlconverter) 得到的可用于 Rime 的词库
  - `qqpyd/convert.sh`: 在 Linux 下进行转换所需的指令
  - `qcel.dict.yaml`: 使用 `qqpyd/convert.sh` 获得的输出文件
- `sogoucel/`: 从 [搜狗细胞词库](https://pinyin.sogou.com/dict/) 下载的词库
  - `sogoucel.dict.yaml`: 使用 `
- `luna_pinyin.sogou.dict.yaml`: [Rime 朙月拼音方案的扩充搜狗词库](https://github.com/15cm/rime-sogou-dictionaries)
  - 您需要手动下载此文件
- `sogou_dict_dl.py`: 对 [Sougou_dict_spider/main.py](https://github.com/StuPeter/Sougou_dict_spider/blob/c40f4fc94e9b7239a17c7679e329b6ba3b89c533/main.py#L18-L22) 修改了保存路径
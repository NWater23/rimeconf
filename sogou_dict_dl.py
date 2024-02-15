#!/usr/bin/env python  
# _*_ coding:utf-8 _*_  
#  
# @Version : 1.1
# @Time    : 2024/02/12
# @Author  : 圈圈烃, NWater
#
import Sougou_dict_spider . SougouSpider as SougouSpider
import Sougou_dict_spider . Scel2Txt as Scel2Txt
import os
import re
import concurrent.futures

# 下载类别
Categories = ['城市信息:167', '自然科学:1', '社会科学:76', '工程应用:96', '农林渔畜:127', '医学医药:132',
              '电子游戏:436', '艺术设计:154', '生活百科:389', '运动休闲:367', '人文科学:31', '娱乐休闲:403']
# Scel保存路径
SavePath = r"sogoucel"

# TXT保存路径
txtSavePath = r"sogoucel"

# 开始链接
startUrl = "https://pinyin.sogou.com/dict/cate/index/436"

"""搜狗词库下载"""
SGSpider = SougouSpider.SougouSpider()

cnt = 0

def main():
    # 创建保存路径
    try:
        os.mkdir(SavePath)
    except Exception as e:
        print(e)
    # 我需要啥
    myCategoryUrls = []
    for mc in Categories:
        myCategoryUrls.append("https://pinyin.sogou.com/dict/cate/index/" + mc.split(":")[-1])
    print(myCategoryUrls)
    # 大类分类
    for index, categoryOneUrl in enumerate(myCategoryUrls):
        # 创建保存路径
        # categoryOnePath = SavePath + "/" + Categories[index].split(":")[-1]
        # try:
        #     os.mkdir(categoryOnePath)
        # except Exception as e:
        #     print(e)
        # 获取小类链接
        resp = SGSpider.GetHtml(categoryOneUrl)
        # 判断该链接是否为"城市信息",若是则采取Type1方法解析
        if categoryOneUrl == "https://pinyin.sogou.com/dict/cate/index/167":
            category2Type1Urls = SGSpider.GetCategory2Type1(resp)
        else:
            category2Type1Urls = SGSpider.GetCategory2Type2(resp)
        # 小类分类
        # for key, url in category2Type1Urls.items():
        map(getCategory2Dicts, (url for key, url in category2Type1Urls.items()))
        with concurrent.futures.ThreadPoolExecutor() as executor:
            executor.map(getCategory2Dicts, (url for key, url in category2Type1Urls.items()), chunksize=128)
def getCategory2Dicts(url):
    # 创建保存路径
    # categoryTwoPath = categoryOnePath + "/" + key
    # try:
    #     os.mkdir(categoryTwoPath)
    # except Exception as e:
    #     print(e)
    # 获取总页数
    try:
        resp = SGSpider.GetHtml(url)
        pages = SGSpider.GetPage(resp)
    except Exception as e:
        print(e)
        pages = 1
    # 获取下载链接
    for page in range(1, pages + 1):
        pageUrl = url + "/default/" + str(page)
        resp = SGSpider.GetHtml(pageUrl)
        downloadUrls = SGSpider.GetDownloadList(resp)
        # 开始下载
        with open('url.lst', 'a') as f: f.writelines([urlDownload+'\n' for keyDownload, urlDownload in downloadUrls.items()])
        cnt+=len(downloadUrls.items())
        print(f'计数: {cnt}')
        # for keyDownload, urlDownload in downloadUrls.items():
        #     keyToDownload = '_'.join(re.split('&[A-Za-z0-9]+;|[~`!@#$%^&*()\[\]\{\},;|]', keyDownload))
        #     filePath = categoryTwoPath + "/" + keyToDownload + ".scel"
        #     if os.path.exists(filePath):
        #         print(keyDownload + " 文件已存在>>>>>>")
        #     else:
        #         SGSpider.Download(urlDownload, filePath)
        #         print(keyDownload + " 保存成功......")


if __name__ == '__main__':
    main()
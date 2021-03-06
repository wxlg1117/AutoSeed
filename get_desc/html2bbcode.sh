#!/bin/bash
# FileName: get_desc/html2bbcode.sh
#
# Author: rachpt@126.com
# Version: 3.1v
# Date: 2018-12-12
#
#-------------------------------------#
# 本 shell 脚本作用为转化原种 html 格式 iNFO 以及 screens页面至 bbcode。
# 优先处理 font 标签，字体，颜色。
# img 标签部分需要补全域名。
#-------------------------------------#
#---cmct---#
sed -Ei '/下载信息/d;/郑重声明/d' "$source_desc"

sed -i "s/id=\"[^\"]\"//g; s/alt=\"[^\"]\"//g" "$source_desc"

sed -i "s#<strong>#[b]#g;s#</strong>#[/b]#g" "$source_desc"
sed -i "s#<span[^>]*>##g;s#</span>##g;s#<p[^>]*>##g;s#</p>##g;s#<tr[^>]*>##g;s#</tr>##g;s#<td[^>]*>##g;s#</td>##g" "$source_desc"
sed -i "s#<div[^>]*>##g;s#</div>##g" "$source_desc"
sed -i "s#<u>#[u]#g;s#</u>#[/u]#g;s#<p[^>]\*>##g;s#</p>##g;" "$source_desc"  # ttg

#---color & size---#
sed -i "s#<font color=\"\([^\"]\+\)\">\([^<]\+\)</font>#[color=\1]\2[/color]#g" "$source_desc"

sed -i "s#\(font size=.*\)</font>#\1[/size]#g" "$source_desc"

sed -i "s#<font size=\"\([^\"]\+\)\"[^>]*>#[size=\1]#g" "$source_desc"
#sed -i "s#<font color=\"\([^\"]\+\)\"[^>]*>#[color=\1]#g" "$source_desc"

#---br---#
sed -i "s/<br \/>//g;s/<br\/>//g;s/<br>//g;s/&nbsp;//g" "$source_desc"

#---font face---#
sed -i "s/<font face=\"[cC]ourier [nN]ew\">/[font=monospace]/g;s/<font face=\"monospace\">/[font=monospace]/g;s/<\/font>/[\/font]/g" "$source_desc"

#---table---#
sed -i "s#<table[^>]\+>#[quote]#g;s#</table>#[/quote]\n#g;" "$source_desc"

#---img---#
sed -i "s!\"[^\"]*attachments\([^\"]\+\)!\"${source_site_URL}/attachments\1!g" "$source_desc"
sed -i "s#<img[^>]\+src=\"\(.[^\"]\+\)\"[^>]*>#[img]\1[/img]#g" "$source_desc"
sed -i "s#\]attachments#\]${source_site_URL}/attachments#g" "$source_desc"

#---a---#
sed -i "s#</a>#[/url]#g;s#<a[^>]\+href=\"\(.[^\"]\+\)\"[^<]*>#[url=\1]#g" "$source_desc"

#---hdsky & hdchina---#
sed -i "s#<legend>[^>]\+引用[^>]\+</legend>##g;s#fieldset#quote#g" "$source_desc"

#---others---#
sed -i "s#<#[#g;s#>#]#g" "$source_desc"

#---double url---#
sed -i "s!\[url=[^\]]\+/\]\[url=\(.*\)\[/url\]\[/url\]![url=\1[/url]!g" "$source_desc"

#---ttg imdb url---#
sed -i "s!\[url=http[s]*://www.imdb.com/title/tt[0-9]\{7\}[/]*\]\[url=http[s]*://www.imdb.com/title/tt[0-9]\{7\}[/]*\]\(http[s]*://www.imdb.com/title/tt[0-9]\{7\}[/]*\)\[/url\]\[/url\]!\1!g" "$source_desc"
sed -i "s!\[url=http[s]*://movie.douban.com/subject/[0-9]\{8\}[/]*\]\[url=http[s]*://movie.douban.com/subject/[0-9]\{8\}[/]*\]\(http[s]*://movie.douban.com/subject/[0-9]\{8\}[/]*\)\[/url\]\[/url\]!\1!g" "$source_desc"

sed -i -r '/quote/{s/font color=["]([a-zA-Z]+)["]/color=\1/g;s/\[\/font\]/[\/size]/;s/\[\/font\]/[\/color]/}' "$source_desc"

#---cmct---#
sed -i "s/^代码[\r\n]*$/[quote]/;/截图信息/i [/quote]" "$source_desc"


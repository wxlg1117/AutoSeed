#!/bin/bash
# FileName: post/byrbt.sh
#
# Author: rachpt@126.com
# Version: 3.0v
# Date: 2018-12-05
#
#-------------settings---------------#
cookie="$cookie_byrbt"
passkey="$passkey_byrbt"
anonymous="$anonymous_byrbt"
ratio_set=$ratio_byrbt
#---static---#
postUrl="${post_site[byrbt]}/takeupload.php"
editUrl="${post_site[byrbt]}/takeedit.php"
downloadUrl="${post_site[byrbt]}/download.php?id="
#-------------------------------------#
# 需要的参数
gen_byrbt_parameter() {

if [ -s "$source_html" ]; then
    byrbt_des="$descrCom_complex_html
    $(cat "$source_html")"
else
    byrbt_des="$descrCom_complex_html
    <br /><br /><br /><strong><span style=\"font-size:30px;\">\
        获取简介失败！！！</span></strong><br /><br />"
fi

# 判断类型，纪录片、电影、剧集
if [ "$documentary" = 'yes' ]; then
    byrbt_type='410'
else
  if [ "$serials" = 'yes' ]; then
    # 剧集
    byrbt_type='401'
    # 二级分类
    case "$region" in
      *中国大陆*)
          byrbt_tv_type='大陆'
          byrbt_second_type='15' ;;
      *香港*|*台湾*|*澳门*)
          byrbt_tv_type='港台'
          byrbt_second_type='18' ;;
      *日本*|*韩国*)
          byrbt_tv_type='日韩'
          byrbt_second_type='16' ;;
      *美国*|*英国*|*德国*|*法国*|*墨西哥*|*俄罗斯*|*西班牙*|*加拿大*|*澳大利亚*)
          byrbt_tv_type='欧美'
          byrbt_second_type='17' ;;
      *)
          byrbt_tv_type='其他'
          byrbt_second_type='2' ;;
    esac
    byrbt_tv_season="$season"
    byrbt_tv_filetype="$file_type"
  else 
    # 默认电影类
    byrbt_type='408'
    # 二级分类
    case "$region" in
      *中国大陆*|*香港*|*台湾*|*澳门*)
          byrbt_second_type='11' ;;
      *日本*|*韩国*|*印度*|*新加坡*|*泰国*|*菲律宾*)
          byrbt_second_type='14' ;;
      *英国*|*德国*|*法国*|*俄罗斯*|*西班牙*|*澳大利亚*)
          byrbt_second_type='12' ;;
      *美国*|*墨西哥*|*加拿大*)
          byrbt_second_type='13' ;;
      *)
          byrbt_second_type='1' ;;
    esac
  fi
fi
}
#-------------------------------------#
# type -> 类型(*)，second_type -> 二级分类
# file -> 种子文件(*)，[tv_type -> 剧集类型]，movie_cname -> 中文名
# [ename0day -> 英文名|tv_ename ->剧集]，movie_type -> 电影类别(喜剧/动作/爱情)
# movie_country -> 国家地区，small_descr -> 副标题
# url -> imdb链接，dburl -> 豆瓣链接，bgmtv_url -> 番组计划链接
# nfo -> nfo 文件，descr -> 简介(*)，uplver -> 匿名发布('yes')

# tv_season -> 剧集季度，tv_filetype -> 剧集文件格式['MKV,MP4...']

#-------------------------------------#
# 408  电影
# 401  剧集
# 404  动漫
# 402  音乐
# 405  综艺
# 403  游戏
# 406  软件
# 407  资料
# 409  体育
# 410  纪录

#---电影二级分类---#
# 11  华语
# 12  欧洲
# 13  北美
# 14  亚洲
# 1   其他

#---剧集二级分类---#
# 15  大陆
# 16  日韩
# 17  欧美
# 18  港台
# 2   其他
#-------------------------------------#
byrbt_post_func() {
    gen_byrbt_parameter
if [ "$byrbt_type" = '408' ]; then
    # 电影 POST
    t_id=$(http --verify=no --ignore-stdin -f --print=h --timeout=10 POST "$postUrl"\
        'movie_cname'="$chinese_title"\
        'ename0day'="$dot_name"\
        'type'="$byrbt_type"\
        'small_descr'="$chs_included"\
        'url'="$imdb_url"\
        'dburl'="$( [ ! "$imdb_url" ] && echo "$douban_url" || echo 'none')"\
        'descr'="$byrbt_des"\
        'type'="$byrbt_type"\
        'second_type'="$byrbt_second_type"\
        'movie_type'="$genre"\
        'movie_country'="$region"\
        'uplver'="$anonymous_byrbt"\
        file@"${torrent_Path}"\
        "$cookie_byrbt"|grep 'id='|grep 'detail'|head -1|cut -d '=' -f 2|cut -d '&' -f 1)

    if [ -z "$t_id" ]; then
        # 辅种
        :
    fi
elif [ "$byrbt_type" = '401' ]; then
    # 剧集 POST
    t_id=$(http --verify=no --ignore-stdin -f --print=h --timeout=10 POST "$postUrl"\
        'type'="$byrbt_type"\
        'second_type'="$byrbt_second_type"\
        'tv_type'="$byrbt_tv_type"\
        'cname'="$chinese_title"\
        'tv_ename'="$dot_name"\
        'tv_season'="$byrbt_tv_season"\
        'tv_filetype'="$byrbt_tv_filetype"\
        'type'="$byrbt_type"\
        'small_descr'="$chs_included"\
        'url'="$imdb_url"\
        'dburl'="$( [ ! "$imdb_url" ] && echo "$douban_url" || echo 'none')"\
        'descr'="$byrbt_des"\
        'movie_type'="$genre"\
        'uplver'="$anonymous_byrbt"\
        file@"${torrent_Path}"\
        "$cookie_byrbt" | grep 'id='|grep 'detail'|head -1|cut -d '=' -f 2|cut -d '&' -f 1)
    if [ -z "$t_id" ]; then
        # 辅种
        :
    fi
elif [ "$byrbt_type" = '410' ]; then
    # 纪录片 POST
    :
else
    # 其他 POST
    :
fi
}

#-------------------------------------#


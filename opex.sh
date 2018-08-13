#!/bin/sh

#用文件浏览器打开路径
path="$*"
#若无入参则默认打开当前目录
if [ "${path}"x = x ];then
	path='.'
fi
if [ ! -d "$path" ];then echo illegal path:$path!!;exit;fi
#转换为真实linux路径
realpath=$(echo $(cd "$path";pwd)|xargs readlink -f)
#尾部'/'处理
realpath=$(echo $realpath/|sed 's/\/\//\//')
echo "openning path '$realpath' ..."
#转换为外部windows路径
echo $realpath|grep -P ^/mnt/[a-z]/ > /dev/null
if [ $? -eq 0 ];then
	#去除'/mnt/';插入':';替换'/'为'\'
	wslpath=$(echo $realpath|sed 's/\/mnt\///g'|sed 's/\(^[a-z]\)\//\1:\//'|sed 's/\//\\/g')
else
	wslpath_head='C:\Users\Administrator\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs'
	#替换'/'为'\'
	wslpath=$wslpath_head$(echo $realpath|sed 's/\//\\/g')
fi
explorer.exe $wslpath


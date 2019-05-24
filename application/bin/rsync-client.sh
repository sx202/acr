#!/bin/bash
#################rsync 守护进程模式 客户端一键配置脚本################

# 如果脚本执行的过程中遇到没有定义的变量就直接退出脚本
set -u
# 如果命令执行结果是非零值，就直接退出脚本
set -e

####################################################################
# 基本配置信息，可以根据实际情况修改,但是必须跟服务器端一致#########

# rsync使用的虚拟用户密码信息存放的文件
Rsync_Password_File='/etc/taagoo'
# rsync使用的密码
Rsync_Password='taagoo123'
####################################################################

# 判断认证文件是否存在，存在添加内容，不存在创建文件并添加内容
if [ -f $Rsync_Password_File ];then
   echo "$Rsync_Password" >$Rsync_Password_File
   chmod 600 $Rsync_Password_File
else
   touch $Rsync_Password_File
   echo "$Rsync_Password" >$Rsync_Password_File
   chmod 600 $Rsync_Password_File   
fi




#!/bin/bash
################rsync 守护进程模式 服务器端一键配置脚本###############

# 如果脚本执行的过程中遇到没有定义的变量就直接退出脚本
set -u
# 如果命令执行结果是非零值，就直接退出脚本
set -e

# 软件名称（这个不能修改，因为同步就是基于这个软件做的）
Soft_Name='rsync'

##################################################################
###########基本配置信息，可以根据实际情况修改######################
# 同步使用的用户
User='www'
# 配置文件位置及名称
Rsync_Conf='/etc/rsyncd.conf'

# 同步时，排除同步的文件及目录
Exclude_Dir1='install/'
Exclude_Dir2='.git/'
Exclude_File1='.gitignore'

# 同步用的模块名称
Module_Name='update'
# 文件同步到远程机器的目录
Rsync_Dir='/data/html/shop.taagoo.cn'

# rsync使用的虚拟用户
Auth_User='rsync_taagoo'
# rsync使用的密码
Auth_pass='taagoo123'
# 允许哪些地址可以往服务器同步内容
Host_Allow='192.168.6.0/24'
# 禁止哪些地址往服务器同步内容
Host_Deny='0.0.0.0/0'
# rsync使用的虚拟用户和密码信息存放的文件
Secrets_File='/etc/taagoo'
#####################################################################

# 判断rsync软件是否安装，如果没有就安装
Rsync_Num=`rpm -qa $Soft_Name|wc -l`
if [ "$Rsync_Num" -lt 1 ];then
   yum install -y $Soft_Name
fi

# 判断同步使用的用户是否存在，如果没有就添加
User_Num=`cat /etc/passwd|grep $User|wc -l`
if [ "$User_Num" -lt 1 ];then
   useradd $User -s /sbin/nologin -M 
fi

# 判断代码存放目录是否存在，不存在就创建。同时对文件夹授权
if [ ! -d "$Rsync_Dir" ];then
    mkdir -p $Rsync_Dir 
    chown -R www.www $Rsync_Dir
else
    chown -R www.www $Rsync_Dir
fi

# 判断认证文件是否存在，存在添加内容，不存在创建文件并添加内容
if [ -f $Secrets_File ];then
   echo "${Auth_User}:$Auth_pass" >$Secrets_File
   chmod 600 $Secrets_File
else
   touch $Secrets_File
   echo "${Auth_User}:$Auth_pass" >$Secrets_File
   chmod 600 $Secrets_File
fi

########################## 配置文件 #####################
# 添加rsync配置文件内容
cat >>$Rsync_Conf<<EOF
uid = $User
git = $User
use chroot = no
max connections = 2
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
transfer logging = yes
log file = /var/log/rsync.log
list = false
read only = false
timeout = 900
ignore errors
incoming chmod = Du=rwx,Dgo=rx,Fu=rw,Fgo=r
[$Module_Name]
path = $Rsync_Dir
exclude = $Exclude_Dir1 $Exclude_Dir2 $Exclude_File1
hosts allow = $Host_Allow
hosts deny = $Host_Deny
auth users = $Auth_User
secrets file = $Secrets_File
EOF

#################### 运行程序，并查看运行结果 ##############
# 运行rsync守护进程
/usr/bin/${Soft_Name} --daemon

# 判断rsync守护进程是否运行成功，如果成功打印提示
Run_Soft_Nums=`ps -ef|grep "rsync --daemon"|grep -v grep|wc -l`
[ "$Run_Soft_Nums" -gt 0 ] && echo "$Soft_Name install successfull!!"


#!/bin/bash
set -e
set -u

. /acr/application/module/acr.menu

########################## 参数文件的加载设置 ##################
# 第一种：自动加载默认的参数文件
# 第二种：通过参数-f 设置参数文件名和位置
# 加了一些参数 -h --help -v --version等，参数还可以根据需求在加
#Acr_Conf_Default=''
# 如果有参数,用数组记录下来所用的参数
if [ "$#" -gt 0 ];then
   for ((P_Num=1;P_Num<="$#";P_Num++))
   do
       P_Value[${P_Num}]=`echo "$*"|awk '{print $'"${P_Num}"'}'`
   done
   # 遍历数组，获取需要的参数对应的值
   Array_Num=${#P_Value[@]}
   for ((A_Ns=1;A_Ns<="${Array_Num}";A_Ns++))
   do
       case "${P_Value[A_Ns]}" in
            -f|--file)
              Acr_Conf_Default="${P_Value[A_Ns+1]}"; 
              break;
              ;;
            -h|--help)
              echo "help";
              exit 0;
              ;;
            -v|-V|--version)
              echo "version";
              exit 0;
              ;;
            *)
              Acr_Command_Ui;
              exit 2;
       esac
   done
else
   # 如果没有加参数，直接加载默认位置参数文件
   Acr_Conf_Default='/acr/application/conf/acr.conf'
fi
## 判断输入的参数文件是否存在，存在加载文件，不存在提示并退出
if [ -f "${Acr_Conf_Default}" ];then
   . "${Acr_Conf_Default}"
else
   echo "Usage: ${Acr_Conf_Default} is not exist, please insert Correct directory and file name !!!"
   exit 2
fi

. /acr/application/module/acr.init
## 初始化程序##
InIt

## 主菜单状态值
Main_Menu_Nums=0

## 选项状态值
Menu_1_1=0
Menu_1_2=0
Menu_1_3=0
Menu_1_4=0
Menu_1_5=0

Menu_2_1=0
Menu_2_2=0
Menu_2_3=0
Menu_2_4=0
Menu_2_5=0

Menu_3=0
Menu_4=0

## 用户主菜单输入选择##
while [ "${Main_Menu_Nums}" -eq 0 ]
do
   clear
   ## 下载代码菜单状态值
   Get_Code_Menu_Nums_1=0
   Get_Code_Menu_Nums_2=0
   Main_Ui
   read -p "please insert number(1/2/3/4/5):" Main_Number 
   case  ${Main_Number} in
       1)
         ## 用户二级菜单输入选择
         while [ "${Get_Code_Menu_Nums_1}" -eq 0 ]
         do
              clear
              Get_Code_Ui
              read -p "please insert number(1/2/3/4/5):" Get_Code_Number_1
              case ${Get_Code_Number_1} in
                   1)
                     Menu_1_1=1
                     Get_Code_Menu_Nums_1=1
                     Main_Menu_Nums=1
                      ;;
                   2)
                     Menu_1_2=1
                     Get_Code_Menu_Nums_1=1
                     Main_Menu_Nums=1
                      ;;
                   3)
                     Menu_1_3=1
                     Get_Code_Menu_Nums_1=1
                     Main_Menu_Nums=1
                      ;;
                   4)
                     Get_Code_Menu_Nums_1=1
                      ;;
                   5)
                     exit 0
                      ;;
                   *)
                     echo "Error:Please insert correct parameter"
              esac
         done
           ;;
       2)
         ## 用户二级菜单输入选择
         while [ "${Get_Code_Menu_Nums_2}" -eq 0 ]
         do
              clear
              Get_Code_Ui
              read -p "please insert number(1/2/3/4/5):" Get_Code_Number_1
              case ${Get_Code_Number_1} in
                   1)
                     Menu_2_1=1
                     Get_Code_Menu_Nums_2=1
                     Main_Menu_Nums=1
                      ;;
                   2)
                     Menu_2_2=1
                     Get_Code_Menu_Nums_2=1
                     Main_Menu_Nums=1
                      ;;
                   3)
                     Menu_2_3=1
                     Get_Code_Menu_Nums_2=1
                     Main_Menu_Nums=1
                      ;;
                   4)
                     Get_Code_Menu_Nums_2=1
                      ;;
                   5)
                     exit 0
                      ;;
                   *)
                     echo "Error:Please insert correct parameter"
              esac
          done
          ;;          
       3)
          . /acr/application/module/acr.backup
          BackUp_Code;
          exit 0;
          ;;
       4)
          . /acr/application/module/acr.recover
          ReCover;
          exit 0;
          ;;
       5)
          exit 0;
          ;;
       *)
         echo "invalid parameter , please insert number 1 or 2 or 3 or 4 or 5"  
   esac
done

## 根据上面的选择来进行对应的处理
# 上传代码
# 上传代码----Tar包
if [ "${Menu_1_1}" -eq 1 ];then
   . /acr/application/module/acr.tar-download
   . /acr/application/module/acr.new
   Tar_DownLoad_Code
   New_Code
   exit 0
fi
# 上传代码----Git
if [ "${Menu_1_2}" -eq 1 ];then
   . /acr/application/module/acr.git-download
   . /acr/application/module/acr.new
   Git_DownLoad_Code
   New_Code
   exit 0
fi
# 上传代码----Svn
if [ "${Menu_1_3}" -eq 1 ];then
   . /acr/application/module/acr.svn-download
   . /acr/application/module/acr.new
   Svn_DownLoad_Code
   New_Code
   exit 0
fi

# 更新代码
# 更新代码----Tar包
if [ "${Menu_2_1}" -eq 1 ];then
   . /acr/application/module/acr.tar-download
   . /acr/application/module/acr.new
   Tar_DownLoad_Code
   New_Code
   exit 0
fi
# 更新代码----Git
if [ "${Menu_2_2}" -eq 1 ];then
   . /acr/application/module/acr.git-download
   . /acr/application/module/acr.new
   Git_DownLoad_Code
   New_Code
   exit 0
fi
# 更新代码----Svn
if [ "${Menu_2_3}" -eq 1 ];then
   . /acr/application/module/acr.svn-download
   . /acr/application/module/acr.new
   Svn_DownLoad_Code
   New_Code
   exit 0
fi


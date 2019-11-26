# V2RayManager Proxy Service v1.0

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
manager_local=/usr/local/v2rayls/v2raym #manager文件路径
manager_file_local=/usr/local/v2rayls   #manager所在文件夹
shell_file_path=/usr/local/v2rayls/status.sh #脚本文件所在路径

cd $manager_file_local

function V2_help(){
    echo "V2RayManager脚本 V1.0"
    echo
    echo "start ---- 启动V2RayManager服务"
    echo "stop ---- 停止V2RayManager服务"
    echo "restart ---- 重启V2RayManager服务"
    echo "status ---- 查看V2RayManager服务运行状态"
    echo "log_excision ---- 将日志以当前日期分割"
    echo "help ---- 帮助信息"
    echo
}

check_running(){
    pid=`ps -ef | grep -v grep | grep -i "${manager_local}" | awk '{print $2}'`
    if [ ! -z $pid ]; then
        return 0
    else
        return 1
    fi
}

function check_status(){
    check_running
    if [ $? -eq 0 ]; then
        exit 0
    else
		nowdate=$(date +"%Y-%m-%d %H:%M:%S")
		echo "$nowdate 检测到服务端进程异常！"
        nohup $manager_local m>> ${manager_file_local}/manager-v2.log 2>&1 &
        RETVAL=$?
        if [ $RETVAL -eq 0 ]; then
		nowdate=$(date +"%Y-%m-%d %H:%M:%S")
			echo "$nowdate 服务端进程重启成功! "
		else
			echo "$nowdate 服务端进程重启失败，请检查! "
		fi
    fi
}

function start_manager(){
    check_running
    if [ $? -eq 0 ]; then
        echo "$name (PID $pid) 正在运行中..."
        exit 0
    else
        nohup $manager_local m>> ${manager_file_local}/manager-v2.log 2>&1 &
        RETVAL=$?
        if [ $RETVAL -eq 0 ]; then
            echo "$name 启动成功! "
        else
            echo "$name 启动失败! "
        fi
    fi
}

function status_manager(){
    check_running
    if [ $? -eq 0 ]; then
        echo "$name (PID $pid) 正在运行中..."
    else
        echo "$name 已经停止运行! "
        RETVAL=1
    fi
}

function stop_manager(){
    check_running
    if [ $? -eq 0 ]; then
        pid=`ps -ef | grep -v grep | grep -i "${manager_local}" | awk '{print $2}'`
        kill $pid
        RETVAL=$?
        if [ $RETVAL -eq 0 ]; then
            echo "$name 停止成功! "
        else
            echo "$name 停止失败! "
        fi
    else
        echo "$name 已经停止运行! "
        RETVAL=1
    fi
}

function restart_manager(){
    stop_manager
    start_manager
}

# Initialization step
action=$1
[ -z $1 ] && action=help
case "$action" in
start)
    start_manager
    ;;
stop)
    stop_manager
    ;;
restart)
    restart_manager
    ;;
status)
    status_manager
    ;;
check_status)
    check_status
    ;;
help)
    V2_help
    ;;
    *)
    echo "用法错误! 用法请查看 help 。"
    ;;
esac
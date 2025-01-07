#!/bin/bash
# 执行得任务队列
PROCESS_ARRAY=('report-construct-queue/listen' 'report-construct-queue-second/listen' 'report-construct-queue-third/listen' 'report-render-queue/listen' 'report-queue/listen' 'datacenter-interactive-queue/listen' 'data-center-queue/listen')
# 脚本执行路径
SHELL_SCRIPT_PATH=$(cd $(dirname $0);pwd)
# yii路径
YII_EXECUTE_PATH="${SHELL_SCRIPT_PATH}/yii"
GREP_RESULT=$(echo $SHELL_SCRIPT_PATH | grep test)
if [[ "$GREP_RESULT" != "" ]]
then
    ENV='test'
else
    ENV=''
fi
for i in ${PROCESS_ARRAY[@]};
do
        PROCESS=$i;
        PROCESS_ACTIVE_NUM=`ps -ef | grep -v grep | grep  "${YII_EXECUTE_PATH} ${PROCESS}" | wc -l`;
        if [[ PROCESS_ACTIVE_NUM -lt 1 ]]; then
                echo -e "\033[31m ${YII_EXECUTE_PATH}->${PROCESS} WAS DIED \033[0m";
                nohup php $YII_EXECUTE_PATH $PROCESS  >/data/report-${ENV}queue.out 2>&1 &
                echo "nohup php ${YII_EXECUTE_PATH} ${PROCESS}  >/data/report-${ENV}queue.out 2>&1 &"
                echo "CHECK ${PROCESS} RESTART STATUS..."
                RESTART_PROCESS_ACTIVE_NUM=`ps -ef | grep -v grep | grep  "${YII_EXECUTE_PATH} ${PROCESS}" | wc -l`;
                if [[ RESTART_PROCESS_ACTIVE_NUM -lt 1 ]]; then
                  echo -e "\033[31m RESTART ${PROCESS} FAIL... \033[0m";
                else
                   echo -e "\033[32m RESTART ${PROCESS} SUCCESS \033[0m \n";
                fi
        else
                echo -e "\033[32m ${PROCESS} IS RUNNING \033[0m \n";
        fi
done

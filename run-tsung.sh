#!/bin/sh
log_dir="/var/log/tsung"
tsung_config="/tmp/tsung_config.xml"

if [ -z ${TSUNG_CONFIG_URL} ]; then
    echo ERROR: TSUNG_CONFIG_URL path must be defined as an environment variable.
    exit 1
fi

wget --no-check-certificate ${TSUNG_CONFIG_URL} -O ${tsung_config}
if [ ! -f ${tsung_config} ]; then
    echo ERROR: Tsung config file "${TSUNG_CONFIG_URL}" not downloaded successfully.
    exit 1
fi

cmd_tsung="tsung -l ${log_dir} -f ${tsung_config} start"

if [ ! -z ${TSUNG_CRON_SCHEDULE} ];then
    CRON_RUN_TSUNG="${TSUNG_CRON_SCHEDULE} root ${cmd_tsung}"
fi
if [ ! -z ${TSUNG_S3_URL} ]; then
    CRON_S3_BACKUP="*/10 * * * *  root ${cmd_s3cmd}" 
fi

mkdir -p ${log_dir}
touch ${log_dir}/run_tsung.log
service ssh start

if [ ! -z ${TSUNG_CRON_SCHEDULE} ]; then
    cat >> /etc/crontab <<_END
${CRON_RUN_TSUNG}
${CRON_S3_BACKUP}
_END
else
    ${cmd_tsung} &
fi
tail -f ${log_dir}/run_tsung.log ${log_dir}/*/tsung.log

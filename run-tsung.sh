#!/bin/sh
log_dir="/var/log/tsung"
tsung_config="/tmp/tsung_config.xml"
cron_log_cmd=" >>${cron_log} 2>&1"

if [ -z ${TSUNG_CONFIG_URL} ]; then
    echo ERROR: TSUNG_CONFIG_URL path must be defined as an environment variable.
    exit 1
fi
config_name="`basename ${TSUNG_CONFIG_URL}`"

wget --no-check-certificate ${TSUNG_CONFIG_URL} -O ${tsung_config}
if [ ! -f "${tsung_config}" ]; then
    echo ERROR: Tsung config file "${TSUNG_CONFIG_URL}" not downloaded successfully.
    exit 1
fi

cmd_tsung="tsung -l ${log_dir} -f ${tsung_config} start"
cmd_tsung_stats="/usr/lib/tsung/bin/tsung_stats.pl"

mkdir -p ${log_dir}
service ssh start
${cmd_tsung}

# Generate reports 
cwd=`pwd`
for dir in ${log_dir}/*; do
    if [ -d ${dir} ]; then
        cd ${dir}
        ${cmd_tsung_stats}
        cd ${cwd}
   fi
done

# Upload results to s3
if [ ! -z ${TSUNG_S3_BUCKET} ]; then
    cmd_s3cmd="s3cmd sync ${log_dir} s3://${TSUNG_S3_BUCKET}/${config_name}/"
    ${cmd_s3cmd}
fi

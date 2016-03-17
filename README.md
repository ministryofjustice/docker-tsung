Docker-Tsung
============

USAGE
-----

    docker run \
        -e TSUNG_CONFIG_URL="https://raw.githubusercontent.com/ministryofjustice/tsung-configs/master/config/helloworld.xml" \
        -p 8091:8091 \
        --name tsung \
        tsung

Environment Variables
---------------------

TSUNG_CONFIG_URL
~~~~~~~~~~~~~~~~~~~~~

Set the downloadable location of the tsung config file

    TSUNG_CONFIG_URL=https://raw.githubusercontent.com/ministryofjustice/tsung-configs/master/config/helloworld.xml


TSUNG_CRON_SCHEDULE
~~~~~~~~~~~~~~~~~~~

The cron schedule to run the tsung job on, the default is below

    TSUNG_CRON_SCHEDULE="0 11 * * 2"

TSUNG_S3_URL
~~~~~~~~~~~~~~~~~

S3 url to backup the logs to


#!/bin/bash
set -x

java -jar ${GERRIT_WAR} daemon -d ${GERRIT_SITE} --console-log

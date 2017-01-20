#!/bin/bash

java -jar $GERRIT_WAR reindex -d $GERRIT_SITE
java -jar $GERRIT_WAR daemon -d $GERRIT_SITE --console-log

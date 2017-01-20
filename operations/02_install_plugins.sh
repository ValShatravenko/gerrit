#!/bin/bash -x

for plugin in $(ls ${GERRIT_HOME}/plugins); do
 if [ ! -L $GERRIT_SITE/plugins/${plugin} ]; then
   ln -s ${GERRIT_HOME}/plugins/${plugin} ${GERRIT_SITE}/plugins/${plugin}
 fi
done

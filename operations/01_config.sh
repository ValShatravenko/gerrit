#!/bin/bash

set -x

kaigara render gerrit.config > ${GERRIT_SITE}/etc/gerrit.config
kaigara render secure.config > ${GERRIT_SITE}/etc/secure.config

echo "Render configuration"
cat ${GERRIT_SITE}/etc/gerrit.config

for f in $(ls $GERRIT_HOME/plugins); do
  if [ ! -L $GERRIT_SITE/plugins/$f ]; then
    ln -sf $GERRIT_HOME/plugins/$f $GERRIT_SITE/plugins/$f
  fi
done

java -jar $GERRIT_WAR init --batch --no-auto-start -d $GERRIT_SITE

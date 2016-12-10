#!/bin/sh

java -jar $GERRIT_WAR init --batch --no-auto-start -d $GERRIT_SITE

for f in $(ls $GERRIT_HOME/plugins); do
  if [ ! -L $GERRIT_SITE/plugins/$f ]; then
    ln -s $GERRIT_HOME/plugins/$f $GERRIT_SITE/plugins/$f
  fi
done

mv $GERRIT_HOME/Gerrit* $GERRIT_SITE/etc/
mv $GERRIT_HOME/octo* $GERRIT_SITE/static/

java -jar $GERRIT_WAR reindex -d $GERRIT_SITE

java -jar $GERRIT_WAR daemon -d $GERRIT_SITE --console-log

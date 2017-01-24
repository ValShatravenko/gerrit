#!/bin/bash
echo "==================================================="
echo "              01 Gerrit Configuration"
echo "==================================================="
set -x

mkdir -p ${GERRIT_SITE}/etc/

echo "Render configuration"
kaigara render gerrit.config | tee ${GERRIT_SITE}/etc/gerrit.config
kaigara render secure.config | tee ${GERRIT_SITE}/etc/secure.config

set +x
echo "==================================================="
echo "              02 Gerrit Install Plugins"
echo "==================================================="
set -x

mkdir -p ${GERRIT_SITE}/plugins/

for plugin in $(ls ${GERRIT_HOME}/plugins); do
 if [ ! -L $GERRIT_SITE/plugins/${plugin} ]; then
   ln -s ${GERRIT_HOME}/plugins/${plugin} ${GERRIT_SITE}/plugins/${plugin}
 fi
done

set +x
echo "==================================================="
echo "              03 Gerrit Install Theme              "
echo "==================================================="
set -x

mkdir -p ${GERRIT_SITE}/{etc,static}

mv ${GERRIT_HOME}/GerritSite.css        ${GERRIT_SITE}/etc/
mv ${GERRIT_HOME}/GerritSiteFooter.html ${GERRIT_SITE}/etc/
mv ${GERRIT_HOME}/octogerrit.js         ${GERRIT_SITE}/static/

set +x
echo "==================================================="
echo "              04 Gerrit Init                       "
echo "==================================================="
set -x

java -jar ${GERRIT_WAR} init --batch --no-auto-start -d ${GERRIT_SITE}
java -jar ${GERRIT_WAR} reindex -d ${GERRIT_SITE}

find ${GERRIT_SITE}

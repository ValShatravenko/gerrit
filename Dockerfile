FROM java:openjdk-8-jre

# Install Kaigara
ENV KAIGARA_VERSION v0.0.1
RUN wget https://github.com/mod/kaigara/releases/download/$KAIGARA_VERSION/kaigara-linux-amd64-$KAIGARA_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzf kaigara-linux-amd64-$KAIGARA_VERSION.tar.gz

# Gerrit config
ENV GERRIT_HOME /var/gerrit
ENV GERRIT_WAR ${GERRIT_HOME}/gerrit.war
ENV GERRIT_SITE ${GERRIT_HOME}/review_site
ENV GERRIT_VERSION 2.13.2

RUN groupadd -r gerrit2 --gid=1000 && useradd -r -m -g gerrit2 -d ${GERRIT_HOME} --uid=1000 gerrit2

RUN apt-get -qq update
RUN apt-get install -y curl git

COPY bin/gerrit-start.sh /usr/local/bin/gerrit-start.sh
COPY bin/gerrit-entrypoint.sh /usr/local/bin/gerrit-entrypoint.sh

RUN chown gerrit2:gerrit2 ${GERRIT_HOME}

USER gerrit2

WORKDIR ${GERRIT_HOME}
RUN wget https://gerrit-releases.storage.googleapis.com/gerrit-${GERRIT_VERSION}.war -O ${GERRIT_WAR}

EXPOSE 8080 29418

FROM java:openjdk-8-jre

RUN apt-get -qq update
RUN apt-get install -y curl git

# Gerrit config
ENV GERRIT_USER gerrit
ENV GERRIT_HOME /var/gerrit
ENV GERRIT_WAR ${GERRIT_HOME}/gerrit.war
ENV GERRIT_SITE ${GERRIT_HOME}/review_site
ENV GERRIT_VERSION 2.13.4

RUN groupadd -r ${GERRIT_USER} --gid=1000 \
    && useradd -r -m -g ${GERRIT_USER} -d ${GERRIT_HOME} --uid=1000 ${GERRIT_USER}

RUN mkdir -p ${GERRIT_HOME}/plugins
RUN mkdir -p ${GERRIT_SITE}/plugins
RUN mkdir -p ${GERRIT_SITE}/etc

COPY bin/gerrit-start.sh /usr/local/bin/gerrit-start.sh

# Install Gerrit plugins
WORKDIR ${GERRIT_HOME}/plugins

RUN wget https://gerrit-ci.gerritforge.com/job/plugin-serviceuser-master/lastSuccessfulBuild/artifact/buck-out/gen/plugins/serviceuser/serviceuser.jar
RUN wget https://gerrit-ci.gerritforge.com/job/plugin-delete-project-stable-2.13/lastSuccessfulBuild/artifact/buck-out/gen/plugins/delete-project/delete-project.jar
RUN wget https://gerrit-ci.gerritforge.com/job/plugin-download-commands-master/lastSuccessfulBuild/artifact/buck-out/gen/plugins/download-commands/download-commands.jar

# Install Gerrit
WORKDIR ${GERRIT_HOME}
RUN wget https://gerrit-releases.storage.googleapis.com/gerrit-${GERRIT_VERSION}.war -O ${GERRIT_WAR}

# Install Kaigara
RUN curl -L https://kaigara.org/get | sh
COPY operations /opt/kaigara/operations
COPY resources /etc/kaigara/resources

RUN chown -R ${GERRIT_USER}:${GERRIT_USER} ${GERRIT_HOME}

USER ${GERRIT_USER}

EXPOSE 8080 29418

ENTRYPOINT ["kaigara"]

CMD ["start", "gerrit-start.sh"]

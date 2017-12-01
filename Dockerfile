FROM openjdk:8

MAINTAINER oabogatenko@gmail.com

# Configuration variables.
ENV JIRA_HOME     /var/atlassian/jira
ENV JIRA_INSTALL  /opt/atlassian/jira
ENV JIRA_VERSION  7.6.0

RUN mkdir -p "${JIRA_HOME}"
RUN mkdir -p "${JIRA_HOME}/caches/indexes"

RUN chmod -R 700 "${JIRA_HOME}"
RUN chown -R daemon:daemon "${JIRA_HOME}"

RUN mkdir -p "${JIRA_INSTALL}/conf/Catalina"

RUN curl -Ls "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-core-${JIRA_VERSION}.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner

RUN curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.44.tar.gz" | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar"

RUN chmod -R 700 "${JIRA_INSTALL}/conf"
RUN chmod -R 700 "${JIRA_INSTALL}/logs"
RUN chmod -R 700 "${JIRA_INSTALL}/temp"
RUN chmod -R 700 "${JIRA_INSTALL}/work"

RUN chown -R daemon:daemon "${JIRA_INSTALL}/conf"
RUN chown -R daemon:daemon "${JIRA_INSTALL}/logs"
RUN chown -R daemon:daemon "${JIRA_INSTALL}/temp"
RUN chown -R daemon:daemon "${JIRA_INSTALL}/work"

RUN echo -e "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"

RUN sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh"

USER daemon:daemon

# Expose default port
EXPOSE 8080

# Set the default working directory
WORKDIR /var/atlassian/jira

# Run Atlassian JIRA as a foreground process by default.
CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]

FROM maven:3-eclipse-temurin-22 as builder

WORKDIR /data

ARG GIT_PACKAGE_TOKEN

# Download our redis-lib
ARG REDIS_LIB_VERSION=0.0.9
RUN curl -H "Authorization: token ${GIT_PACKAGE_TOKEN}" -L -O \
  https://maven.pkg.github.com/felleslosninger/eidas-redis-lib/no/idporten/eidas/eidas-redis/${REDIS_LIB_VERSION}/eidas-redis-${REDIS_LIB_VERSION}.jar
RUN curl -H "Authorization: token ${GIT_PACKAGE_TOKEN}" -L -O \
  https://maven.pkg.github.com/felleslosninger/eidas-redis-lib/no/idporten/eidas/eidas-redis-node/${REDIS_LIB_VERSION}/eidas-redis-node-${REDIS_LIB_VERSION}.jar
RUN curl -H "Authorization: token ${GIT_PACKAGE_TOKEN}" -L -O \
  https://maven.pkg.github.com/felleslosninger/eidas-redis-lib/no/idporten/eidas/eidas-redis-specific-communication/${REDIS_LIB_VERSION}/eidas-redis-specific-communication-${REDIS_LIB_VERSION}.jar

# Logstash-logback-endcoder to enable JSON logging (needs jackson). Versions must match logback in proxy pom.xml
ARG LOG_LIB_VERSION=7.2
RUN curl -L -O https://repo1.maven.org/maven2/net/logstash/logback/logstash-logback-encoder/${LOG_LIB_VERSION}/logstash-logback-encoder-${LOG_LIB_VERSION}.jar
ARG JACKSON_LIB_VERSION=2.13.3
RUN curl -L -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/${JACKSON_LIB_VERSION}/jackson-core-${JACKSON_LIB_VERSION}.jar
RUN curl -L -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/${JACKSON_LIB_VERSION}/jackson-databind-${JACKSON_LIB_VERSION}.jar
RUN curl -L -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/${JACKSON_LIB_VERSION}/jackson-annotations-${JACKSON_LIB_VERSION}.jar

# Download & build EU-eidas software
ARG EIDAS_NODE_VERSION=2.7.1
RUN git clone --depth 1 --branch eidasnode-${EIDAS_NODE_VERSION} https://ec.europa.eu/digital-building-blocks/code/scm/eid/eidasnode-pub.git

# Add our custom libs and config to EU-eidas software before build
RUN mkdir -p eidasnode-pub/EIDAS-Node-Proxy/src/main/webapp/WEB-INF/lib && cp /data/eidas-redis-*${REDIS_LIB_VERSION}.jar eidasnode-pub/EIDAS-Node-Proxy/src/main/webapp/WEB-INF/lib/
RUN cp /data/logstash-logback-encoder-*.jar /data/jackson-*.jar eidasnode-pub/EIDAS-Node-Proxy/src/main/webapp/WEB-INF/lib/
COPY docker/proxy/config/proxySpecificCommunicationCaches.xml eidasnode-pub/EIDAS-SpecificCommunicationDefinition/src/main/resources/
COPY docker/proxy/logback.xml eidasnode-pub/EIDAS-Node-Proxy/src/main/resources/logback.xml

#Add HSM config
COPY docker/luna/hsm.cfg eidasnode-pub/EIDAS-Node-Proxy/src/main/webapp/WEB-INF/

# Build eidas proxy service
RUN cd eidasnode-pub && mvn clean install --file EIDAS-Parent/pom.xml -P NodeOnly -P-specificCommunicationJcacheIgnite -DskipTests

#HSM
COPY docker/luna/Luna_min_client.tar /tmp
RUN mkdir -p /usr/local/luna
RUN tar xvf /tmp/Luna_min_client.tar --strip 1 -C /usr/local/luna

FROM tomcat:10.1-jre11-temurin-jammy

#Fjerner passord fra logger ved oppstart
RUN sed -i -e 's/FINE/WARNING/g' /usr/local/tomcat/conf/logging.properties
# Fjerner default applikasjoner fra tomcat
RUN rm -rf /usr/local/tomcat/webapps.dist

COPY docker/bouncycastle/bcprov-jdk18on-1.78.jar /usr/local/lib/bcprov-jdk18on-1.78.jar
COPY docker/java-security-providers/java_bc.security /opt/java/openjdk/conf/security/java_bc.security

#HSM
COPY --from=builder /usr/local/luna /var/usrlocal/luna
ENV ChrystokiConfigurationPath=/var/usrlocal/luna/config
COPY docker/luna/Chrystoki.conf /var/usrlocal/luna/config/

# Tomcat config
COPY docker/proxy/server.xml ${CATALINA_HOME}/conf/server.xml
# change tomcat port
RUN sed -i 's/port="8080"/port="8082"/' ${CATALINA_HOME}/conf/server.xml

COPY docker/proxy/tomcat-setenv.sh ${CATALINA_HOME}/bin/setenv.sh

RUN mkdir -p /etc/config && chmod 777 /etc/config
COPY docker/proxy/config /etc/config/eidas-proxy
COPY docker/proxy/profiles /etc/config/profiles
RUN chmod 766 /etc/config/profiles/docker/SignModule_Service*.xml

COPY docker/addEnvironmentSpesificConfigFiles.sh docker/updateKeyStoreConfig.sh ${CATALINA_HOME}/bin/
RUN chmod 755 ${CATALINA_HOME}/bin/addEnvironmentSpesificConfigFiles.sh && chmod 755 ${CATALINA_HOME}/bin/updateKeyStoreConfig.sh

# Add war files to webapps: /usr/local/tomcat/webapps
COPY --from=builder /data/eidasnode-pub/EIDAS-Node-Proxy/target/EidasNodeProxy.war ${CATALINA_HOME}/webapps/ROOT.war

# eIDAS audit log folder
RUN mkdir -p ${CATALINA_HOME}/eidas/logs && chmod 744 ${CATALINA_HOME}/eidas/logs

EXPOSE 8082

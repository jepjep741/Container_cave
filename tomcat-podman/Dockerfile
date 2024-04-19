# Use Alpine Linux as the base image
FROM alpine:latest
ENV TZ="Europe/Helsinki"
 
# Install dependencies required for running Tomcat
RUN apk add --no-cache openjdk11 curl tar zip unzip

# Set environment variables for Java and Tomcat
COPY build/apache-tomcat-10.0.20.tar.gz /tmp/

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin
ENV TOMCAT_VERSION=10.0.20
ENV CATALINA_OPTS="-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

# Download and install CIS Hardened Tomcat

RUN  mkdir -p "$CATALINA_HOME";cd /tmp; \
tar xf apache-tomcat-*.tar.gz -C "$CATALINA_HOME" --strip-components=1;rm -rf $CATALINA_HOME/webapps/examples; \
rm -rf $CATALINA_HOME/webapps/docs;rm -rf $CATALINA_HOME/webapps/ROOT; \
rm -rf $CATALINA_HOME/webapps/host-manager;rm -rf $CATALINA_HOME/webapps/manager;rm -rf /tmp/apache-tomcat-*; \
cd $CATALINA_HOME/lib;mkdir -p org/apache/catalina/util/; \
unzip -j catalina.jar org/apache/catalina/util/ServerInfo.properties -d org/apache/catalina/util/; \
sed -i 's/server.info=.*/server.info=/g' org/apache/catalina/util/ServerInfo.properties; \
sed -i 's/server.number=.*/server.number=/g' org/apache/catalina/util/ServerInfo.properties; \
zip -ur catalina.jar org/apache/catalina/util/ServerInfo.properties;rm -rf org;
#groupadd -S tomcat;adduser -S tomcat -G tomcat;chown -R tomcat:tomcat $CATALINA_HOME
 
# Open port 8080 for the web server
EXPOSE 8080
#Healthcheck doesn't work with Podman?
#HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8080 || exit 1


# Security enhanced web.xml
COPY build/web.xml $CATALINA_HOME/conf/

# Security enhanced server.xml
COPY build/server.xml $CATALINA_HOME/conf/

# Start theTomcat

CMD ["catalina.sh", "run"]


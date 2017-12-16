FROM tomcat:9.0

ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.1
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.1
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
    && gpg --verify tomcat.tar.gz.asc \
    && tar -xvf tomcat.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat.tar.gz*

ADD ./target/*.war $CATALINA_HOME/webapps/

EXPOSE 8080

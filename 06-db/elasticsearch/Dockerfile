FROM centos:centos7
EXPOSE 9200
USER 0
ARG OS_VERSION=2.4.0
ARG OS_PATH=/opt/opensearch
ARG OS_DATA_PATH=/var/lib/opensearch
VOLUME ${OS_DATA_PATH}
ENV OPENSEARCH_JAVA_HOME=${OS_PATH}-${OS_VERSION}/jdk
ENV OS_VERSION=${OS_VERSION}
ENV OS_PATH=${OS_PATH}
ADD opensearch-${OS_VERSION}-linux-x64.tar.gz /opt/
COPY opensearch.yml ${OS_PATH}-${OS_VERSION}/config/opensearch.yml
COPY jvm.options ${OS_PATH}-${OS_VERSION}/config/jvm.options
RUN chown -R 1000:1000 ${OS_PATH}-${OS_VERSION}
RUN chown -R 1000:1000 ${OS_DATA_PATH}
USER 1000
CMD ["sh", "-c", "${OS_PATH}-${OS_VERSION}/bin/opensearch"]
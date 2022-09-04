FROM registry.cn-shenzhen.aliyuncs.com/xiaowendocker/openjdk1.8:1.8

ARG JARFILE="app-1.0.0.jar"
ARG PORT="8088"
ARG NAME="demo App"

LABEL Author="yanwen<358651752@qq.com>"
LABEL namespace="springclouddemo"
LABEL name=${NAME}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
     apk update && \
     apk upgrade
WORKDIR /app

COPY app/$JARFILE .
COPY configs/* ./configs/

ENV CONFIG_URL localhost:6082
ENV DISCOVERY_URL localhost:6082
ENV EUREKA_SERVICEURL http://localhost:6080/eureka,http://localhost:6081/eureka
ENV PORT ${PORT}
ENV PREFERRED_IP_PATTERN .*
ENV JAVA_OPTIONS "-Xms200m -Xmx1024m"
ENV _JAVA_OPTIONS "-Xms200m -Xmx1024m"

EXPOSE ${PORT}

RUN echo "#!/bin/sh" > run.sh
RUN echo "set -e" >> run.sh
RUN echo "java -jar -Duser.timezone=GMT+08 ${JARFILE}" >> run.sh
RUN chmod +x run.sh

CMD ["-c", "/app/run.sh"]

ENTRYPOINT ["/bin/sh"]
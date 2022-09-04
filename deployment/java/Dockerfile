FROM alpine
LABEL Author="yanwen<358651752@qq.com>"
LABEL namespace="lib"
LABEL name=java
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
         apk update && \
         apk upgrade && \
 apk add openjdk8 busybox tzdata curl&& \
 cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
 echo Asia/Shanghai > /etc/timezone && \
 rm -rf /tmp/* /var/cache/apk/*

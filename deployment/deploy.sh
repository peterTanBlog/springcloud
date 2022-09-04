#!/bin/bash

set -e;


eureka() {
    install "eureka" "EurekaServer"
}
configServer() {
    install "config" "ConfigServer"
}
ServiceClient() {
    install "ServiceClient" "ServiceClient"
}
ServiceClientB() {
    install "ServiceClientB" "ServiceClientB"
}
gateway() {
    install "gateway" "gateway"
}

ingress() {
    install "ingress" "ingress"
}
nginx() {
    install "nginx" "nginx"
}
# $1 Helm Chart name
# $2 project name
# $3 deploy dir
install() {
    local loc_name
    if [[ "$name" != "" ]]; then
        loc_name="$name"
    else 
        loc_name="$1"
    fi

    local path
    if [[ "$3" != "" ]]; then
        path="$3/$2"
    else
        path="$deploy_dir/$2"
    fi

    local tag
    if [[ "$version" != "" ]]; then
        tag=",imageTag=$version"
    fi

    local imageSrc
    local prof
    if [[ "$env" == "local" ]]; then
      imageSrc=$(echo "reg.yanwen.com:8443/springcloud/$2" | tr '[:upper:]' '[:lower:]')
    elif [[ "$env" == "localdev"  ]]; then
        prof="dev"
        imageSrc=$(echo "reg.yanwen.com:8443/springclouddev/$2" | tr '[:upper:]' '[:lower:]')
   elif [[ "$env" == "ali_dev"  ]]; then
        prof="dev"
        env="localdev"
        imageSrc=$(echo "registry.cn-shenzhen.aliyuncs.com/xiaowendocker/$2" | tr '[:upper:]' '[:lower:]')
    else
        prof="dev"
        imageSrc=$(echo "harbor.iss/springclouddemo/$2" | tr '[:upper:]' '[:lower:]')
         
    fi
    if [[ "$2" == "nginx" ]]; then
      imageSrc=$(echo "$2" | tr '[:upper:]' '[:lower:]')
      echo "$2: $imageSrc"
    fi 
    local cur_dir
    cur_dir=$(pwd)
    echo "path=$path,imageSrc=$imageSrc,prof=$prof,tag=$tag,namespace=$namespace,env=$env,param=$param,name=$name"
    helm lint --strict "$path" --set imageSrc="$imageSrc",namespace="$namespace",env="$env",name=$name,spring.profiles="$prof""$tag""$param"

    helm install --dry-run --debug "$path" --set imageSrc="$imageSrc",namespace="$namespace",env="$env",name=$name,spring.profiles="$prof""$tag""$param"

    if [[ $debug == true ]]; then
        return 0;
    fi

    read -r -p "continue deploy ([y]es|N) ?" confirm

    if [[ "$confirm" != "yes" && "$confirm" != "y" ]]; then
        return 1;
    fi;

    echo -e "delete release $loc_name"

    [[ $(helm ls "$loc_name" | wc -l) -gt 0 ]] && helm del --purge "$loc_name"

    helm install --name="$loc_name" "$path" --set imageSrc="$imageSrc",namespace="$namespace",env="$env",name=$name,spring.profiles="$prof""$tag""$param"

    cd "$exec_dir"
}
namespace="springclouddemolocal"
env="local"
deploy_dir="projects"
version="1.0.0"
cur_dir=$(pwd)
dir_name=$(dirname "$0")
exec_dir=$(cd "$dir_name"; pwd)
debug=false
name=""
param=""


cd "$exec_dir"

while getopts :D: opt; do
    case $opt in
        D)
           case $OPTARG in
                ver=*) version="${OPTARG//ver=/}" ;;
                name=*) name="${OPTARG//name=/}" ;;
                env=*) env="${OPTARG//env=/}" ;;
                namespace=*) namespace="${OPTARG//namespace=/}" ;;
                debug) debug=true ;;
                param=*) 
                    param="${OPTARG//param=/}" 
                    if [[ "$param" != "" ]]; then
                        param=",${param}"
                    fi
                    ;;
            esac
            ;;
        *) continue ;;
    esac
done

shift $(( OPTIND - 1 ))


if [[ $# -eq 0 ]]; then
    eureka && configServer && gateway && ServiceClient && ServiceClientB && ingress && nginx
else 
    for i in "$@"; do
        case $i in
            eureka) eureka ;;
            configServer) configServer ;;
            gateway) gateway ;;
            ServiceClient) ServiceClient ;;
             ServiceClientB) ServiceClientB ;;
             ingress) ingress;;
             nginx) nginx;;
        esac
    done
fi

cd "$cur_dir"
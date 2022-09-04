#!/bin/bash
set -e;

# $1: project name
# $2: expose port
# $3: dockerfile
build() {
    local project_name
    project_name="$1"

    local port
    port="$2"

    local jar_file="$project_name-$version"

    local mvn_path
    mvn_path="$exec_dir/../$project_name"

    local build_path
    build_path="$exec_dir/docker"

    local img
    img=$(echo "$project_name:$version" | tr '[:upper:]' '[:lower:]')
    
    cd "$mvn_path"
    echo "$settings_path"
    mvn -B -Dmaven.test.skip=true -DfinalName="$jar_file" clean package --settings $settings_path


    if [[ ! -d "$build_path/app" ]]; then
        mkdir "$build_path/app"
    else 
        rm -rf "$build_path/app/"*
    fi

    cp "target/$jar_file.jar" "$build_path/app/"

    if [[ -d "./target/configs" ]]; then
        if [[ ! -d "$build_path/configs" ]]; then
            mkdir "$build_path/configs"
        else 
            rm -rf "$build_path/configs/"*
        fi
        cp "./target/configs/"* "$build_path/configs/"
    fi

    cd "$build_path"

   local isAli
   if [[ "$env" == "aliyun_dev" ]]; then
        isAli="_ali"
       else
        isAli="" 
    fi

    local dockerfile
    if [[ "$3" != "" ]]; then
        [[ -s "$build_path/$3$isAli/Dockerfile" ]] && dockerfile="$3$isAli/Dockerfile"
  
    else
        dockerfile="default$isAli/Dockerfile"
    fi
    echo  "docker build -f $dockerfile -t $origin_local/$img -t $aliyundockerdomain/$img -t $origin_localdev/$img --build-arg PORT=$port --build-arg NAME=$project_name --build-arg JARFILE=$jar_file.jar ."

    docker build -f "$dockerfile" -t $origin_local/$img  -t $aliyundockerdomain/$img -t $origin_localdev/$img --build-arg PORT="$port" --build-arg NAME="$project_name" --build-arg JARFILE="$jar_file.jar" .
     if [[ "$env" == "local" ]]; then
     docker login $localdomain:$httpsport -u $localuser -p $localpassword
          docker push "$origin_local/$img"
     elif [[ "$env" == "localdev" ]]; then
     docker login $localdomain:$localhttpsport -u $localuser -p $localpassword
          docker push "$origin_localdev/$img"
     elif [[ "$env" == "aliyun_dev" ]]; then
      echo "docker login dockerDomain"
      docker login --username=$aliuserName $alidomain -p $alipassword
      echo " docker push $aliyundockerdomain/$img"
      docker push "$aliyundockerdomain/$img"
    fi
}
EurekaServer() {
   build "EurekaServer" 6080
}
configServer() {
   build "configServer" 5056 "withconfig"
}

ServiceClient() {
   build "ServiceClient" 6082
}
ServiceClientB() {
   build "ServiceClientB" 6084
}

gateway(){
   build "gateway" 6083
}

##harbor域名
localdomain=reg.yanwen.com
## https端口
localhttpsport=8443
localpassword=Harbor12345
localuser=admin
version="1.0.0"
cur_dir=$(pwd)
dir_name=$(dirname "$0")
exec_dir=$(cd "$dir_name"; pwd)
origin_local="$localdomain:$localhttpsport/springcloud"
origin_localdev="$localdomain:$localhttpsport/springclouddev"
aliyundockerdomain="registry.cn-shenzhen.aliyuncs.com/xiaowendocker"
aliuserName="test@1594726148325608"
alidomain="registry.cn-shenzhen.aliyuncs.com"
alipassword="t12345678"
settings_path="$MAVEN_HOME/conf/setting.xml"
env="local"

cd "$exec_dir"

while getopts :D: opt; do
    case $opt in
        D)
           case $OPTARG in
                ver=*) version="${OPTARG//ver=/}" ;;
                env=*) env="${OPTARG//env=/}" ;;
            esac
            ;;
        *) continue ;;
    esac
done

shift $(( OPTIND - 1 ))

if [[ $# -eq 0 ]]; then
    EurekaServer && configServer && ServiceClient && gateway && ServiceClientB
    docker images --filter "dangling=true" -q | while read -r id; do docker rmi --force "$id"; done
else 
    for i in "$@"; do
        case $i in
            EurekaServer) EurekaServer ;;
            configServer) configServer ;;
            ServiceClient) ServiceClient;;
             ServiceClientB) ServiceClientB;;
            gateway) gateway;;
       esac
    done
     docker images --filter "dangling=true" -q | while read -r id; do docker rmi --force "$id"; done
fi

cd "$cur_dir"

#!/bin/bash

#Colors settings
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Original work: Tasos Latsas
# Modified to work with ARM64: Tony Tran
# Display an awesome 'spinner' while running your long shell commands
#
# Do *NOT* call _spinner function directly.
# Use {start,stop}_spinner wrapper functions

function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)

    local on_success="DONE"
    local on_fail="FAIL"
    local white="\e[1;37m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local nc="\e[0m"

    case $1 in
        start)
            # calculate the column where spinner and status msg will be displayed
            let column=$(tput cols)-${#2}-8
            # display message and position the cursor in $column column
            echo -ne ${2}
            printf "%${column}s"

            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}

#Welcome message
clear;
echo -e "    .                              .o8                     oooo";
echo -e "  .o8                             \"888                     \`888";
echo -e ".o888oo oooo d8b oooo  oooo   .oooo888   .ooooo.   .oooo.o  888  oooo";
echo -e "  888   \`888\"\"8P \`888  \`888  d88' \`888  d88' \`88b d88(  \"8  888 .8P'";
echo -e "  888    888      888   888  888   888  888ooo888 \`\"Y88b.   888888.";
echo -e "  888 .  888      888   888  888   888  888    .o o.  )88b  888 \`88b.";
echo -e "  \"888\" d888b     \`V88V\"V8P' \`Y8bod88P\" \`Y8bod8P' 8\"\"888P' o888o o888o";
echo -e "${RED}==========================================================================${NC}";
echo -e "version 1.2.11 - Community Edition - Copyright (C) 2014-2024 Trudesk Inc.";
echo -e "";
echo -e "Welcome to Trudesk Install Script for Ubuntu 20.04 (fresh)!
Lets make sure we have all the required packages before moving forward..."


#Checking packages
echo -e "${YELLOW}Checking packages...${NC}"
echo -e "List of required packeges: git, wget, python3, curl, nodejs, npm, gnupg"

read -r -p "Do you want to check packeges? [Y/n]: " response </dev/tty

case $response in
[nN]*)
  echo -e "${RED}
  Packeges check is ignored!
  Please be aware that all software packages may not be installed!
  ${NC}"
  ;;

*)
start_spinner "Performing ${GREEN}apt-get update${NC}";
apt-get update > /dev/null;
stop_spinner $?;
WGET=$(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    start_spinner "${YELLOW}Installing wget${NC}"
    apt-get install wget --yes > /dev/null;
    stop_spinner $?
    elif [ $(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}wget is installed!${NC}"
  fi
PYTHON=$(dpkg-query -W -f='${Status}' python3 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' python3 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    start_spinner "${YELLOW}Installing python3${NC}"
    apt-get install python3 --yes > /dev/null;
    stop_spinner $?
    elif [ $(dpkg-query -W -f='${Status}' python3 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}python3 is installed!${NC}"
  fi
CURL=$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    start_spinner "${YELLOW}Installing curl${NC}"
    apt-get install curl --yes > /dev/null;
    stop_spinner $?
    elif [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}curl is installed!${NC}"
  fi
GNUPG=$(dpkg-query -W -f='${Status}' gnupg 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' gnupg 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    start_spinner "${YELLOW}Installing gnupg${NC}"
    apt-get install curl --yes > /dev/null;
    stop_spinner $?
    elif [ $(dpkg-query -W -f='${Status}' gnupg 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}gnupg is installed!${NC}"
  fi
GIT=$(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    start_spinner "${YELLOW}Installing git${NC}"
    apt-get install git --yes > /dev/null;
    stop_spinner $?
    elif [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}git is installed!${NC}"
  fi
NODEJS=$(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed")
  if [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    start_spinner "${YELLOW}Installing nodejs${NC}"
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash > /dev/null 2>&1
    apt-get install -y nodejs npm > /dev/null 2>&1;
    apt-get install -y build-essential > /dev/null 2>&1;
    stop_spinner $?
    elif [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 1 ];
    then
      echo -e "${GREEN}nodejs is installed!${NC}"
  fi
# NODE=$(dpkg-query -W -f='${Status}' nodejs-legacy 2>/dev/null | grep -c "ok installed")
#   if [ $(dpkg-query -W -f='${Status}' nodejs-legacy 2>/dev/null | grep -c "ok installed") -eq 0 ];
#   then
#     echo -e "${YELLOW}Installing nodejs-legacy${NC}"
#     apt-get install nodejs-legacy --yes;
#     elif [ $(dpkg-query -W -f='${Status}' nodejs-legacy 2>/dev/null | grep -c "ok installed") -eq 1 ];
#     then
#       echo -e "${GREEN}nodejs-legacy is installed!${NC}"
#   fi

  ;;
esac

echo -e ""

read -r -p "Do you want to install Elasticsearch? [y/N]: " response </dev/tty

case $response in
[yY]*)
  start_spinner "${YELLOW}Installing Elasticsearch 8${NC}"
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add > /dev/null 2>&1
  echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list > /dev/null 2>&1
  apt-get update > /dev/null;
  # apt-get install -y openjdk-8-jre > /dev/null 2>&1;
  apt-get install -y apt-transport-https elasticsearch kibana > /dev/null 2>&1;
  wget https://github.com/mikefarah/yq/releases/download/v4.20.2/yq_linux_arm64 -O /usr/bin/yq > /dev/null 2>&1
  chmod +x /usr/bin/yq > /dev/null 2>&1
  # echo "network.host: [_local_]" >> /etc/elasticsearch/elasticsearch.yml
  yq -i '."xpack.security.enabled" = false' /etc/elasticsearch/elasticsearch.yml > /dev/null 2>&1
  yq -i '."xpack.security.http.ssl".enabled = false' /etc/elasticsearch/elasticsearch.yml > /dev/null 2>&1
  chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
  systemctl enable elasticsearch
  systemctl start elasticsearch
  stop_spinner $?
  ;;
esac

read -r -p "Do you want to install MongoDB? [y/N]: " response </dev/tty
case $response in
[yY]*)
  start_spinner "${YELLOW}Installing MongoDB 5.0${NC}"
  apt-get install gnupg > /dev/null
  wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add - > /dev/null 2>&1
  curl -sLO http://launchpadlibrarian.net/475575244/libssl1.1_1.1.1f-1ubuntu2_arm64.deb | sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_arm64.deb > /dev/null 2>&1
  echo "deb [ arch=arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list > /dev/null 2>&1
  apt-get update > /dev/null;
  apt-get install -y mongodb-org mongodb-org-shell > /dev/null;
  systemctl daemon-reload
  systemctl enable mongod
  sudo service mongod start

echo -e "";
echo -e "Waiting for MongoDB to start...";
sleep 10

cat > ~/mongosetup.js <<EOL
db.system.users.remove({});
db.system.version.remove({});
db.system.version.insert({"_id": "authSchema", "currentVersion": 3});
EOL
  mongo ~/mongosetup.js > /dev/null 2>&1
  sudo service mongod restart > /dev/null 2>&1

echo "Restarting MongoDB..."
sleep 5

cat > ~/mongosetup_trudesk.js <<EOL
db = db.getSiblingDB('trudesk');
db.createUser({"user": "trudesk", "pwd": "#TruDesk1$", "roles": ["readWrite", "dbAdmin"]});
EOL
  mongo ~/mongosetup_trudesk.js > /dev/null 2>&1
  stop_spinner $?
  ;;
*)
  echo -e "${RED}MongoDB install skipped...${NC}"
  start_spinner "${YELLOW}Installing MongoDB Tools...${NC}"
  wget https://repo.mongodb.org/apt/ubuntu/dists/focal/mongodb-org/5.0/multiverse/binary-arm64/mongodb-org-database-tools-extra_5.0.6_arm64.deb > /dev/null 2>&1;
  dpkg -i mongodb-org-database-tools-extra_5.0.6_arm64.deb > /dev/null;
  rm -rf mongodb-org-database-tools-extra_5.0.6_arm64.deb
  stop_spinner $?
  ;;
esac

start_spinner "${YELLOW}Downloading the latest version of ${NC}Trudesk${RED}.${NC}"
cd ~
git clone http://www.github.com/polonel/trudesk > /dev/null 2>&1;
cd ~/trudesk
touch ~/trudesk/logs/output.log
stop_spinner $?
start_spinner "${BLUE}Building...${NC} (its going to take a few minutes)"
sudo npm install -g yarn pm2 grunt-cli > /dev/null 2>&1;
# Lets checkout the version tag
git checkout v1.2.11 > /dev/null 2>&1;
yarn install > /dev/null 2>&1;
sleep 3
stop_spinner $?
# This last line must be all in one command due to the exit nature of the build command.
start_spinner "${BLUE}Starting...${NC}" && yarn build > /dev/null && NODE_ENV=production pm2 start ~/trudesk/app.js --name trudesk -l ~/trudesk/logs/output.log --merge-logs > /dev/null && pm2 save > /dev/null && pm2 startup > /dev/null 2>&1 && stop_spinner $? && echo -e "${GREEN}Installation Complete.${NC}"
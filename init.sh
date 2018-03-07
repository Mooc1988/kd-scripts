#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin;
export PATH

if ! [ -x "$(command -v netfilter-persistent)" ]; then
  apt update
  DEBIAN_FRONTEND=noninteractive apt install iptables-persistent -y
fi

if ! [ -x "$(command -v node)" ]; then
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    apt install -y nodejs
    apt install -y build-essential
    npm install pm2 -g
fi

if ! [ -x "$(command -v git)" ]; then
  apt update
  apt install -y git
fi

if ! [ -x "$(command -v redis-server)" ]; then
  apt update
  apt install -y redis-server
fi

if [ ! -d "/home/kd-proxy" ]; then
  cd /home
  git clone https://github.com/Mooc1988/kd-proxy.git
fi

if [ ! -d "/home/kd-scripts" ]; then
  cd /home
  git clone https://github.com/Mooc1988/kd-scripts.git
fi

function add_cron(){
    crontab -l
    result=$(echo "$?" | grep "no crontab")
    if [[ "$result" != "" ]]; then
      echo "already set"
      else
      echo "empty"
    fi
}


add_cron
#bash /home/kd-scripts/deploy.sh
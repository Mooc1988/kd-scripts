#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin;
export PATH

function deploy_vpn(){
  echo "execute deploy_vpn" >> /home/log/deploy.log
  if ! [ -x "$(command -v ipsec)" ]; then
    cd /home/kd-scripts
    git pull
    cp /home/kd-scripts/data/ipsec.secrets.default  /usr/local/etc/ipsec.secrets.default
    bash /home/kd-scripts/create_ikev2_vpn.sh
  else
    ps -fe | grep ipsec | grep -v grep
    if [ $? -ne 0 ] ; then
      ipsec start
    else
      ipsec restart
    fi
  fi
  echo "finish deploy_vpn" >> /home/log/deploy.log
}

function deploy_proxy(){
  echo "execute deploy_proxy" >> /home/log/deploy.log
  cd /home/kd-proxy
  git pull
  npm install
  echo "finish deploy_proxy" >> /home/log/deploy.log
}

function set_default_config(){
  echo "set config for strongswan" >> /home/log/deploy.log
  cp /home/kd-scripts/config/strongswan/ext-auth.conf /usr/local/etc/strongswan.d/charon/ext-auth.conf
  ipsec restart
}

deploy_vpn
set_default_config
deploy_proxy

#!/bin/sh

echo "========STARTED ENTRY POINT=========="

chmod -R 777 /var/run/docker.sock

ROOT_HOME_SSH_DIR="/root/.ssh"
ROOT_HOME_ID_RSA=$ROOT_HOME_SSH_DIR"/id_rsa"
ROOT_HOME_ID_RSA_PUB=$ROOT_HOME_SSH_DIR"/id_rsa.pub"

JENKINS_HOME_SSH_DIR="/var/jenkins_home/.ssh"
JENKINS_HOME_ID_RSA=$JENKINS_HOME_SSH_DIR"/id_rsa"
JENKINS_HOME_ID_RSA_PUB=$JENKINS_HOME_SSH_DIR"/id_rsa.pub"

SSH_KEYS_VOLUME="/var/ssh_keys"
SSH_KEYS_ID_RSA=$SSH_KEYS_VOLUME"/id_rsa"
SSH_KEYS_ID_RSA_PUB=$SSH_KEYS_VOLUME"/id_rsa.pub"

if [ ! -d $ROOT_HOME_SSH_DIR ]; then
  mkdir $ROOT_HOME_SSH_DIR;
  ssh-keyscan github.com >> $ROOT_HOME_SSH_DIR/known_hosts
fi

if [ ! -d $JENKINS_HOME_SSH_DIR ]; then
  mkdir $JENKINS_HOME_SSH_DIR;
  chown jenkins $JENKINS_HOME_SSH_DIR;
  ssh-keyscan github.com >> $JENKINS_HOME_SSH_DIR/known_hosts
fi

if [ -d $SSH_KEYS_VOLUME ] ; then
  # Root
  if [ ! -f $ROOT_HOME_ID_RSA ] && [ -f $SSH_KEYS_ID_RSA ]; then
    # id_rsa
    echo "Need to copy ssh key"
    cp $SSH_KEYS_ID_RSA $ROOT_HOME_ID_RSA
    chmod 600 $ROOT_HOME_ID_RSA
    echo "Root home dir: " $ROOT_HOME_ID_RSA
    ls -la $ROOT_HOME_ID_RSA
    ls -la $SSH_KEYS_ID_RSA
  fi
  if [ ! -f $ROOT_HOME_ID_RSA_PUB ] && [ -f $SSH_KEYS_ID_RSA_PUB ]; then
    # id_rsa.pub
    echo "Need to copy ssh key"
    cp $SSH_KEYS_ID_RSA_PUB $ROOT_HOME_ID_RSA_PUB
    chmod 600 $ROOT_HOME_ID_RSA_PUB
  fi

  # Jenkins
  if [ ! -f $JENKINS_HOME_ID_RSA ] && [ -f $SSH_KEYS_ID_RSA ]; then
    # id_rsa
    echo "Need to copy ssh key"
    cp $SSH_KEYS_ID_RSA $JENKINS_HOME_ID_RSA
    chmod 600 $JENKINS_HOME_ID_RSA
    chown jenkins $JENKINS_HOME_ID_RSA
  fi
  if [ ! -f $JENKINS_HOME_ID_RSA_PUB ] && [ -f $SSH_KEYS_ID_RSA_PUB ]; then
    # id_rsa.pub
    echo "Need to copy ssh key pub"
    cp $SSH_KEYS_ID_RSA_PUB $JENKINS_HOME_ID_RSA_PUB
    chmod 600 $JENKINS_HOME_ID_RSA_PUB
    chown jenkins $JENKINS_HOME_ID_RSA_PUB
  fi
fi

exec "$@"

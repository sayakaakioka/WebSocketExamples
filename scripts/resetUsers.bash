#!/bin/bash -x

USER_PREFIX="ndsemi"
PUBKEY_DIR="/home/ubuntu/keys"
PUBKEY_SUFFIX=".pem.pub"

for i in `seq -f %02g 1 8`
do
	USERID=${USER_PREFIX}${i}
	userdel -r ${USERID}
	adduser ${USERID} --disabled-password --quiet --gecos ${USERID}

	USERHOME=/home/${USERID}
	mkdir ${USERHOME}/.ssh
	chmod 700 ${USERHOME}/.ssh
	cp ${PUBKEY_DIR}/${USERID}${PUBKEY_SUFFIX} ${USERHOME}/.ssh/authorized_keys
	chmod 600 ${USERHOME}/.ssh/authorized_keys
	chown -R ${USERID}.${USERID} ${USERHOME}/.ssh

	mkdir ${USERHOME}/public_html
	chown -R ${USERID}.${USERID} ${USERHOME}/public_html

	ls -al ${USERHOME}
	ls -al ${USERHOME}/.ssh
done


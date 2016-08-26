#!/bin/sh
if [ ! -e /data/murmur.ini ]; then
	echo Starting Initialization
	cp /etc/murmur.tpl /data/murmur.ini
	if [ ! -z "$SERVER_PASSWORD" ] ; then echo 'serverpassword='"$SERVER_PASSWORD" >> /data/murmur.ini ; fi
	if [ ! -z "$MAX_USERS" ] ; then echo 'users='"$MAX_USERS" >> /data/murmur.ini ; fi
	if [ ! -z "$SERVER_TEXT" ] ; then echo 'welcometext='"$SERVER_TEXT" >> /data/murmur.ini ; fi
	if [ ! -z "$REGISTER_NAME" ] ; then echo 'registerName='"$REGISTER_NAME" >> /data/murmur.ini ; fi
	if [ ! -z "$BANDWIDTH" ] ; then echo 'bandwidth='"$BANDWIDTH" >> /data/murmur.ini ; fi
	if [ ! -z "$SUPW" ] ; then /usr/bin/murmur -fg -ini /data/murmur.ini -supw $SUPW ;fi
	echo Initilization Completed 
fi

su murmur -c "/usr/bin/murmur -fg -ini /data/murmur.ini"

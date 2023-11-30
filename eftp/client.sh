#!/bin/bash
echo $#
if [ $# -eq 0 ]
then
 SERVER="localhost"
 elif [$# -eq 1 ]
 SERVER=$1
IP=`ip address | grep inet | head -n3 | tail -n 1| cut -d " " -f 6 | cut -d "/" -f 1`
echo $IP 
TIMEOUT=1
echo "cliente de EFTP"
echo "(1) Send"
echo "EFTP 1.0" | nc $SERVER 3333

echo "(2) Listen"

DATA=`nc -l -p 3333 -w $TIMEOUT`

echo $DATA

echo "(5) Test $ Send"

if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR 1: BAD HEADER"
	exit 1

fi

echo "BOOOM"
sleep 1
echo "BOOOM" | nc $SERVER 3333

echo "(6) Listen"

DATA=`nc -l -p 3333 -w $TIMEOUT`

echo $DATA

echo "(9) Test"

if [ "$DATA" != "OK_HANDSHAKE" ]
then
	sleep 1
	echo "ERROR 3: BAD HANDSHAKE"
	exit 3
fi

	echo "(10) Send"
	 FILE_NAME="fary1.txt"
    FILE_MD5=`echo $FILE_NAME | md5sum | cut -d " " -f 1`
	sleep 1
	echo " FILE_NAME $FILE_NAME $FILE_MD5" | nc $SERVER 3333
	echo "(11)Listen"
	DATA=`nc -l -p 3333 -w $TIMEOUT`
	echo "(14)Test&Send"
	if [ $DATA != "OK_FILE_NAME" ]
	then echo "ERROR 3: BAD FILE NAME PREFIX"
		exit 3
	fi
	sleep 1 
	cat imgs/fary1.txt | nc $SERVER 3333
	echo "(15)Listen"
	DATA=`nc -l -p 3333 -w $TIMEOUT`
	 if [ "$DATA" != "OK_DATA" ]
	 then 
		 echo "ERROR 4: BAD DATA"
		 exit 4
	 fi
	 echo "(18)Send"
	 FILE_MD5=`cat imgs/$FILE_NAME | md5sum | cut -d " " -f 1`
	 echo "file_md5 $FILE_MD5" | nc $SERVER 3333
	 echo "(19)Listen"
	 DATA=`nc -l -p 3333 -w $TIMEOUT`
echo "(21)Test"
if [ "$DATA" != "OK_FILE_MD5" ]
exit 5
echo "FIN"
 exit 0

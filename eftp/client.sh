#!/bin/bash
IP=`ip address | grep inet | head -n3 | tail -n 1| cut -d " " -f 6 | cut -d "/" -f 1`
SERVER= "localhost "
echo "cliente de EFTP"
echo "(1)Send "
echo "EFTP 1.0 " | nc localhost 3333
echo "(2)Listen "
DATA= `nc -l -p 3333 -w 0`
echo $DATA 
echo "(5)Test & Send"
if [ " &DATA" != "OK_HEADER"]
then echo "ERROR 1: BAD HEADER"
	exit 1 
	fi
	echo "BOOOM"
	sleep 1
	echo "BOOOM" | nc localhost 3333
	echo "(6)Listen"
	DATA `nc -l -p 3333 -w 0`
	echo $DATA
	echo "(9)Test"
	if [ "$DATA" != "OK_HANDSHAKE" ]
	then echo "ERROR 2: BAD HANDSHAKE"
		exit 2
	fi
	FILE_NAME=fary1.txt
	FILE_MD5=`echo $FILE_NAME | md5sum | cut -d " " -f 1`
	echo "(10) Send"
	sleep 1
	echo " FILE_NAME $FILE_NAME" | nc $SERVER 3333
	echo "(11)Listen"
	DATA=`nc -l -p 3333 -w 0`
	echo "(14)Test&Send"
	if [ $DATA != "OK_FILE_NAME" ]
	then echo "ERROR 3: BAD FILE NAME PREFIX"
		exit 3
	fi
	sleep 1 
	cat imgs/fary1.txt | nc $SERRVER 3333
	echo "(15)Listen"
	DATA= `nc -l -p 3333 -w 0`
	 if [ "$DATA" != "OK_DATA" ]
	 then 
		 echo "ERROR 4: BAD DATA"
		 exit 4
	 fi
	 echo "(18)Send"
	 FILE_MD5=`cat imgs/$FILE_NAME | md5sum | cut -d " " -f 1`
	 echo "file_md5 $FILE_MD5" | nc $SERVER 3333
	 echo "(19)Listen"
	 DATA=`nc -l -p 3333 -w 0`

echo "FIN"
 exit 0

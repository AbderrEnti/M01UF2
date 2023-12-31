#!/bin/bash

CLIENT="10.65.0.61"
TIMEOUT=1
echo "Servidor de EFTP"

echo "(0) Listen"
DATA=`nc -l -p 3333 -w $TIMEOUT`
PREFIX=`echo $DATA | cut -d " " -f 1`
VERSION=`echo $DATA | cut -d " " -f 2`

echo "(3) Test & Send"

if [ "$DATA" != "EFTP 1.0" ]
then
	echo "ERROR 1: BAD HEADER"
	sleep 1
	echo "KO_HEADER" | nc $CLIENT 3333
	exit 1
fi

echo "OK_HEADER"
sleep 1
echo "OK_HEADER" | nc $CLIENT 3333

echo "(4) Listen"

DATA=`nc -l -p 3333 -w $TIMEOUT`

echo $DATA

echo "(7) Test & Send"
if [ "$DATA" != "BOOOM" ]
then echo "ERROR 2: BAD HANDSHAKE"
sleep 1
echo "KO_HANDSHAKE" | nc $CLIENT 3333
exit 2
fi

echo "OK_HANDSHAKE"
sleep 1
echo "OK_HANDSHAKE" | nc $CLIENT 3333
echo "(8)Listen"
	DATA=`nc -l -p 3333 -w $TIMEOUT`
	echo $DATA
echo "(12)Test&Store&Send"
PREFIX=`echo $DATA | cut -d " " -f 1`
if [ "$PREFIX" != "FILE_NAME" ]
then echo "ERROR 3:BAD FILE_NAME PREFIX"
	sleep 1 
	echo "KO_FILE_NAME" | nc $CLIENT 3333
       exit 3
fi

echo "OK_FILE_NAME" | nc $CLIENT 3333
echo "(13)Listen"
nc -l -p 3333-w $TIMEOUT > inbox/$FILE_NAME
DATA=`cat inbox/$FILE_NAME`
echo "(16)Store&Send"
if [ "$DATA" == "" ]
then 
	echo "ERROR 4: EMPTY DATA"
	sleep 1
	echo "KO_DATA" | nc $CLIENT 3333
fi

echo $DATA > inbox/$FILE_NAME
sleep 1 
echo "OK_DATA" | nc $CLIENT 3333

echo "(17)Listen"
DATA=`nc -l -p 3333 -w $TIMEOUT`
echo "(20)Test&Send"
echo $DATA 
PREFIX=`echo $DATA | cut -d " " -f 1`
if [ "$PREFIX" != "FILE_MD5" ] 
echo "ERROR 5: BAD FILE MD5 PREFIX"
    echo "KO_FILE_MD5" | nc $CLIENT 3333
    exit 5
	FILE_MD5_LOCAL=`cat inbox/$FILE_NAME | md5sum | cut-d " " -f 1`
if [ "$FILE_MD5" != "$FILE_MD5_LOCAL" ]
then
echo "ERROR 5: BAD FILE MD5 PREFIX"
    echo "KO_FILE_MD5" | nc $CLIENT 3333
    exit 5
fi
 echo "OK_FILE_MD5" | nc $CLIENT $PORT
	echo "FIN"
	exit 0














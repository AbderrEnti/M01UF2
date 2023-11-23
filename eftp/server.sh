#!/bin/bash
CLIENT="10.65.0.61"
echo "sevidor de EFTP"
echo "(0)Listen"
DATA=`nc -l -p 3333 -w 0`
echo $DATA
echo "(3)Test & Sed"
if [ "$DATA" != "EFTP 1.0 " ]
then  
 echo "ERROR 1 : BAD HEADER"
sleep 1 
echo "KO_HEADER" nc localhost 3333
       exit 1	
fi
echo "OK_HEADER"
sleep 1
echo "OK_HEADER" | nc localhost 3333
echo "(4) Listen"
DATA=`nc -l -p 3333 -w 0`
echo "(7)Test $ Send"
echo $DATA
if $[ "$DATA" != "BOOOM" ]
 then
	 echo "ERROR 2: BAD HANDSHAKE2"
	 sleep 1
	 echo "KO_HANDSHAKE" | nc $CLIENT 3333
	 exit 2 
 
fi
sleep 1
echo "OK_HANDSHAkE" 
echo "(8)Listen"
	DATA=`nc -l -p 3333 -w 0`
echo "(12)Test&Store&Send"
PREFIX= echo`$DATA | cut -d " " -f 1`
if [ "$PREFIX" != "FILE_NAME" ]
then echo "ERROR 3:BAD FILE_NAME PREFIX"
	sleep 1 
	echo "KO_FILE_NAME" | nc $CLIENT 3333
       exit 3
fi

FILE_NAME=`echo $DATA | cut -d " " -f 2`
echo "(13)Listen"
DATA= `nc -l -p 3333-w 0`
echo "(16)Store&Send"
if [ "$DATA" == "" ]
then 
	echo "ERROR 4: EMPTY DATA"
	sleep 1
	echo "KO_DATA" | NC $CLIENT 3333
fi

echo $DATA > inbox/$FILE_NAME
sleep 1 
echo "OK_DATA" | nc $CLIENT 3333
exit 0

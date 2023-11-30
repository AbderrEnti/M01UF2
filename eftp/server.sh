#!/bin/bash
CLIENT="10.65.0.61"
TIMEOUT=1
echo "sevidor de EFTP"
echo "(0)Listen"
DATA=`nc -l -p 3333 -w $TIMEOUT`
echo $DATA
echo "(3)Test & Sed"
if [ "$DATA" != "EFTP 1.0" ]
then 
 echo "ERROR 1 : BAD HEADER"
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
echo "(7)Test $ Send"
if [ "$DATA" != "BOOOM" ]
 then
	 echo "ERROR 2: BAD HANDSHAKE2"
	 sleep 1
	 echo "KO_HANDSHAKE" | nc $CLIENT 3333
	 exit 2 
 
fi
sleep 1
echo "OK_HANDSHAkE" 
echo "(8)Listen"
	DATA= `nc -l -p 3333 -w $TIMEOUT`
	echo $DATA
echo "(12)Test&Store&Send"
PREFIX= echo`$DATA | cut -d " " -f 1`
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
exit 0

echo "(17)Listen"
DATA=`nc -l -p 3333 -w $TIMEOUT`
echo "(20)Test&Send"















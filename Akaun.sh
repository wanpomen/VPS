#!/bin/bash

data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "----------------------";
echo "    DROPBEAR LOGIN    ";
echo "----------------------";

for PID in "${data[@]}"
do
#echo "check $PID";
	NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
	USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
	IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
	if [ $NUM -eq 1 ]; then
		echo "$PID - $USER - $IP";
	fi
done

echo "";

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

echo "----------------------";
echo "    OPENSSH LOGIN     ";
echo "----------------------";

for PID in "${data[@]}"
do
        #echo "check $PID";
	NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
	USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
	IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
        fi
done

echo "";

echo "---------------------------------------------"
echo " Multi Login = Kill "
echo " Cara pakai : Kill Nombor PID "
echo "---------------------------------------------"



echo "---------------------------------------------"
echo "BIL  USERNAME        STATUS       EXP DATE "
echo "---------------------------------------------"
C=1
ON=0
OFF=0
while read mumetndase
do
        AKAUN="$(echo $mumetndase | cut -d: -f1)"
        ID="$(echo $mumetndase | grep -v nobody | cut -d: -f3)"
        exp="$(chage -l $AKAUN | grep "Account expires" | awk -F": " '{print $2}')"
        online="$(cat /etc/openvpn/log.log | grep -Eom 1 $AKAUN | grep -Eom 1 AKAUN)"
        if [[ $ID -ge 1000 ]]; then
        if [[ -z $online ]]; then
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$AKAUN" "OFFLINE" "$exp"
        OFF=$((OFF+1))
        else
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$AKAUN" "ONLINE" "$exp"
        ON=$((ON+1))
        fi
        C=$((C+1))
        fi done < /etc/passwd
echo "---------------------------------------------"
echo " ONLINE : $ON OFFLINE : $OFF      [ WanPomen ] "
echo "---------------------------------------------"


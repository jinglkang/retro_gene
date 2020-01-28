# Author : Li Heng
# Contact: liheng@genomics.org.cn

if [ $# -lt 2 ]; then
	echo "Usage: multi_run.sh <key> <number> [<wait>=20]"
	exit 1;
fi

key=$1
number=$2
waitsec=20
own=`whoami`

if [ $# -ge 3 ]; then
	waitsec=$3
fi

while read comm; do
	while [ `ps -lef | grep $own | grep $key | grep -cv grep` -ge $number ]; do
		sleep $waitsec
	done
	echo $comm | sh
done

while [ `ps -lef | grep $own | grep $key | grep -cv grep` -gt 0 ]; do
	sleep $waitsec
done

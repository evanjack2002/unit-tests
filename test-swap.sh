#!/bin/bash

echo b main >> _tmp.gdb
echo r >> _tmp.gdb
echo source scripts/create_list.gdb >> _tmp.gdb
echo source scripts/printf_list.gdb >> _tmp.gdb
echo source scripts/find_node_address.gdb >> _tmp.gdb
echo 'source scripts/free_list.gdb' >> _tmp.gdb

echo 'set $head = (List*)0' >> _tmp.gdb
echo 'set $node1 = (List*)0' >> _tmp.gdb
echo 'set $node2 = (List*)0' >> _tmp.gdb

exec < $1
read var
echo 'create_list $head' $var >> _tmp.gdb

exec < $1
echo ' '>>$2
echo 'set logging file '$2 >> _tmp.gdb

while read var
do
	read var
	node_1=$var
	read var
	node_2=$var

	echo 'set logging on' >> _tmp.gdb
	echo 'p "test begin"' >> _tmp.gdb

	echo 'p "old_list"' >> _tmp.gdb
	echo 'printf_list $head' >> _tmp.gdb
	echo 'set logging off' >> _tmp.gdb
	echo 'find_node_address $head '$node_1' $node1' >> _tmp.gdb
	echo 'find_node_address $head '$node_2' $node2' >> _tmp.gdb
	echo 'p $head = swap($head,$node1,$node2)' >> _tmp.gdb
	echo 'set logging on' >> _tmp.gdb
	echo 'p "change '$node_1'  '$node_2'"' >> _tmp.gdb
	echo 'p "new_list"' >> _tmp.gdb
	echo 'printf_list $head' >> _tmp.gdb
	echo 'set logging off' >> _tmp.gdb
	echo 'free_list $head' >> _tmp.gdb
done

gdb -q -x _tmp.gdb bin-swap >> /dev/null

rm _tmp.gdb

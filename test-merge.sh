#!/bin/bash

echo 'b main' >> _tmp.gdb
echo 'r' >> _tmp.gdb
echo 'source scripts/create_list.gdb' >> _tmp.gdb
echo 'source scripts/print_list.gdb' >> _tmp.gdb
echo 'source scripts/find_node_address.gdb' >> _tmp.gdb
echo 'source scripts/free_list.gdb' >> _tmp.gdb

echo 'set $head = (List**)malloc(sizeof(List*))' >> _tmp.gdb

echo 'set logging file '$2>>_tmp.gdb

echo ' '>>$2
exec < $1

echo 'p merge_sort' >> _tmp.gdb

while read var
do
	list_length=$var

	echo 'create_list (*($head)) '$list_length >> _tmp.gdb
	read var
	list_value=$var

	echo 'set $_head = (*($head))' >> _tmp.gdb

	for value in ${list_value[@]}
	do
		echo 'p $_head->value = '$value >> _tmp.gdb
		echo 'p $_head = $_head->next' >> _tmp.gdb
	done
	read var

	echo 'set logging on' >> _tmp.gdb
	echo 'p "test begin"' >> _tmp.gdb
	echo 'p "old_list"' >> _tmp.gdb
	echo 'printf_list (*($head))' >> _tmp.gdb
	echo 'set logging off' >> _tmp.gdb

	echo 'set $_head_l = (*($head))' >> _tmp.gdb
	echo 'set $_head_r = (List *)0' >> _tmp.gdb
	echo 'set $left = '$list_length/2 >> _tmp.gdb
	echo 'set $right = '$list_length'-$left' >> _tmp.gdb

	echo 'find_node_address $_head_l $left+1 $_head_r' >> _tmp.gdb
	echo 'p merge_sort($_head_l, $_head_r, $left, $right)' >> _tmp.gdb

	echo 'set logging on' >> _tmp.gdb
	echo 'p "new_list"' >> _tmp.gdb
	echo 'printf_list (*($head))' >> _tmp.gdb

	echo 'set logging off' >> _tmp.gdb
	echo 'free_list (*($head))' >> _tmp.gdb
done

echo 'q' >> _tmp.gdb
echo 'y' >> _tmp.gdb

gdb -q -x _tmp.gdb bin-merge >>/dev/null

rm _tmp.gdb

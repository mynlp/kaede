#!/usr/bin/env perl

use encoding 'euc-jp';

# ������ʹ�ǰ����ε�������ǽ�ʣ���Ƥ���ʸ����

while ( <STDIN> ) {

    if (/^\# S-ID:([\d\-]+) (���κ��|�ͼ���):(.+\n)$/) {
	$id = $1;
	$sentence = $3;
	$check{$sentence} = $id;

	print;
    }
    elsif (/^\# S-ID:([\d\-]+)[\n ]/ && !/(���κ��|�ͼ���)/) {
	$id = $1;
	$all_id = $_;
	$sentence = <STDIN>;

	if ($check{$sentence}) {

	    # ��ʣ���Ƥ���С�ʸ��ID�Ԥ˽��Ϥ���

	    chop($all_id);
	    print "$all_id ��ʣ:$check{$sentence}$sentence";
	}
	else {

	    # ��ʣ���Ƥ��ʤ�����̾���ϡ��ơ��֥��ɲ�

	    print $all_id;
	    print $sentence;
	    $check{$sentence} = $id;
	}
    }
    else {
	print;
    }
}

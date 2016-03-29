#!/usr/bin/env perl

# ��ʸ���Ϸ�̤��ڹ�¤ɽ��
#
# Usage: tree.pl < input

use Encode qw(encode);
use encoding 'euc-jp';

$pos_mark{"�ü�"} =  '*';
$pos_mark{"ư��"} =  'v';
$pos_mark{"���ƻ�"} =  'j';
$pos_mark{"Ƚ���"} =  'c';
$pos_mark{"��ư��"} =  'x';
$pos_mark{"̾��"} =  'n';
$pos_mark{"��ͭ̾��"} =  'N';	# ����
$pos_mark{"��̾"} =  'J';	# ����
$pos_mark{"��̾"} =  'C';	# ����
$pos_mark{"�ȿ�̾"} =  'A';	# ����
$pos_mark{"�ؼ���"} =  'd';
$pos_mark{"����"} =  'a';
$pos_mark{"����"} =  'p';
$pos_mark{"��³��"} =  'c';
$pos_mark{"Ϣ�λ�"} =  'm';
$pos_mark{"��ư��"} =  '!';
$pos_mark{"��Ƭ��"} =  'p';
$pos_mark{"������"} =  's';
$pos_mark{"̤�����"} =  '?';

######################################################################
# ����
######################################################################

sub read_sentence {

    my ($i);

    $bnst_num = 0;
    $mrph_num = 0;

    $_ = <STDIN>;
    if (/BM: (.*)\n/) {
	@mark = split(/ /, $1);
    } else {
	@mark = ();
    }
    print;	# ʸID�ν���

    while ( <STDIN> ) {
	chop;
	if (/^\*/) {
	    $mrph_data_start[$mrph_num] = 1;
	    $bnst_data_start[$bnst_num] = $mrph_num;
	    /^\* [\-0-9]+ ([\-0-9]+)([DPIA])/;	# �ѹ���
	    $bnst_data_dpnd[$bnst_num] = $1;
	    $bnst_data_type[$bnst_num] = $2;
	    $bnst_num++;
	}
	elsif (/^EOS/) {
	    $bnst_data_start[$bnst_num] = $mrph_num; # �����ΰ�
	    last;
	}
	else {
	    @{$mrph_data_all[$mrph_num]} = split;
	    $mrph_num++;
	}
    }

    if ($mrph_num) {
	return 1;
    } else {
	return 0;
    }
}

######################################################################
# �����ɽ������ʸ�����
######################################################################

sub draw_all {

    my (@error_bnst) = @_;
    my ($i, $j);
    my ($length, $diff);
    my $max_length = 0;

    for ($i = 0; $i < $bnst_num; $i++) {
	$line[$i] = &make_bnst_string($i);
    }

    foreach $i (@error_bnst) {
	$line[$i] = "��" . $line[$i];
    }

    for ($i = 0; $i < $bnst_num; $i++) {
	for ($j = $i + 1; $j < $bnst_num; $j++) {
	    $line[$i] .= $item[$i][$j];
	}

	$length = do { use bytes; length(encode('euc-jp', $line[$i])) };
	if ($max_length <= $length) {
	    $max_length = $length;
	}
    }

    for ($i = 0; $i < $bnst_num; $i++) {
	$diff = $max_length - do { use bytes; length(encode('euc-jp', $line[$i])) };
	print ' ' x $diff;
# 	for ($j = 0; $j < $diff; $j++) {
# 	    print " ";
# 	}
	print "$line[$i]\n";
    }
}

######################################################################
# �����ɽ������ʸ�����
######################################################################

sub make_bnst_string {

    my ($b_num) = @_;
    my ($string, $i);

    for ($i = $bnst_data_start[$b_num]; 
	 $i < $bnst_data_start[$b_num+1]; $i++) {
	$string .= $mrph_data_all[$i][0];
	# next; �ʻ�ޡ���������ʤ����
	if ($mrph_data_all[$i][4] eq "��ͭ̾��" ||	# �ѹ���
	    $mrph_data_all[$i][4] eq "��̾" ||		# �ѹ���
	    $mrph_data_all[$i][4] eq "��̾" ||		# �ѹ���
	    $mrph_data_all[$i][4] eq "�ȿ�̾") { 	# �ѹ���
	    $string .= $pos_mark{$mrph_data_all[$i][4]};# �ѹ���
	} else {
	    $string .= $pos_mark{$mrph_data_all[$i][3]};
	}
    }

    $string;
}

######################################################################
# ����γƹ�ɽ��
######################################################################

sub draw_matrix {

    my $i, $j, $para_row, @active_column;

    for ($i = 0; $i < $bnst_num; $i++) {
	$active_column[$i] = 0;
    }

    for ($i = 0; $i < ($bnst_num - 1); $i++) {

	if ($bnst_data_type[$i] eq "P") {
	    $para_row = 1;
	} else {
	    $para_row = 0;
	}

	for ($j = $i + 1; $j < $bnst_num; $j++) {

	    if ($j < $bnst_data_dpnd[$i]) {
		if ($active_column[$j] == 2) {
		    if ($para_row == 1) {
			$item[$i][$j] = "��";
		    } else {
			$item[$i][$j] = "��";
		    }
		} elsif ($active_column[$j] == 1) {
		    if ($para_row == 1) {
			$item[$i][$j] = "��";
		    } else {
			$item[$i][$j] = "��";
		    }
		} else {
		    if ($para_row == 1) {
			$item[$i][$j] = "��";
		    } else {
			$item[$i][$j] = "��";
		    }
		}
	    }
	    elsif ($j == $bnst_data_dpnd[$i]) {
		if ($bnst_data_type[$i] eq "P") {
		    $item[$i][$j] = "��";
		} elsif ($bnst_data_type[$i] eq "I") {
		    $item[$i][$j] = "��";
		} elsif ($bnst_data_type[$i] eq "A") {
		    $item[$i][$j] = "��";
		} else {
		    if ($active_column[$j] == 2) {
			$item[$i][$j] = "��";
		    } elsif ($active_column[$j] == 1) {
			$item[$i][$j] = "��";
		    } else {
			$item[$i][$j] = "��";
		    }
		}

		if ($active_column[$j] == 2) {
		    ;		# ���ǤˣФ��������������Ф��Τޤ�
		} elsif ($para_row) {
		    $active_column[$j] = 2;
		} else {
		    $active_column[$j] = 1;
		}
	    } else {
		if ($active_column[$j] == 2) {
		    $item[$i][$j] = "��";
		} elsif ($active_column[$j] == 1) {
		    $item[$i][$j] = "��";
		} else {
		    $item[$i][$j] = "��";
		}
	    }
	}
    }
}

######################################################################
# MAIN
######################################################################

while ( &read_sentence() ) {
    &draw_matrix();
    &draw_all(@mark);
}

######################################################################
# END
######################################################################

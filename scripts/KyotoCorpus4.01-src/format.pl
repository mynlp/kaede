#!/usr/bin/env perl

use encoding 'euc-jp';
binmode(STDERR, ':encoding(euc-jp)');

# �����ѥ��Υ�����
$TYPE = "�����ǡ���ʸ�����ѥ�";
# $TYPE = "ʸ̮�����ѥ�";

#
# �оݳ��Ȥ��뵭����ʸ
#
$neglect_aid{"950101140"} = 1;	# ����Ҳ�
$neglect_aid{"950110251"} = 1;	# ���Ϥ��Ͽ̶���
$neglect_aid{"950112293"} = 1;	# ���ʼ԰���
$neglect_aid{"950118034"} = 1;	# ��̾����
$neglect_aid{"950118035"} = 1;	# ��̾����
$neglect_aid{"950118045"} = 1;	# ��̾����
$neglect_aid{"950118046"} = 1;	# ��̾����
$neglect_aid{"950118240"} = 1;	# ��̾����
$neglect_aid{"950118241"} = 1;	# ��̾����
$neglect_aid{"950118243"} = 1;	# ��̾����
$neglect_aid{"950118244"} = 1;	# ��̾����
$neglect_aid{"950118245"} = 1;	# ��̾����
$neglect_aid{"950118250"} = 1;	# ��̾����
$neglect_aid{"950118252"} = 1;	# ��̾����
$neglect_aid{"950118253"} = 1;	# ��̾����
$neglect_aid{"950118254"} = 1;	# ��̾����

my ($dirname) = ($0 =~ /^(.*?)[^\/]+$/);
$GIVEUP = $dirname ? "${dirname}giveup.dat" : "giveup.dat";
$OK = $dirname ? "${dirname}ok.dat" : "ok.dat";

@enu = ("��", "��", "��", "��", "��", "��", "��", "��", "��", "��");
$start_flag = 0;

# �����ν���

$DATE = "";
for ($i = 0; ; $i++) {
    if ($ARGV[$i] =~ /^\-/) {
	if ($ARGV[$i] eq "-all") {
	    $SUBJECT = "������";
	} elsif ($ARGV[$i] eq "-ed") {
	    $SUBJECT = "����";
	} elsif ($ARGV[$i] eq "-exed") {
	    $SUBJECT = "����ʳ�";
	}
    } else {
	$DATE = $ARGV[$i];
	last;
    }
}
die if (!$DATE || $DATE !~ /^95/); 

######################################################################
#		  ������ʹCD-ROM�ǡ����Υե����ޥå�
######################################################################

#
# giveup.dat ��������ɤ߹��ߡ�������롥
#

if (open(GIVEUP, $GIVEUP)) {
    while ( <GIVEUP> ) {
	if (/^([\d-]+)/) {
	    $neglect_h_sid{$1} = 1;
	}
    }
    close(GIVEUP);
}

#
# ok.dat ��������ɤ߹��ߡ�������롥
#

if (open(OK, '< :encoding(euc-jp)', $OK)) {
    while ( <OK> ) {
	if (/^(?:\# S-ID:)?([\d-]+)(.*)/) {
	    my ($id, $str) = ($1, $2);
	    $ok_h_sid{$id} = 1;
	    while ($str =~ / ��ʬ���:(\d+):([^ ]+)/g) {
		$ok_h_check{$id}{$1} = $2;
	    }
	}
    }
    close(OK);
}

while ( <STDIN> ) {

    $whole_article .= $_;

    if (/<\/ENTRY>/) {
	if ($start_flag) {
	    &check_article($aid, $title, $article);
	    # �����˶��ڤ����
	    # print "$aid\n$title\n$article\n\n";
	    # print $whole_article;
	}
	$article = "";
	$whole_article = "";
    } elsif (/<C0>/) {
	/^<C0>(.+)<\/C0>\n/;
	$aid = $1;
	if ($aid =~ /^$DATE/) {
	    $start_flag = 1;
	} else {
	    if ($start_flag) {
		exit;
	    } else {
		;
	    }
	}
    } elsif (/<T1>/) {
	/^<T1>(.+)<\/T1>\n/;
	$title = $1;
    } elsif (/<T2>/) {
	$flag = 1;
    } elsif (/<\/T2>/) {
	$flag = 0;
    } else {
	$article .= $_ if ($start_flag && $flag);
    }
}

######################################################################
# �����ѥ����������ӽ����뵭��
#
# �������ȥ�˼���ʸ���󤬤�����
#	��;Ͽ��
#	�λ���Ģ��
#	�μҹ��
#	�οͻ���
#	�ο�ʪά���
#	����
#
# ����ʸ���(������Ƭ�������)���ڡ�����ޤ���
#   (���ڡ�����2��Ϣ³�������ɽ�ʤɤϤۤȤ�ɾʤ��뤬���Ȥꤢ������ñ��
#    ���᥹�ڡ�������ĤǤ�������ӽ�����)
#
# ��������Ƭ��"������"��������
#   (���󥿥ӥ塼������ȯ����̾��ȯ�����Τ���̤˰Ϥޤ���ǽ���ʤɤ�����
#    ����)
#
######################################################################

sub check_article
{
    local($aid, $title, $article) = @_;
    local($i, $flag);

    $flag = 1;

    if ($neglect_aid{$aid}) {
	$flag = 0;
    }
    elsif ($title =~ 
	/��;Ͽ��|�λ���Ģ��|�μҹ��|�οͻ���|�ο�ʪά���|����|����򵷡����̼�/) {
	$flag = 0;
    }
    elsif (($SUBJECT eq "����" && $title !~ /�μ����/) || 
	   ($SUBJECT eq "����ʳ�" && $title =~ /�μ����/)) {
	$flag = 0;
    }
    else {
	foreach $i (split(/\n/, $article)) {
	    $flag = 0 if ($i =~ /������/);
	    $i =~ s/^��//;
	    $flag = 0 if ($i =~ /��/);
	}
    }

    if ($flag == 0) {
	if ($TYPE eq "�����ǡ���ʸ�����ѥ�") {
	    print STDOUT "# A-ID:$aid ���\n";
	}
    }
    else {
	if ($TYPE eq "�����ǡ���ʸ�����ѥ�") {
	    print STDOUT "# A-ID:$aid\n";
	    &breakdown_article($aid, $article, STDOUT);
	}
	elsif ($TYPE eq "ʸ̮�����ѥ�") {
	    $aid =~ /....(.....)/;
	    open(OUT, '> :encoding(euc-jp)', "$1.txt");
	    &breakdown_article($aid, $article, OUT);
	    close(OUT);
	}
    }
}

######################################################################
# ������ʸñ�̤�ʬ��
#
# �������ʳ���"��"
#
# ��"��"
######################################################################

sub breakdown_article
{
    local($aid, $article, $OUT) = @_;
    local($paragraph, $sentence, $level, $last, $scount, $sid, $pcount);
    local($i, @char);

    chop($article);
    $scount = 1;
    $pcount = 1;
    foreach $paragraph (split(/\n/, $article)) {

	if ($TYPE eq "ʸ̮�����ѥ�") {
	    print $OUT "# ($pcount)\n";
	}

	$level = 0;
	$sentence = "";
	
	@char = split(//, $paragraph);

	for ($i = 0; $i < @char; $i++) {
	    if ($char[$i] eq "��" ||
		$char[$i] eq "��" ||
		$char[$i] eq "��") {
		$level ++;
		# print STDERR "nesting ���:$sentence\n" if ($level == 2);
	    } elsif ($char[$i] eq "��" ||
		     $char[$i] eq "��" ||
		     $char[$i] eq "��") {
		$level --;
		# print STDERR "invalid ��̡�:$paragraph\n" if ($level == -1);
	    }
	    $sentence .= $char[$i];
	    if (($level == 0 && $char[$i] eq "��" ) || 
		($char[$i] eq "��" && $char[$i+1] ne "��")) {
		$sid = sprintf("%s-%03d", $aid, $scount);

		if ($TYPE eq "�����ǡ���ʸ�����ѥ�") {
		    &check_sentence($sid, $sentence, $OUT);
		}
		elsif ($TYPE eq "ʸ̮�����ѥ�") {
		    $sentence =~ s/^��+//;
		    print $OUT "# $scount\n$sentence\n";
		}
		$scount++;
		$sentence = "";
	    }
	    $last = $char[$i];
	}

	if ($last ne "��" && $last ne "��") {
	    $sid = sprintf("%s-%03d", $aid, $scount);
	    
	    if ($TYPE eq "�����ǡ���ʸ�����ѥ�") {
		&check_sentence($sid, $sentence, $OUT);
	    }
	    elsif ($TYPE eq "ʸ̮�����ѥ�") {
		$sentence =~ s/^��+//;
		print $OUT "# $scount\n$sentence\n";
	    }
	    $scount++;
	    $sentence = "";
	}

	if ($TYPE eq "�����ǡ���ʸ�����ѥ�") {
	    print $OUT "# ������\n";
	}
	$pcount++;
    }
}

######################################################################
# ʸ��ʸ��Ǻ��������
#
# ��"��"��"��"��"��"��"��"��"��"��"��"�ǻϤޤ�ʸ�����Τ���
#
# ��"��"��������5��ʾ�ޤ���Ĺ��512�Х��Ȱʾ�(¿���ϰ���ʸ)�����Τ���
#
# ��ʸƬ��"��"��"������";
#
# ��"�ʡġ�"�κ������������"�ʣ���"��"�ʣ���"�ξ��ϻĤ�
#
# ��"��ġ�"�κ�����������֤�"��"�������RESET
#
# ��"���(ʸ��)"�ǡ�ʸ����"��"���ʤ�����"��"��"�̿���"�Ǥ���н���
#
# ���ʣ��ˡġʣ��� �Ȥ����վ�񤭤�������
######################################################################

sub check_sentence
{
    local($sid, $sentence, $OUT) = @_;
    local(@char_array, @check_array, $i, $flag);
    local($enu_num, $paren_start, $paren_level, $paren_str);

    (@char_array) = split(//, $sentence);

    for ($i = 0; $i < @char_array; $i++) {
	$check_array[$i] = 1;
    }

    # �ͼ���
    if ($ok_h_sid{$sid}) {
	for my $pos (keys %{$ok_h_check{$sid}}) {
	    for (my $i = $pos; $i < $pos + length($ok_h_check{$sid}{$pos}); $i++) {
		$check_array[$i] = 0;
	    }
	}
	goto SENTENCE_CHECK_OK;
    }

    # ���̤��оݳ��Ȥ���ʸ

    if ($neglect_sid{$sid}) {
	print $OUT "# S-ID:$sid ���κ��:$sentence\n";
	return;
    }
    if ($neglect_h_sid{$sid}) {
	print $OUT "# S-ID:$sid �ͼ���:$sentence\n";
	return;
    }

    # "��"��"��"��"��"��"��"��"��"��"��"�ǻϤޤ�ʸ�����Τ���

    if ($sentence =~ /^(��)?(��|��|��|��|��|��)/) {
	print $OUT "# S-ID:$sid ���κ��:$sentence\n";
	return;
    }

    # "��"��������5��ʾ�ޤ���Ĺ��512�Х��Ȱʾ�(¿���ϰ���ʸ)�����Τ���

    if ($sentence =~ /^.+��.+��.+��.+��.+��.+/ ||
	length($sentence) >= 256) {
	print $OUT "# S-ID:$sid ���κ��:$sentence\n";
	return;
    }

    # "�ġġ�"������ʸ�����Τ���
    
    if ($sentence =~ /^(��)+$/) {
	print $OUT "# S-ID:$sid ���κ��:$sentence\n";
	return;
    }

  SENTENCE_OK:
    # ʸƬ��"��"�Ϻ��
    $check_array[0] = 0 if ($char_array[0] eq "��");

    # ʸƬ��"������"�Ϻ��

    if ($sentence =~ "^������") {
	$check_array[1] = 0;
	$check_array[2] = 0;
    }

    # "�ʡġ�"�κ������������"�ʣ���"��"�ʣ���"�ξ��ϻĤ�

    $enu_num = 1;
    $paren_start = -1;
    $paren_level = 0;
    $paren_str = "";
    for ($i = 0; $i < @char_array; $i++) {
	if ($char_array[$i] eq "��") {
	    $paren_start = $i if ($paren_level == 0);
	    $paren_level++;
	} 
	elsif ($char_array[$i] eq "��") {
	    $paren_level--;
	    if ($paren_level == 0) {
		if ($paren_str eq $enu[$enu_num]) {
		    $enu_num++;
		}
		else {
		    for ($j = $paren_start; $j <= $i; $j++) {
			$check_array[$j] = 0;
		    }
		}
	    $paren_start = -1;
	    $paren_str = "";
	    }
	}
	else {
	    $paren_str .= $char_array[$i] if ($paren_level != 0);
	}
    }
    # print STDERR "enu_num(+1) = $enu_num\n" if ($enu_num > 1);

    # "��ġ�"�κ�����������֤�"��"�������RESET

    $paren_start = -1;
    $paren_level = 0;
    $paren_str = "";
    for ($i = 0; $i < @char_array; $i++) {
	if ($check_array[$j] == 0) {
	    ; # "�ʡġ�"����ϥ����å�
	} elsif ($char_array[$i] eq "��") {
	    if ($paren_level == 0) {
		$paren_start = $i; 
		$paren_level++;
	    } 
	    elsif ($paren_level == 1) {
		for ($j = $paren_start; $j <= $i; $j++) {
		    $check_array[$j] = 0;
		}
		$paren_start = -1;
		$paren_level = 0;
		$paren_str = "";
	    }
	}
	elsif ($char_array[$i] eq "��") {
	    if ($paren_level == 1) {

		# "���"�ȤʤäƤ��Ƥ⡤"��"�������RESET
		# �� "�����ǯ�����ס���Ĺ�ȡ��㤭ŷ�͡ᱩ��"
		# print STDERR "��ġ��ġ�RESET:$paren_str:$sentence\n";

		$paren_start = -1;
		$paren_level = 0;
		$paren_str = "";
	    }
	}
	else {
	    $paren_str .= $char_array[$i] if ($paren_level == 1);
	}
    }

    # "���(ʸ��)"�ǡ�ʸ����"��"���ʤ�����"��"��"�̿���"�Ǥ���н���

    if ($paren_level == 1) {
	if ($paren_str =~ /^�̿�/ || $paren_str !~ /��$/) {
	    for ($j = $paren_start; $j < $i; $j++) {
		$check_array[$j] = 0;
	    }
	    # print STDERR "���DELETE:$paren_str:$sentence\n";
	} else {
	    # print STDERR "���KEEP:$paren_str:$sentence\n";
	}
    }

  SENTENCE_CHECK_OK:
    $flag = 0;
    for ($i = 0; $i < @char_array; $i++) {	
	if ($check_array[$i] == 1) {
	    $flag = 1;
	    last;
	}			# ͭ����ʬ���ʤ�������κ��
    }
    if ($enu_num > 2 && !$ok_h_sid{$sid}) {	# �ʣ��ˡʣ��ˤȤ�������κ��
	# print STDERR "# S-ID:$sid ���κ��:$sentence\n";
	$flag = 0;
    }

    if ($flag == 0) {
	print $OUT "# S-ID:$sid ���κ��:$sentence\n";
    } else {
	print $OUT "# S-ID:$sid";

	for ($i = 0; $i < @char_array; $i++) {
	    if ($check_array[$i] == 0) {
		print $OUT " ��ʬ���:$i:" 
		    if ($i == 0 || $check_array[$i-1] == 1);
		print $OUT $char_array[$i];
	    }
	}
	print $OUT "\n";

	for ($i = 0; $i < @char_array; $i++) {
	    print $OUT $char_array[$i] if ($check_array[$i] == 1);
	}
	print $OUT "\n";
    }
}

######################################################################
#				 END
######################################################################

#!/usr/bin/env perl

use encoding 'euc-jp', STDIN => 'shift_jis';

$ad{"01"} = "����";
$ad{"02"} = "����";
$ad{"03"} = "����";
$ad{"04"} = "����";
$ad{"05"} = "����";
$ad{"07"} = "���";
$ad{"08"} = "�к�";
$ad{"10"} = "�ý�";
$ad{"12"} = "���";
$ad{"13"} = "����";
$ad{"14"} = "ʸ��";
$ad{"15"} = "�ɽ�";
$ad{"16"} = "�ʳ�";
$ad{"18"} = "��ǽ";
$ad{"35"} = "���ݡ���";
$ad{"41"} = "�Ҳ�";

sub zen2han($) {
    $_[0] =~ tr/�����ɡ������ǡʡˡ��ܡ��ݡ�����-���������䡩����-�ڡΡ�ϡ�������-���Сáѡ���/ !-~/;
    $_[0];
}

sub transfer($$) {
    my ( $key, $context ) = @_;
    my $data;

    if ( $key eq 'ID' || $key eq 'C0' || $key eq 'AF' ) {
	$data = zen2han( $context );
    } elsif ( $key eq 'AE' ) {
	$data  = ( $context eq '��' ) ? 'ͭ' : '̵' ;
    } elsif ( $key eq 'S1' ) {
	my $size;
	( $size ) = /.*����(.*)ʸ����/;
	$data = zen2han( $size );
    } elsif ( $key eq 'AD' ) {
	$data = $ad{zen2han($context)}
    } else {
	$data = $context;
    }

    $data;
}

sub output {
    my $key;

    print "<ENTRY>\n";

    foreach $key ( 'ID', 'C0', 'AD', 'AE', 'AF', 'T1', 'S1' ) {
	print "<", $key, ">", $keyword{$key}->[0], "</", $key, ">\n";
    }
    foreach $key ( 'S2', 'T2' ) {
	print "<",$key,">\n", join("\n",@{$keyword{$key}}), "\n</",$key,">\n";
    }
    foreach $key ( 'KA','AA','KB','AB' ) {
	print "<",$key,">", join( " ",@{$keyword{$key}} ), "</", $key,">\n";
    }
    print "</ENTRY>\n";
}

$first = 1;

while (<STDIN>) {
    chomp;
    ( $tag, $context ) = /��(.*)��(.*)/;
    $key = zen2han( $tag );
    $data = transfer( $key, $context );
    if ( $key eq "ID" ) {
	if ( $first == 1 ) {
	    $first = 0;
	} elsif ( $first == 0 ) {
	    output;
	    undef %keyword;
	    $first = -1;
	} else {
	    print "\n";
	    output;
	    undef %keyword;
	}
    }
    $keyword{$key} = [] unless $keyword{$key};
    push @{$keyword{$key}}, $data;
}

output;

#!/usr/bin/env perl

use encoding 'euc-jp';

# ������ʹ���������� (<AB>,<KB>,<AA>,<KA>,<S2>�κ������ñ��ʬ��)
#
# Usage: mainichi.pl < org_file

$base_dir = $ARGV[0] ? $ARGV[0] : '.';
$current_month = 9500;
$flag = 1;

while ( <STDIN> ) {

    if (/(<AB>|<KB>|<AA>|<KA>)/) {
	;
    } elsif (/<S2>/) {
	$flag = 0;
    } elsif (/<\/S2>/) {
	$flag = 1;
    } elsif (/^<AF>/) {
	$data .= $_;
	($data_month) = /<AF>(95[0-9][0-9])/;
    } elsif (/^<\/ENTRY>/) {
	$data .= $_;
	if ($current_month eq $data_month) {
	    print OUT $data;
	} else {
	    close(OUT);
	    $current_month = $data_month;
	    open(OUT, '> :encoding(euc-jp)', "$base_dir/$current_month.all");
	    print OUT $data;
	}
	$data = '';
    } else {
	$data .= $_ if ($flag);
    }
}

close(OUT);

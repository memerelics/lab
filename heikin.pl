#
	$num = 0;
	$totalx = 0;
	$totaly = 0;
	$totalz = 0;

open (IN, "2HYD_out.pdb");
open (OUT, ">heikin.dat");

while (<IN>) {
        chomp;
        @a = split (/\s+/,$_);

	$totalx = $totalx + $a[6];
	$totaly = $totaly + $a[7];
	$totalz = $totalz + $a[8];
	$num = $num + 1;
}

	$avex = $totalx/$num;
	$avey = $totaly/$num;
	$avez = $totalz/$num;
	
	print OUT 'x: ';
	print OUT "$avex";
	print OUT "\n";
	print OUT 'y: ';
	print OUT "$avey";
        print OUT "\n";
	print OUT 'z: ';
	print OUT "$avez";
        print OUT "\n";

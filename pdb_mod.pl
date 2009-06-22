
open (IN, "2HYD_out.pdb");
open (OUT, ">2HYD_out_a.pdb");

while (<IN>) {
	$line = $_;

	$start    = substr ($line, 0, 30);
	$x        = substr ($line, 30, 8);
	$y        = substr ($line, 38, 8);
	$z        = substr ($line, 46, 8);
        $end      = substr ($line, 54);
	$x2 = $x - 116.165480844156;
	$y2 = $y - 67.6753114718612;
	$z2 = $z - 148.05355952381;

###################################### OUTPUT FORMAT ##########################################
	$INFO = sprintf("%s%8.3f%8.3f%8.3f%s",
		         $start,$x2,$y2,$z2,$end);
###############################################################################################
	print OUT $INFO;

}

close IN;
close OUT;


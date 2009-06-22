#open (IN, "2HYD_out_a.pdb");
#open (OUT, ">2HYD_rot.pdb");
open (IN, "rotate.in");
open (OUT, ">rotate.out");

while (<IN>) {
	$line = $_;

	$start    = substr ($line, 0, 30);
	$x        = substr ($line, 30, 8);
	$y        = substr ($line, 38, 8);
	$z        = substr ($line, 46, 8);
    $end      = substr ($line, 54);

	###############
	#rotation part#
        ###############

	$raji = 3.14159265358979/180; 

#input rotation degree
#edit ???
	$xk = 0;
	$yk = 0;
	$zk = 295;

#xaxe_center_rotation
        $x2 = $x;
	$y2 = $y*cos($xk*$raji) - $z*sin($xk*$raji);
        $z2 = $y*sin($xk*$raji) + $z*cos($xk*$raji);

#zaxe_center_rotation
        $x3 = $x2*cos($zk*$raji) - $y2*sin($zk*$raji);
        $y3 = $x2*sin($zk*$raji) + $y2*cos($zk*$raji);
        $z3 = $z2;

#yaxe_center_rotation
        $x4 =  $x3*cos($yk*$raji) + $z3*sin($yk*$raji);
        $y4 =  $y3;
        $z4 = -$x3*sin($yk*$raji) + $z3*cos($yk*$raji);

###################################### OUTPUT FORMAT ##########################################
	$INFO = sprintf("%s%8.3f%8.3f%8.3f%s",
		         $start,$x4,$y4,$z4,$end);
###############################################################################################
	print OUT $INFO;
}

close IN;
close OUT;





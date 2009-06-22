#/usr/bin/env ruby

@num = 0
@totalx = 0 ; @totaly = 0 ; @totalz = 0 ;
@average_x = 0; @average_y = 0; @average_z = 0;

def calcAveCrd(input)
	File.open(input){|input|
		while line = input.gets
			if line =~ /AT(O)?M/
				@num += 1
				ary = line.split(/\s+/)
				@totalx += ary[6].to_f
				@totaly += ary[7].to_f
				@totalz += ary[8].to_f

			end
		end
		@average_x = (@totalx / @num).to_f
		@average_y = (@totaly / @num).to_f
		@average_z = (@totalz / @num).to_f
		@aveAry = [@average_x, @average_y, @average_z]
	}
	puts @aveAry
	puts sprintf("%8.3f%8.3f%8.3f", @aveAry[0], @aveAry[1], @aveAry[2])
end

calcAveCrd(ARGV[0])


File.open(ARGV[0]){|input|
	while line = input.gets
		if line =~ /AT(O)?M/
			ary = line.split(/\s+/)
		else
		end
	end
}


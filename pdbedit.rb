#!/usr/bin/ruby

require 'rubygems'
require 'bio'
include Math

########### INPUT PARAMETERS ##############

@move   = [0,0,-5] # distance
#@shiftcopy = select(x,y,z) distance
@rotate_angle = [-10,0,0]

###########################################


if ARGV.length == 2 #changed from 1 
#  puts "execute without options"
#  entry = File.read(ARGV[0])
#elsif ARGV.length == 2
  if ARGV[1] =~ /.+\.pdb/
    entry = File.read(ARGV[1])
  else
    puts "input file should be .pdb format!!"; exit
  end

elsif
  ARGV[0] == "-N"
  puts "skip option", ""
else
  puts "invalid arguments"
  puts "usage:", "pdbedit.rb -option hoge.pdb", "or", "pdbedit.rb -N hoge.pdb (execute without options)"
  exit
end

# PDB parse & into ary {{{1

pdb = Bio::PDB.new(entry)
 
@arySerial = []     ; @aryName = []  ; @aryResName = [] ; @aryChainID = []   ; @aryResSeq = []
@aryX = []          ; @aryY = []     ; @aryZ = []       ; @aryOccupancy = [] ; 
@aryTempFactor = [] ; @arySegID = []

pdb.each_atom do |atom| 

  @arySerial     << atom.serial
  @aryName       << atom.name
  @aryResName    << atom.resName
  @aryChainID    << atom.chainID
  @aryResSeq     << atom.resSeq
  @aryX          << atom.x
  @aryY          << atom.y
  @aryZ          << atom.z
  @aryOccupancy  << atom.occupancy
  @aryTempFactor << atom.tempFactor
  # @arySegID    << atom.segID

end 


# }}}1
def maxmin # {{{1
  puts "X: max=#{@aryX.max}, min=#{@aryX.min}"
  puts "Y: max=#{@aryY.max}, min=#{@aryY.min}"
  puts "Z: max=#{@aryZ.max}, min=#{@aryZ.min}"
end 


#}}}1
def serial #{{{1
  output = File.open("output_serial.pdb", "w")

  #sample PDB file format
  #ATOM      9  N   ASN A   2      51.930  -4.967  32.275  1.00 74.28       1SG  10
  @arySerial.each_with_index do |item, i|

    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                  i+1, @aryName[i], @aryResName[i], @aryChainID[i], @aryResSeq[i],
                  @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i])

  end
  output.puts "END"
end 


#}}}1
def shiftZ #{{{1
  output = File.open("output_shiftZ.pdb", "w")

  #sample PDB file format
  #ATOM      9  N   ASN A   2      51.930  -4.967  32.275  1.00 74.28       1SG  10
  @arySerial.each_with_index do |item, i|

    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f      %4s%4d\n",
                  i+1, @aryName[i], @aryResName[i], @aryChainID[i], @aryResSeq[i],
                  @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i],
                  @arySegID[i], i+2)

  end
  output.puts "END"
end 


#}}}1
def move # {{{1

fnn = ARGV[1].sub(/\..+/,"")
  output = File.open("#{fnn}Mov_#{@move[0]}_#{@move[1]}_#{@move[2]}.pdb", "w")
  @arySerial.each_with_index do |item, i|

    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                  @arySerial[i], @aryName[i], @aryResName[i], @aryChainID[i], @aryResSeq[i],
                  @aryX[i]+@move[0],
                  @aryY[i]+@move[1],
                  @aryZ[i]+@move[2] ,
                  @aryOccupancy[i], @aryTempFactor[i])
  end
  output.puts "END"

end 


#}}}1
def shiftcopy #{{{1

  output = File.open("output_shiftcopy.pdb", "w")
  tmp = File.open("tmp.pdb", "w")

  for i in 0..(@arySerial.length-3)

    # only when all atoms in the molecule exist in the range.
    if (@aryZ[i] >= 15.4 && @aryZ[i] <= 30.4) \
      && (@aryZ[i+1] >= 15.4 && @aryZ[i+1] <= 30.4) \
      && (@aryZ[i+2] >= 15.4 && @aryZ[i+2] <= 30.4) \
      && (@aryResName[i] == "SOL")

      aryTmp = []; aryTmp << i; aryTmp << i+1; aryTmp << i+2
      aryTmp.each{|x|
        tmp.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                   @arySerial[x], @aryName[x], @aryResName[x], @aryChainID[x], @aryResSeq[x],
                   @aryX[x],
                   @aryY[x],
                   @aryZ[x]-15,
                   @aryOccupancy[x], @aryTempFactor[x])
      }
    else
    end
    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                  @arySerial[i], @aryName[i], @aryResName[i], @aryChainID[i], @aryResSeq[i],
                  @aryX[i],
                  @aryY[i],
                  @aryZ[i],
                  @aryOccupancy[i], @aryTempFactor[i])
  end

  # last 2 lines
  ary2Tmp = []; ary2Tmp << @arySerial.length-2; ary2Tmp << @arySerial.length-1
  ary2Tmp.each{|x|
    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                  @arySerial[x], @aryName[x], @aryResName[x], @aryChainID[x], @aryResSeq[x],
                  @aryX[x],
                  @aryY[x],
                  @aryZ[x],
                  @aryOccupancy[x], @aryTempFactor[x])
  }
  output.puts "END"
end 



# }}}1
def inbox #{{{1

  output = File.open("output_inbox.pdb", "w")
  #tmp = File.open("tmpinbox.pdb", "w")

  for i in 0..(@arySerial.length-3)

    # only when all atoms in the molecule exist in the range.
    if (@aryX[i] >= 2.735 && @aryX[i] <= 67.345) \
      && (@aryY[i] >= 7.509 && @aryY[i] <= 58.54) \
      && (@aryZ[i] >= 3.391 && @aryZ[i] <= 65.958)

    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                  @arySerial[i], @aryName[i], @aryResName[i], @aryChainID[i], @aryResSeq[i],
                  @aryX[i],
                  @aryY[i],
                  @aryZ[i],
                  @aryOccupancy[i], @aryTempFactor[i])
    end
  end
end #}}}1
def rotate #{{{

  averageCorrdinates =[]

%w(@aryX @aryY @aryZ).each do |a|
  sum = 0, n = 0
  eval(a).inject(eval(a)[0]) {|sum, n| sum + n}
  averageCorrdinates << sum/eval(a).length
end

# if you need only central coordinates
if ARGV[0] == "-central"; p averageCorrdinates; exit; end

# shift all atoms so that average coordinates is origin(0,0,0)
coordXorg = []; coordYorg = []; coordZorg = []
  @arySerial.each_with_index{ |item, i|
                  coordXorg << @aryX[i]-averageCorrdinates[0]
                  coordYorg << @aryY[i]-averageCorrdinates[1]
                  coordZorg << @aryZ[i]-averageCorrdinates[2]
  } 


x2, y2, z2 = [], [], []; x3, y3, z3 = [], [], []; x4, y4, z4 = [], [], []

# calculate X ax rotation
coordXorg.zip(coordYorg, coordZorg){|x,y,z|
  x2 << x
  y2 << (y*cos(@rotate_angle[0]*PI/180) - z*sin(@rotate_angle[0]*PI/180))
  z2 << (y*sin(@rotate_angle[0]*PI/180) + z*cos(@rotate_angle[0]*PI/180))
}
# calculate Y ax rotation
x2.zip(y2, z2){|x,y,z|
  x3 << (x*cos(@rotate_angle[1]*PI/180) + z*sin(@rotate_angle[1]*PI/180))
  y3 << y
  z3 << (-x*sin(@rotate_angle[1]*PI/180) + z*cos(@rotate_angle[1]*PI/180))
}
# calculate Z ax rotation
x3.zip(y3, z3){|x,y,z|
  x4 << (x*cos(@rotate_angle[2]*PI/180) - y*sin(@rotate_angle[2]*PI/180))
  y4 << (x*sin(@rotate_angle[2]*PI/180) + y*cos(@rotate_angle[2]*PI/180))
  z4 << z
}

fnn = ARGV[1].sub(/\..+/,"")
output = File.open("#{fnn}Rot_#{@rotate_angle[0]}_#{@rotate_angle[1]}_#{@rotate_angle[2]}.pdb", "w")

  @arySerial.each_with_index { |item, i|

    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                  @arySerial[i], @aryName[i], @aryResName[i], @aryChainID[i], @aryResSeq[i],
                  x4[i]+averageCorrdinates[0],
                  y4[i]+averageCorrdinates[1],
                  z4[i]+averageCorrdinates[2],
                  @aryOccupancy[i], @aryTempFactor[i])
  } 
  output.puts "END"
end


#}}}


case ARGV[0]
when "-N"
when "-maxmin"    ; maxmin
when "-serial"    ; serial
when "-move"      ; move
when "-shiftcopy" ; shiftcopy
when "-inbox"     ; inbox
when "-rotate"    ; rotate
when "-central"   ; rotate
else; puts "invalid option"; exit
end

#!/usr/bin/ruby

require 'rubygems'
require 'bio'

if ARGV.length == 1
  puts "execute without options"
  entry = File.read(ARGV[0])
elsif ARGV.length == 2
  entry = File.read(ARGV[1])
else
  puts "invalid arguments" ; exit
end

# PDB parse & into ary {{{1

pdb = Bio::PDB.new(entry)
 
@arySerial = []     ; @aryName = []  ; @aryResName = [] ; @aryChainID = []   ; @aryResSeq = []
@aryX = []          ; @aryY = []     ; @aryZ = []       ; @aryOccupancy = [] ; 
@aryTempFactor = [] ; @arySegID = []

pdb.each_atom do |atom| 

  @arySerial <<  atom.serial
  @aryName <<  atom.name
  @aryResName <<  atom.resName
  @aryChainID <<  atom.chainID
  @aryResSeq <<  atom.resSeq
  @aryX <<  atom.x
  @aryY <<  atom.y
  @aryZ <<  atom.z
  @aryOccupancy <<  atom.occupancy
  @aryTempFactor <<  atom.tempFactor
  # @arySegID <<  atom.segID

end # }}}1


def maxmin # {{{1
  puts "X: max=#{@aryX.max}, min=#{@aryX.min}"
  puts "Y: max=#{@aryY.max}, min=#{@aryY.min}"
  puts "Z: max=#{@aryZ.max}, min=#{@aryZ.min}"
end #}}}1

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
end #}}}1

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
end #}}}1

def move 
  output = File.open("output_move.pdb", "w")
  @arySerial.each_with_index do |item, i|

    output.printf("ATOM  %5d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                  @arySerial[i], @aryName[i], @aryResName[i], @aryChainID[i], @aryResSeq[i],
                  @aryX[i],
                  @aryY[i],
                  @aryZ[i]+30,
                  @aryOccupancy[i], @aryTempFactor[i])
  end
  output.puts "END"

end


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
end # }}}1


def inbox

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
end





case ARGV[0]
when "-N"      
  puts "skip option"
when "-maxmin"; maxmin
when "-serial"; serial
when "-move"  ; move
when "-shiftcopy"  ; shiftcopy
when "-inbox"  ; inbox
else; puts "no arguments"; exit
end

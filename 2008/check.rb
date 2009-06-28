#!/usr/bin/env ruby

@ary = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y' ] 

def ck_rst()

  @ary.each{|first|
    @ary.each{|second|
      if first <= second
        print first, second, " : "
        if File.exists?("/work/thashimo/Next/#{first}-X/#{first.downcase}-#{second.downcase}/2min/min#{first}#{second}.rst") == true 
          a = IO.readlines("/work/thashimo/Next/#{first}-X/#{first.downcase}-#{second.downcase}/2min/min#{first}#{second}.rst")
          for i in 0..a.length-1 do
            if /\*/ =~ a[i]
              print "ERROR !! in line #{i}/#{a.length} of #{first}-#{second}\n"
            end

          end
        end
      end
    }
  }
end

def ck_210stats()

  lostpairs = []
  @ary.each{|first|
    @ary.each{|second|
      if first <= second
        if File.exists?("/work/thashimo/Next/statistics_out/#{first}#{second}_gbNext_statistics.out") == false
          lostpairs << "#{first}-#{second}"

        end
      end
    }
  }
  p lostpairs
end

def ck_emptytop()
  @ary.each{|first|
    @ary.each{|second|
      if first <= second
        if File.readlines("#{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa/#{first}#{second}a.top")[6] =~ /0\s+0\s+0\s+0\s+0\s+0\s+0\s+0/
          puts "", "mono #{first}#{second}a.top file is empty. "
        else
          print  "#{first}#{second}a.top is correct.     "
        end
      end
    }
  }

end

def ck_4mdfinished?()
  lostpairs = []
  @ary.each{|first|
    @ary.each{|second|
      if first <= second
        if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/4md/md#{first}#{second}.out") == false
          lostpairs << "#{first}-#{second}"
        end
      end
    }
  }
  p lostpairs

end

ck_210stats()

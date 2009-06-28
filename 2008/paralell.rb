#! /usr/bin/env ruby
# edit following arrays to identify the pairs to calc.


aa_ary = %w(M)
aa_ary2 = %w(P R V)

#aa_ary = %w(F G R)
#aa_ary2 = %w(Y)

case ARGV[0]
when nil
  puts "     To use this script, select 1leap / 3eq / 4md / 5mmpbsa as an argument."
  puts "     You can also use 2nd ARG \"bes2\", if you want run calc in the bes2 queue."
when "1leap"
  aa_ary.each{|first|
    aa_ary2.each{|second|

      if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/1leap/#{first}-#{second}_no.pdb") == false \
        && File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/2min/min#{first}#{second}.rst") == false
        print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
        %x(
        cd #{first}-X/#{first.downcase}-#{second.downcase}/1leap
        cp /work/thashimo/leucine_zipper/leap_and_runmin.rb .
        mv ../../#{first}-#{second}_no.pdb .
        )
        if ARGV[1] == "bes2"
          %x(
          cd #{first}-X/#{first.downcase}-#{second.downcase}/1leap
          ruby leap_and_runmin.rb #{first} #{second} 2
          )
        else
          %x[
          cd #{first}-X/#{first.downcase}-#{second.downcase}/1leap
          ruby leap_and_runmin.rb #{first} #{second}
          ]
        end
      end
    }
  }

when "2min"
  puts "2min is connected with 1leap"

when "3eq"
  aa_ary.each{|first|
    aa_ary2.each{|second|
      if File.readlines("#{first}-X/#{first.downcase}-#{second.downcase}/2min/min#{first}#{second}.out").pop =~ /wallclock/ \
        && File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/3eq/eq#{first}#{second}.rst") == false

        print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
        %x{
          cd #{first}-X/#{first.downcase}-#{second.downcase}/3eq
          cp /work/thashimo/leucine_zipper/runeq_gbsa.rb .
        }
        if ARGV[1] == "bes2"
          %x{
            cd #{first}-X/#{first.downcase}-#{second.downcase}/3eq
            ruby runeq_gbsa.rb #{first} #{second} 2
          }
        else
          %x{
            cd #{first}-X/#{first.downcase}-#{second.downcase}/3eq
            ruby runeq_gbsa.rb #{first} #{second}
          } 
        end
      end
    }
  }

when "4md"
  aa_ary.each{|first|
    aa_ary2.each{|second|
      if File.readlines("#{first}-X/#{first.downcase}-#{second.downcase}/3eq/eq#{first}#{second}.out").pop =~ /wallclock/
        if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/4md/md#{first}#{second}.rst")
          puts "you already run #{first}-#{second} 4md" 
        else
          print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
          %x{
            cd #{first}-X/#{first.downcase}-#{second.downcase}/4md
            cp /work/thashimo/leucine_zipper/runmd_gbsa.rb .
          }
          if ARGV[1] == "bes2"
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/4md
              ruby runmd_gbsa.rb #{first} #{second} 2
            }
          else
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/4md
              ruby runmd_gbsa.rb #{first} #{second}
            } 
          end
        end
      end
    }
  }

when "5mmpbsa"
  aa_ary.each{|first|
    aa_ary2.each{|second|
      if File.readlines("#{first}-X/#{first.downcase}-#{second.downcase}/4md/md#{first}#{second}.out").pop =~ /wallclock/ 
        if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa/#{first}#{second}_gb999_statistics.out") 
          puts "already analyzed #{first}-#{second}"
        else
          print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
          %x{
            cd #{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa
            cp /work/thashimo/leucine_zipper/analruby.rb .
            ruby analruby.rb #{first} #{second}
          } 
        end
      else
        puts "md#{first}#{second} isn't yet finished"
      end
    }
  }
end

#!usr/bin/env ruby

for i in 1..100 do
  if i % 3 == 0
    if i % 5 == 0
      puts "FizzBuzz"
    end
    puts "Fizz"
  elsif i % 5 == 0
    puts "Buzz"
  else 
    puts i
  end
end


#for i in 1..100 do puts(i%15==0?"FizzBuzz":i%3==0?"Fizz":i%5==0?"Buzz":i)end

# following codes are not mine.

#100.times{|i|puts i%15==14?:FizzBuzz:i%3==2?:Fizz:i%5==4?:Buzz:i+1}
#
#1.upto(100){|i|puts(i%15==0?:FizzBuzz:i%3==0?:Fizz:i%5==0?:Buzz:i)}
#
#1.upto 100{|i|print *(a=[i%3==0&&:Fizz,i%5==0&&:Buzz]-[!0])[0]?a:[i],$/}
#
#

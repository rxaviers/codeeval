#! /usr/bin/env ruby
# CodeEval - Hard) Following Integer
# http://www.codeeval.com/open_challenges/44/
# author: Rafael Xavier <rxaviers at gmail.com>

class Test
    def initialize(line)
        @n = line.strip.to_i
    end

    def run
        puts @n.following_integer
    end
end

class Integer
    def following_integer
        seq = (to_s.chars.to_a + ["0"]).permutation.to_a.sort.uniq.map{|i|
            i.join('').to_i
        }
        seq[ seq.index(self)+1 ]
    end
end

File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end

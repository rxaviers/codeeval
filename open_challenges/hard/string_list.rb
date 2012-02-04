#! /usr/bin/env ruby
# CodeEval - Hard) String List
# http://www.codeeval.com/open_challenges/38/
# author: Rafael Xavier <rxaviers at gmail.com>

class Test
    def initialize(line)
        @n, @s = line.strip.split(',')
    end

    def run
        @n = @n.to_i
        @r = @s.lexicon
        (1..@n-1).each {|n|
            @r = @r.product(@s.lexicon)
        }
        puts (@r[0].length > 1 ? @r.map {|i| i.flatten.join('')} : @r).join(',')
    end
end

class String
    def lexicon
        @lexicon ||= chars.to_a.sort.uniq
    end
end

File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end

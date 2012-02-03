#! /usr/bin/env ruby

class Test
    def initialize(line)
        @n = line.gsub(/[.,]/, '').to_i
    end

    def run
        r = []
        (2..@n-1).each {|i|
            r<< i if i.prime?
        }
        puts r.join(',')
    end
end

class Integer
    def prime?
        return true if self <= 2
        return false if even?
        (3..(Math.sqrt(self).to_i)).step(2).none? {|i| self % i == 0}
    end
end


File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end

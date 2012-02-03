#! /usr/bin/env ruby

class Test
    MAX_TRIES = 1000

    def initialize(line)
        @n = line.gsub(/[.,]/, '').to_i
    end

    def run
        iterations = 0
        while iterations < MAX_TRIES
            break if @n.palindrome?
            @n = @n + @n.to_s.reverse.to_i
            iterations += 1
        end
        if iterations == MAX_TRIES
            puts "inf N/A"
        else
            puts "#{iterations} #{@n}"
        end
    end
end

class Integer
    def palindrome?
        self.to_s == self.to_s.reverse
    end
end


File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end

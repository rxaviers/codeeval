#! /usr/bin/env ruby
# CodeEval - Hard) Ugly Numbers
# http://www.codeeval.com/open_challenges/42/
# author: Rafael Xavier <rxaviers at gmail.com>
# FAILs due to performance: time exceeds 5s limit

DEBUG = false

class Test
    def initialize(line)
        @n = line.strip
    end

    def run
        c = 0
        @n.amusing_expressions {|exp|
            evaled_exp = eval(exp.without_octals)
            puts "#{exp} = #{evaled_exp} #{evaled_exp.ugly_number? ? "ugly" : ""}" if DEBUG
            c += 1 if evaled_exp.ugly_number?
        }
        puts c
    end
end

class Integer
    def ugly_number?
        return true if self == 0
        [2, 3, 5, 7].map {|d| self % d}.include?(0)
    end
end

class String
    def amusing_expressions(head = "", &block)
        arrayed = chars.to_a
        if arrayed.length == 1
            yield self.to_s
        elsif arrayed.length == 2
            arrayed.amusing_expressions.each {|exp|
                yield head + exp
            }
        else
            [arrayed[0], ""].amusing_expressions.each {|exp|
                new_number = arrayed[1..-1].join('')
                new_number.amusing_expressions(head + exp, &block)
            }
        end
        nil
    end

    def without_octals
        gsub(/^0+([^0]+)/, '\1').gsub(/([+-])0+([^0]+)/, '\1\2')
    end
end

class Array
    def amusing_expressions
        raise "ops" if length != 2
        ["", "+", "-"].map {|op| "#{self[0]}#{op}#{self[1]}"}
    end
end


File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end

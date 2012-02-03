#! /usr/bin/env ruby
# CodeEval - Hard 2) Prefix expressions
# http://www.codeeval.com/open_challenges/7
# author: Rafael Xavier <rxaviers at gmail.com>

class Test
    def initialize(line)
        @tokens = line.split
    end

    def run
        puts @tokens.prefix_exp_eval
    end
end


class Array
    def prefix_exp_eval
        aux = []
        (length - 1).downto(0) do |i|
            v = self[i]
            if v.operand?
                aux.push(v)
            elsif v.operator?
                a = aux.pop.to_i
                b = aux.pop.to_i
                aux.push( a.send(v, b) )
            else
                raise "ops"
            end
        end
        aux[0]
    end
end

class String
    def operand?
        (self =~ /^[0-9]+$/) ? true : false
    end

    def operator?
        (self =~ /^[+-\/*]$/) ? true : false
    end
end

File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end

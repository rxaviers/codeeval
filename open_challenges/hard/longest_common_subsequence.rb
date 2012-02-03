#! /usr/bin/env ruby
# CodeEval - Hard 1) Longest Common Subsequence
# http://www.codeeval.com/open_challenges/6/
# author: Rafael Xavier <rxaviers at gmail.com>
# FAILs due to efficiency

class Test
    def initialize(line)
        return unless line =~ /;/
        @a, @b = line.split(';')
    end

    def run
        # Return if null @a or @b
        return unless (@a and @b)

        # @a becomes an Array of characters
        @a = @a.split('')
        k = @a.length
        found = false
        threads = []

        until found
            # Begin with the biggest combinations, then try smaller ones, eg:
            # - Combination("abc", 3) = ["abc"]
            # - Combination("abc", 2) = ["ab", "ac", "bc"]
            @a.combination(k).each {|combination_from_a|
                # Try to find that comb in @b
                if @b.contain?(combination_from_a)
                    puts combination_from_a.join('')
                    found = true
                    break
                end
            }
            break if found
            k -= 1
        end
    end
end


class String
    def contain?(array)
        self =~ Regexp.new(array.join('.*')) ? true : false
    end
end

File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end

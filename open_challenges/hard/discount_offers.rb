#! /usr/bin/env ruby
# CodeEval - Hard 10) Discount Offers
# http://www.codeeval.com/open_challenges/48/
# author: Rafael Xavier <rxaviers at gmail.com>
# NOT COMPLETE

VOWELS = %w{a e i o u}

def SS(customer, product)
    #3
    turbo_factor = product.letters.length.any_common_factor_with?(
                   customer.letters.length) \
        ? 1.5 \
        : 1

    #1
    if product.letters.length.even?
        customer.vowels.length * 1.5 * turbo_factor
    
    #2
    else
        customer.consonants.length * turbo_factor
    end
end

# Recursive way to find the biggest_SS
def biggest_SS(ss_table, except_ys = [])
    (ss_table[0].each_with_index.map {|ss, y|
        if except_ys.include?(y)
            0
        elsif ss_table.length > 1
            ss + biggest_SS(ss_table[1..-1], except_ys + [y])
        else
            ss
        end
    } + (ss_table.length > 1 ? [0 + biggest_SS(ss_table[1..-1], except_ys)] :
    [0])).max
end

class Test
    def initialize(line)
        @customers, @products = line.split(';').map{|x| x.strip.split(',')}
    end

    def run
        # Generate an SS table of each customer vs. product:
        ss_table = @customers.map {|customer|
            @products.map {|product|
                SS(customer, product)
            }
        }
        puts ss_table.inspect

        printf "%.2f\n", biggest_SS(ss_table)
    end
end

class String
    def letters
        chars.to_a.select {|c| c.downcase =~ /[a-z]/}
    end

    def vowels
        chars.to_a.select {|c| VOWELS.include?(c.downcase)}
    end

    def consonants
        chars.to_a.select {|c| not VOWELS.include?(c.downcase) and c != ' '}
    end
end

class Integer
    def any_common_factor_with?(b)
        a = self
        (2..[a,b].min).each {|i|
            return true if (a%i==0 and b%i==0)
        }
        return false
    end
end


File.open(ARGV[0]).each_line do |line|
    t = Test.new(line)
    t.run
end



def backup_biggest_SS_using_permutation
    # For each customer-order permutation(3), we'll get the sum of the
    # biggest SS's:
    printf "%.2f\n", \
    0.upto(@customers.length-1).to_a.permutation(@customers.length).map {|customer_order|
        # deep clone
        sst = Marshal.load(Marshal.dump(ss_table))

        # For each customer (on customer_order's order), we'll get the
        # biggest available SS:
        customer_order.map {|customer_i|
            # Pick the biggest SS of this customer
            ss, product_i = sst[customer_i].each_with_index.max 
            # Remove (invalidate) picked product on other customers
            sst.each {|customer|
                customer[product_i] = 0
            }
            ss
        }.reduce(0, :+)
    }.max
end

#! /usr/bin/env ruby
# CodeEval - Hard 10) Discount Offers
# http://www.codeeval.com/open_challenges/48/
# author: Rafael Xavier <rxaviers at gmail.com>
# score: 83.33 (arg! almost)

QUALITY = :perfect            # :fast or :perfect
VOWELS = %w{a e i o u y}
DEBUG = false

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

def biggest_SS(ss_table)
    # Objective:
    # For each product, get the most valuable SS. How? Give it to a customer
    # whom if you had given any other product, it wouldn't make that much value.
    #
    # Let's begin with the first product. For each customer, we calculate the ss
    # difference of giving him this product versus all other products. Then,  we
    # get the min of those differences. That's the same as getting the
    # difference from the first_product_ss to other_sses_max. With all the
    # customers' deltas in hand we are able to conclude which customer should
    # stay with the product.  It's the one whose benefit will be bigger (max).
    # The bigger the delta_ss, the bigger the value of giving this product to
    # customer_i.

    # On many customers
    if ss_table.length > 1
        # On many products
        if ss_table[0].length > 1
            delta_sses = ss_table.map {|customer_sses|
                first_product_ss = customer_sses[0]
                other_sses_max = customer_sses[1..-1].max
                delta_ss = first_product_ss - other_sses_max
            }
            if QUALITY == :fast
                max_delta_ss_customer_i = delta_sses.each_with_index.max[1]

                # The remaining_ss_table is the ss_table without the customer row a
                # without the product column.
                remaining_ss_table = []
                (0..ss_table.length-1).each {|customer_i|
                    remaining_ss_table<< ss_table[customer_i][1..-1] \
                        unless customer_i == max_delta_ss_customer_i
                }

                ss_table[max_delta_ss_customer_i][0] + biggest_SS(remaining_ss_table)
            elsif QUALITY == :perfect
                max_delta_ss = delta_sses.max
                max_delta_ss_customers_is = delta_sses.each_with_index.select {|v,k|
                    v == max_delta_ss
                }.transpose[1]

                # In case we have more than one max_delta_ss, try them all:
                max_delta_ss_customers_is.map {|max_delta_ss_customer_i|
                    # The remaining_ss_table is the ss_table without the customer row
                    # and without the product column.
                    remaining_ss_table = []
                    (0..ss_table.length-1).each {|customer_i|
                        remaining_ss_table<< ss_table[customer_i][1..-1] \
                            unless customer_i == max_delta_ss_customer_i
                    }

                    ss_table[max_delta_ss_customer_i][0] + biggest_SS(remaining_ss_table)
                }.max
            end
        # On one product
        else
            # Return the biggest ss left
            ss_table.transpose[0].max
        end
    # On one customer
    else
        ss_table[0][0]
    end
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
        puts ss_table.inspect if DEBUG

        printf "%.2f\n", biggest_SS(ss_table)
    end
end

class String
    def letters?
        self.downcase =~ /[a-z]/ ? true : false
    end

    def letters
        chars.to_a.select {|c| c.letters?}
    end

    def vowels
        chars.to_a.select {|c| VOWELS.include?(c.downcase)}
    end

    def consonants
        chars.to_a.select {|c| not VOWELS.include?(c.downcase) and c.letters?}
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

class Array
    def top_with_index(n)
        array = clone
        (1..n).map {
            max = array.max
            index = array.index(max)
            array[index] = 0
            [max, index]
        }
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

# Recursive way to find the biggest_SS
def backup_biggest_SS_using_recursion(ss_table, except_ys = [])
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


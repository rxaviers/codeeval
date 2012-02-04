#!/usr/bin/env python

def remove_char(char, string):
    pos = string.find(char)
    return string[:pos] + string[pos+1:]

def find_lcs(a, b, gen=0):
    #print gen, a, '/',  b
    copy_a = a
    largest = []
    test_later = []
    for char in b:
        pos = a.find(char)
        # this char is not in the remaining of the string
        if pos == -1:
            continue

        # Ok, this char is somewhere in the tail. But is the best? We should
        # test it, but also test without using it!

        # First save it for testing later, but without this char
        # There is no need to test if its the first ocurrency in A
        if pos != 0:
            test_later.append(remove_char(char, b))

        # then using it
        a = a[pos+1:]
        largest.append(char)

    # Now test the strings we saved:
    for i in test_later:
        lcs = find_lcs(copy_a, i, gen+1)
        if len(lcs) > len(largest):
            largest = lcs

    return largest


import sys
if __name__ == '__main__':
    f = open(sys.argv[-1])
    for i in f.readlines():
        i = i[:-1]
        if not i:
            continue
        a, b = i.split(';')
        # Remove uncommon chars
        a = ''.join([i for i in a if i in b])
        b = ''.join([i for i in b if i in a])

        ab = find_lcs(a, b)
        print ''.join(ab)

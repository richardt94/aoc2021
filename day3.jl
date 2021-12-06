tdata = readlines("test3.txt")
##
function poweruse(data)
    nbits = length(data[1])
    counts = zeros(Int, nbits)
    for number = data
        for i = 1:nbits
            counts[i] += number[i] == '1'
        end
    end
    gammabits = [c >= length(data)/2 for c = counts]
    gamma = 0
    b = 0
    for bit = reverse(gammabits)
        gamma += 2^b * bit
        b += 1
    end
    gamma * (2^nbits - gamma - 1)
end
##
poweruse(tdata)
##
data = readlines("input3.txt")
poweruse(data)
##
function bits2num(bs)
    b = 0
    num = 0
    for bit = reverse(bs)
        num += 2^b * (bit=='1')
        b += 1
    end
    num
end
##
function lifesupport(data)
    n_num = length(data)
    eliminated = zeros(Bool, n_num)
    nbits = length(data[1])
    n_elim = 0
    for b = 1:nbits
        mb = false
        count = 0
        for (i, n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if n[b] == '1'
                count += 1
            end
        end
        if count >= (n_num - n_elim)/2
            mb = true
        end
        for (i,n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if (n[b] == '1') != mb
                eliminated[i] = true
                n_elim += 1
            end
        end
        if n_elim >= n_num - 1
            break
        end
    end
    
    #retrieve o2
    o2 = ""
    for (i, n) = enumerate(data)
        if ~eliminated[i]
            o2 = n
        end
    end

    eliminated = zeros(Bool, n_num)
    n_elim = 0
    for b = 1:nbits
        mb = false
        count = 0
        for (i, n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if n[b] == '1'
                count += 1
            end
        end
        if count < (n_num - n_elim)/2
            mb = true
        end
        for (i,n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if (n[b] == '1') != mb
                eliminated[i] = true
                n_elim += 1
            end
        end
        if n_elim >= n_num - 1
            break
        end
    end

    co2 = ""
    for (i, n) = enumerate(data)
        if ~eliminated[i]
            co2 = n
        end
    end

    bits2num(o2)*bits2num(co2)

end

##

lifesupport(tdata)

##
lifesupport(data)
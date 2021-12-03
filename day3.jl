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

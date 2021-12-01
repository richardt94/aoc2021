##
data = parse.(Int,readlines("input1.txt"))
##
function count_increases(data)
    ninc = 0
    for i in 2:length(data)
        ninc += data[i] > data[i-1]
    end
    ninc
end

count_increases(data)

##
tdata = parse.(Int, readlines("test1.txt"))
count_increases(tdata)

##
function count_increases_windowed(data)
    ninc = 0
    for i in 4:length(data)
        ninc += sum(data[i-2:i]) > sum(data[i-3:i-1])
    end
    ninc
end

count_increases_windowed(tdata)

##
count_increases_windowed(data)

##
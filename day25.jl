##
tdata = readlines("test25.txt")
##
function nsteps(data)
    m = length(data)
    n = length(data[1])
    east = Set()
    south = Set()
    for (y, line) in enumerate(data), (x, ch) in enumerate(line)
        ch == 'v' && push!(south, (x-1,y-1))
        ch == '>' && push!(east, (x-1,y-1))
    end
    
    ns = 0
    done = false
    while ~done
        done = true
        neast = Set()
        nsouth = Set()
        for (x,y) in east
            proposed = ((x+1)%n,y)
            if proposed in east || proposed in south
                push!(neast, (x,y))
            else
                done = false
                push!(neast, proposed)
            end
        end
        east = neast
        for (x,y) in south
            proposed = (x,(y+1)%m)
            if proposed in east || proposed in south
                push!(nsouth, (x,y))
            else
                done = false
                push!(nsouth, proposed)
            end
        end
        south = nsouth
        ns += 1
    end
    ns
end
##
nsteps(tdata)
##
data = readlines("input25.txt")
##
nsteps(data)
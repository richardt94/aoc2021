##
tdata = readlines("test25.txt")
##
function nsteps(data)
    m = length(data)
    n = length(data[1])
    state = zeros(Int, m, n)
    for (y, line) in enumerate(data), (x, ch) in enumerate(line)
        ch == 'v' && (state[y,x] = 2)
        ch == '>' && (state[y,x] = 1)
    end
    
    ns = 0
    done = false
    while ~done
        done = true
        nstate = zeros(Int, m, n)
        for y in 1:m, x in 1:n
            state[y,x] != 1 && continue
            px = x%n + 1
            if state[y,px] > 0
                nstate[y,x] = 1
            else
                done = false
                nstate[y,px] = 1
            end
        end
        for y in 1:m, x in 1:n
            state[y,x] != 2 && continue
            py = y%m + 1
            if state[py,x] == 2 || nstate[py,x] == 1
                nstate[y,x] = 2
            else
                done = false
                nstate[py,x] = 2
            end
        end
        state = nstate
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
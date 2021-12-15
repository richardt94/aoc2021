tdata = readlines("test15.txt")
data = readlines("input15.txt")
##
using DataStructures
##
function lowest_risk(data)
    found = false
    heap = BinaryMinHeap{Tuple{Int,Int,Int}}()
    push!(heap, (0,1,1))
    m = length(data)
    n = length(data[1])
    visited = zeros(Bool, m, n)
    risk = 0
    while true
        risk, y, x = pop!(heap)
        visited[y,x] && continue
        visited[y,x] = true
        y == m && x == n && break
        neigh = [            (y-1, x),
                 (y, x-1),             (y,   x+1),
                             (y+1, x)             ]
        for (yn, xn) in neigh
            (yn > m || yn < 1) && continue
            (xn > n || xn < 1) && continue
            push!(heap, (risk + (data[yn][xn] - '0'), yn, xn))
        end
    end
    risk
end
##
lowest_risk(data)
##
function lowest_risk_5(data)
    found = false
    heap = BinaryMinHeap{Tuple{Int,Int,Int}}()
    push!(heap, (0,1,1))
    m0 = length(data)
    n0 = length(data[1])
    m = 5 * m0
    n = 5 * n0
    visited = zeros(Bool, m, n)
    risk = 0
    while true
        risk, y, x = pop!(heap)
        visited[y,x] && continue
        visited[y,x] = true
        y == m && x == n && break
        neigh = [            (y-1, x),
                 (y, x-1),             (y,   x+1),
                             (y+1, x)             ]
        for (yn, xn) in neigh
            (yn > m || yn < 1) && continue
            (xn > n || xn < 1) && continue
            base_risk = data[(yn - 1) % m0 + 1][(xn - 1) % n0 + 1] - '0'
            additional = (yn - 1) ÷ m0 + (xn - 1) ÷ n0
            tile_risk = (base_risk + additional)
            tile_risk = (tile_risk - 1) % 9 + 1
            push!(heap, (risk + tile_risk, yn, xn))
        end
    end
    risk
end
##
lowest_risk_5(data)

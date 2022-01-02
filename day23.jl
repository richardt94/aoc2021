using DataStructures
##
AmphState = NTuple{8,Int}
##
target = (8,9,10,11,12,13,14,15)
##
distances =
[0 1 3 5 7 9 10 3 4 5 6 7 8 9 10;
 1 0 2 4 6 8 9 2 3 4 5 6 7 8 9;
 3 2 0 2 4 6 7 2 3 2 3 4 5 6 7;
 5 4 2 0 2 4 5 4 5 2 3 2 3 4 5;
 7 6 4 2 0 2 3 6 7 4 5 2 3 2 3;
 9 8 6 4 2 0 1 8 9 6 7 4 5 2 3;
 10 9 7 5 3 1 0 9 10 7 8 5 6 3 4;
 3 2 2 4 6 8 9 0 1 4 5 6 7 8 9;
 4 3 3 5 7 9 10 1 0 5 6 7 8 9 10;
 5 4 2 2 4 6 7 4 5 0 1 4 5 6 7;
 6 5 3 3 5 7 8 5 6 1 0 5 6 7 8;
 7 6 4 2 2 4 5 6 7 4 5 0 1 4 5;
 8 7 5 3 3 5 6 7 8 5 6 1 0 5 6;
 9 8 6 4 2 2 3 8 9 6 7 4 5 0 1;
 10 9 7 5 3 3 4 9 10 7 8 5 6 1 0]
 
##
new_state(a1,a2,b1,b2,c1,c2,d1,d2) =
    AmphState((minmax(a1,a2)...,minmax(b1,b2)..., minmax(c1,c2)..., minmax(d1,d2)...))
##
function heuristic(state)
    h = 0
    for type in 0:3
        for pos in state[2*type+1:2*type+2]
            h += 10 ^ type * min(distances[pos,target[2*type+1]],distances[pos,target[2*type+2]])
        end
    end
    h
end
##
heuristic((9,8,11,10,13,12,15,6))
##
function neighbours(state)
    n = []
    for (i, pos) in enumerate(state)
        type = (i-1)÷2
        targets = (2*type+8, 2*type+9)
        if pos <= 7 #in hallway
            targets[1] in state && continue # cannot move into target room
            s1 = type + 2
            s2 = type + 3
            blocked = false
            if pos <= s1
                for blocker in pos+1:s1
                    blocker in state && (blocked = true)
                end
            else
                for blocker in s2:pos-1
                    blocker in state && (blocked = true)
                end
            end
            blocked && continue
            bbin = findall(x->x==targets[2], state)
            if length(bbin) == 0 ##back slot in target is empty
                for npos in targets
                    nstate = new_state(state[1:i-1]..., npos, state[i+1:end]...)
                    cost = 10^type * distances[pos,npos]
                    push!(n, (cost,nstate))
                end
            else
                type != (bbin[1]-1)÷2 && continue
                nstate = new_state(state[1:i-1]..., targets[1], state[i+1:end]...)
                cost = 10^type * distances[pos, targets[1]]
                push!(n, (cost,nstate))
            end
        else # not in hallway
            room_ind = (pos - 8) ÷ 2
            (pos - 8) % 2 > 0 && (pos - 1) in state && continue # cannot move out if slot closer to hallway is filled
            l = room_ind + 2
            r = room_ind + 3
            for npos in reverse(1:l)
                npos in state && break
                nstate = new_state(state[1:i-1]..., npos, state[i+1:end]...)
                cost = 10^type * distances[pos,npos]
                push!(n, (cost,nstate))
            end
            for npos in r:7
                npos in state && break
                nstate = new_state(state[1:i-1]..., npos, state[i+1:end]...)
                cost = 10^type * distances[pos,npos]
                push!(n, (cost,nstate))
            end
        end

    end
    n
end
##
neighbours((9,15,8,12,10,13,11,14))
##
function min_cost(state)
    pq = PriorityQueue{Tuple{Int, AmphState}, Int}()
    visited = Set{AmphState}()
    enqueue!(pq, (0, state), heuristic(state))
    while length(pq) > 0
        cur_cost, cur_state = dequeue!(pq)
        cur_state == target && return cur_cost
        for (add_cost, neighbour) in neighbours(cur_state)
            neighbour in visited && continue
            next_cost = cur_cost + add_cost
            (next_cost, neighbour) in keys(pq) && continue
            enqueue!(pq, (next_cost, neighbour), next_cost + heuristic(neighbour))
        end
        push!(visited, cur_state)
    end
    0
end
##
min_cost((9,15,8,12,10,13,11,14))
##
min_cost((10,15,12,13,8,14,9,11))
##
BigState = NTuple{16,Int}
bigtgt = (8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
bigdist = 
[0  1  3  5  7  9  10 3  4  5  6  5  6  7  8  7  8  9  10 9  10 11 12;
 1  0  2  4  6  8  9  2  3  4  5  4  5  6  7  6  7  8  9  8  9  10 11;
 3  2  0  2  4  6  7  2  3  4  5  2  3  4  5  4  5  6  7  6  7  8  9;
 5  4  2  0  2  4  5  4  5  6  7  2  3  4  5  2  3  4  5  4  5  6  7;
 7  6  4  2  0  2  3  6  7  8  9  4  5  6  7  2  3  4  5  2  3  4  5;
 9  8  6  4  2  0  1  8  9  10 11 6  7  8  9  4  5  6  7  2  3  4  5;
 10 9  7  5  3  1  0  9  10 11 12 7  8  9  10 5  6  7  8  3  4  5  6;
 3  2  2  4  6  8  9  0  1  2  3  4  5  6  7  6  7  8  9  8  9  10 11;
 4  3  3  5  7  9  10 1  0  1  2  5  6  7  8  7  8  9  10 9  10 11 12;
 5  4  4  6  8  10 11 2  1  0  1  6  7  8  9  8  9  10 11 10 11 12 13;
 6  5  5  7  9  11 12 3  2  1  0  7  8  9  10 9  10 11 12 11 12 13 14;
 5  4  2  2  4  6  7  4  5  6  7  0  1  2  3  4  5  6  7  6  7  8  9;
 6  5  3  3  5  7  8  5  6  7  8  1  0  1  2  5  6  7  8  7  8  9  10;
 7  6  4  4  6  8  9  6  7  8  9  2  1  0  1  6  7  8  9  8  9  10 11;
 8  7  5  5  7  9  10 7  8  9  10 3  2  1  0  7  8  9  10 9  10 11 12;
 7  6  4  2  2  4  5  6  7  8  9  4  5  6  7  0  1  2  3  4  5  6  7;
 8  7  5  3  3  5  6  7  8  9  10 5  6  7  8  1  0  1  2  5  6  7  8;
 9  8  6  4  4  6  7  8  9  10 11 6  7  8  9  2  1  0  1  6  7  8  9;
 10 9  7  5  5  7  8  9  10 11 12 7  8  9  10 3  2  1  0  7  8  9  10;
 9  8  6  4  2  2  3  8  9  10 11 6  7  8  9  4  5  6  7  0  1  2  3;
 10 9  7  5  3  3  4  9  10 11 12 7  8  9  10 5  6  7  8  1  0  1  2;
 11 10 8  6  4  4  5  10 11 12 13 8  9  10 11 6  7  8  9  2  1  0  1;
 12 11 9  7  5  5  6  11 12 13 14 9  10 11 12 7  8  9  10 3  2  1  0]
 ##
 all(bigdist .== transpose(bigdist))
 ## 
new_state(bs) =
BigState((sort(collect(bs[1:4]))...,sort(collect(bs[5:8]))..., sort(collect(bs[9:12]))..., sort(collect(bs[13:16]))...))
##
function bheuristic(state)
    h = 0
    for type in 0:3
        for pos in state[4*type+1:4*type+4]
            h += 10 ^ type * minimum(bigdist[pos,tpos] for tpos in bigtgt[4*type+1:4*type+4])
        end
    end
    h
end
##
bheuristic((1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16))
##
test_state = BigState((11,23,18,21,8,16,14,17,12,19,13,22,15,20,9,10))
bheuristic(test_state)
##
function bneighbours(state)
    n = []
    for (i, pos) in enumerate(state)
        type = (i-1)÷4
        targets = (4*type+8):(4*type+11)
        if pos <= 7 #in hallway
            targets[1] in state && continue # cannot move into target room
            s1 = type + 2
            s2 = type + 3
            blocked = false
            if pos <= s1
                for blocker in pos+1:s1
                    blocker in state && (blocked = true)
                end
            else
                for blocker in s2:pos-1
                    blocker in state && (blocked = true)
                end
            end
            blocked && continue
            bbin = findall(x->x in targets, state)
            for amph in bbin
                ot = (amph-1)÷4
                if ot != type
                    blocked = true
                end
            end
            blocked && continue

            for npos in targets
                if npos in state
                    break
                end
                nstate = new_state((state[1:i-1]..., npos, state[i+1:end]...))
                cost = 10^type * bigdist[pos,npos]
                push!(n, (cost, nstate))
            end

        else # not in hallway
            room_ind = (pos - 8) ÷ 4
            blocked = false
            for blockpos in (4*room_ind+8):(pos-1)
                if blockpos in state
                    blocked = true
                end
            end
            blocked && continue # cannot move out if a slot closer to hallway is filled
            l = room_ind + 2
            r = room_ind + 3
            for npos in reverse(1:l)
                npos in state && break
                nstate = new_state((state[1:i-1]..., npos, state[i+1:end]...))
                cost = 10^type * bigdist[pos,npos]
                push!(n, (cost,nstate))
            end
            for npos in r:7
                npos in state && break
                nstate = new_state((state[1:i-1]..., npos, state[i+1:end]...))
                cost = 10^type * bigdist[pos,npos]
                push!(n, (cost,nstate))
            end
        end

    end
    n
end
##
bneighbours(test_state)
##
function b_min_cost(state)
    pq = PriorityQueue{Tuple{Int, BigState}, Int}()
    visited = Set{BigState}()
    enqueue!(pq, (0, state), bheuristic(state))
    while length(pq) > 0
        cur_cost, cur_state = dequeue!(pq)
        cur_state == bigtgt && return cur_cost
        for (add_cost, neighbour) in bneighbours(cur_state)
            neighbour in visited && continue
            next_cost = cur_cost + add_cost
            (next_cost, neighbour) in keys(pq) && continue
            enqueue!(pq, (next_cost, neighbour), next_cost + bheuristic(neighbour))
        end
        push!(visited, cur_state)
    end
    0
end
##
b_min_cost(test_state)
##
real_state = (12,23,18,21,16,19,14,17,8,20,13,22,11,15,9,10)
##
b_min_cost(real_state)
##
tdata = readlines("test11.txt")
data = readlines("input11.txt")
##
function simulate(data, nsteps)
    board = zeros(Int, length(data), length(data)[1])
    for (y, line) in enumerate(data)
        for (x, ch) in enumerate(line)
            board[y, x] = ch - '0'
        end
    end

    nflash = 0
    for _ in 1:nsteps
        board .+= 1
        keep_flashing = true
        already_flashed = Set()
        while keep_flashing
            keep_flashing = false
            for y in 1:size(board,1)
                for x in 1:size(board,2)
                    if ~in((y,x), already_flashed) && board[y,x] > 9
                        board[y, x] = 0
                        neighbours = [(y-1, x-1), (y-1, x), (y-1, x+1),
                                      (y, x-1),             (y, x+1),
                                      (y+1, x-1), (y+1,x),  (y+1, x+1)]
                        for neigh in neighbours
                            if (neigh[1] <= size(board,1) && neigh[1] >= 1
                                && neigh[2] <= size(board,2) && neigh[2] >= 1
                                && ~in(neigh, already_flashed))
                                board[neigh...] += 1
                            end
                        end
                        push!(already_flashed, (y,x))
                        keep_flashing = true
                        nflash += 1
                    end
                end
            end
        end
    end
    nflash
end
##
simulate(data, 100)
##
function synchronise(data)
    board = zeros(Int, length(data), length(data)[1])
    for (y, line) in enumerate(data)
        for (x, ch) in enumerate(line)
            board[y, x] = ch - '0'
        end
    end

    s = 1
    while true
        board .+= 1
        keep_flashing = true
        already_flashed = Set()
        while keep_flashing
            keep_flashing = false
            for y in 1:size(board,1)
                for x in 1:size(board,2)
                    if ~in((y,x), already_flashed) && board[y,x] > 9
                        board[y, x] = 0
                        neighbours = [(y-1, x-1), (y-1, x), (y-1, x+1),
                                      (y, x-1),             (y, x+1),
                                      (y+1, x-1), (y+1,x),  (y+1, x+1)]
                        for neigh in neighbours
                            if (neigh[1] <= size(board,1) && neigh[1] >= 1
                                && neigh[2] <= size(board,2) && neigh[2] >= 1
                                && ~in(neigh, already_flashed))
                                board[neigh...] += 1
                            end
                        end
                        push!(already_flashed, (y,x))
                        keep_flashing = true
                        length(already_flashed) == length(board) && return s
                    end
                end
            end
        end
        s += 1
    end
    
end
##
synchronise(tdata)
##
synchronise(data)
##
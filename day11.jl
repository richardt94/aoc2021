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
    for _ = 1:nsteps
        board .+= 1
        stack = []
        [board[y,x] == 10 ? push!(stack, (y,x)) : nothing for y = 1:size(board,1), x = 1:size(board,2)]
        while length(stack) > 0
            (y,x) = pop!(stack)
            board[y,x] = 0
            nflash += 1
            neighbours = [(y-1, x-1), (y-1, x), (y-1, x+1),
                          (y, x-1),             (y, x+1),
                          (y+1, x-1), (y+1,x),  (y+1, x+1)]
            for (y2, x2) in neighbours
                (y2 > size(board,1) || y2 < 1 || x2 > size(board,2) || x2 < 1) && continue
                (board[y2,x2] == 0 || board[y2,x2] == 10) && continue
                board[y2,x2] += 1
                if board[y2,x2] == 10
                    push!(stack, (y2,x2))
                end
            end
        end
    end
    nflash
end
##
simulate(tdata, 100)
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
        stack = []
        nflash = 0
        [board[y,x] == 10 ? push!(stack, (y,x)) : nothing for y = 1:size(board,1), x = 1:size(board,2)]
        while length(stack) > 0
            (y,x) = pop!(stack)
            board[y,x] = 0
            nflash += 1
            neighbours = [(y-1, x-1), (y-1, x), (y-1, x+1),
                          (y, x-1),             (y, x+1),
                          (y+1, x-1), (y+1,x),  (y+1, x+1)]
            for (y2, x2) in neighbours
                (y2 > size(board,1) || y2 < 1 || x2 > size(board,2) || x2 < 1) && continue
                (board[y2,x2] == 0 || board[y2,x2] == 10) && continue
                board[y2,x2] += 1
                if board[y2,x2] == 10
                    push!(stack, (y2,x2))
                end
            end
        end
        nflash == length(board) && break
        s += 1
    end
    s
end
##
synchronise(tdata)
##
synchronise(data)
##
##
tdata = readlines("test4.txt")
data = readlines("input4.txt")
##
function create_boards(data)
    called = parse.(Int, split(data[1], ","))
    boards = []

    li = 2
    row_i = 1
    curboard = nothing
    for li = 2:length(data)
        if data[li] == ""
            if ~isnothing(curboard)
                push!(boards, curboard)
            end
            row_i = 1
            curboard = nothing
            continue
        end
        if row_i == 1
            curboard = Dict()
        end
        row = parse.(Int, split(data[li]))
        for (col_i, num) = enumerate(row)
            curboard[num] = (row_i, col_i)
        end
        row_i += 1
    end

    if ~isnothing(curboard)
        push!(boards, curboard)
    end

    called, boards
end
##
function play(data)
    called, boards = create_boards(data)
    marked = [zeros(Bool, (5,5)) for _ = 1:length(boards)]

    for cnum = called
        println(cnum)
        for (bnum, board) = enumerate(boards)
            if ~haskey(board, cnum)
                continue
            end
            loc = board[cnum]
            marked[bnum][loc...] = true
            row = loc[1]
            col = loc[2]
            vicrow = all(marked[bnum][row,:])
            viccol = all(marked[bnum][:,col])
            if viccol || vicrow
                #score
                println("board $bnum wins")
                println(vicrow,viccol)
                println(marked[bnum])
                unmarked_sum = 0
                for n = keys(board)
                    if ~marked[bnum][board[n]...]
                        unmarked_sum += n
                    end
                end
                return unmarked_sum * cnum
            end
        end
    end

end
##
play(data)
##
function play_last(data)
    called, boards = create_boards(data)
    marked = [zeros(Bool, (5,5)) for _ = 1:length(boards)]
    won = zeros(Bool, length(boards))
    nwon = 0

    for cnum = called
        println(cnum)
        for (bnum, board) = enumerate(boards)
            if won[bnum]
                #don't bother playing boards that have already won
                continue
            end
            if ~haskey(board, cnum)
                continue
            end
            loc = board[cnum]
            marked[bnum][loc...] = true
            row = loc[1]
            col = loc[2]
            vicrow = all(marked[bnum][row,:])
            viccol = all(marked[bnum][:,col])
            if viccol || vicrow
                nwon += 1
                won[bnum] = true
                if nwon == length(boards)
                    #score
                    println("board $bnum wins")
                    println(vicrow,viccol)
                    println(marked[bnum])
                    unmarked_sum = 0
                    for n = keys(board)
                        if ~marked[bnum][board[n]...]
                            unmarked_sum += n
                        end
                    end
                    return unmarked_sum * cnum
                end
            end
        end
    end

end
##
play_last(tdata)
##
play_last(data)
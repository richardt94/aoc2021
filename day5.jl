tdata = readlines("test5.txt")
data = readlines("input5.txt")
##
function overlaps(data)
    marks = Dict()
    for line = data
        (p1, p2) = split(line, "->")
        xy1 = parse.(Int, split(p1,","))
        xy2 = parse.(Int, split(p2,","))
        if xy1[1] == xy2[1]
            x = xy1[1]
            y1 = min(xy1[2], xy2[2])
            y2 = max(xy1[2], xy2[2])
            for y = y1:y2
                if haskey(marks, (x,y))
                    marks[(x,y)] += 1
                else
                    marks[(x,y)] = 1
                end
            end
        elseif xy1[2] == xy2[2]
            y = xy1[2]
            x1 = min(xy1[1], xy2[1])
            x2 = max(xy1[1], xy2[1])
            for x = x1:x2
                if haskey(marks, (x,y))
                    marks[(x,y)] += 1
                else
                    marks[(x,y)] = 1
                end
            end
        end

    end
    nover = 0
    for (x,y) = keys(marks)
        if marks[(x,y)] >= 2
            nover += 1
        end
    end
    nover
end
##
overlaps(tdata)
##
overlaps(data)

##
function overlaps_diag(data)
    marks = Dict()
    for line = data
        (p1, p2) = split(line, "->")
        (x1, y1) = parse.(Int, split(p1,","))
        (x2, y2) = parse.(Int, split(p2,","))
        linelen = max(abs(y2-y1), abs(x2-x1))
        xr = Int.(range(x1, x2, length=linelen+1))
        yr = Int.(range(y1, y2, length=linelen+1))
        for (x,y) = zip(xr, yr)
            if haskey(marks, (x,y))
                marks[(x,y)] += 1
            else
                marks[(x,y)] = 1
            end
        end
    end
    nover = 0
    for (x,y) = keys(marks)
        if marks[(x,y)] >= 2
            nover += 1
        end
    end
    nover
end
##
overlaps_diag(tdata)
##
overlaps_diag(data)
##
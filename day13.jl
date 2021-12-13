tdata = readlines("test13.txt")
##
function first_fold(data)
    dots = Set()
    i = 1
    while data[i] != ""
        dot = parse.(Int, split(data[i],","))
        push!(dots,(dot[1], dot[2]))
        i += 1
    end
    i += 1
    folder = split(data[i], "=")
    direction = folder[1][end]
    value = parse(Int, folder[2])
    fidx = direction == 'y' ? 2 : 1
    for dot in dots
        if dot[fidx] > value
            delete!(dots, dot)
            ndot = fidx == 1 ? (2 * value - dot[1], dot[2]) : (dot[1], 2 * value - dot[2])
            push!(dots, ndot)
        end
    end
    length(dots)
end
##
first_fold(tdata)
##
data = readlines("input13.txt")
first_fold(data)
##
function all_folds(data)
    dots = Set()
    i = 1
    while data[i] != ""
        dot = parse.(Int, split(data[i],","))
        push!(dots,(dot[1], dot[2]))
        i += 1
    end
    i += 1
    for line in data[i:end]
        folder = split(line, "=")
        direction = folder[1][end]
        value = parse(Int, folder[2])
        fidx = direction == 'y' ? 2 : 1
        for dot in dots
            if dot[fidx] > value
                delete!(dots, dot)
                ndot = fidx == 1 ? (2 * value - dot[1], dot[2]) : (dot[1], 2 * value - dot[2])
                push!(dots, ndot)
            end
        end
    end
    x0 = minimum(d[1] for d in dots)
    x1 = maximum(d[1] for d in dots)
    y0 = minimum(d[2] for d in dots)
    y1 = maximum(d[2] for d in dots)
    str = []
    for y in y0:y1
        for x in x0:x1
            if (x,y) in dots
                push!(str, "#")
            else
                push!(str, ".")
            end
        end
        push!(str, "\n")
    end
    prod(str)

end
##
res = all_folds(tdata)
##
res = all_folds(data)
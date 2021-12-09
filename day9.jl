tdata = readlines("test9.txt")

##
function sum_risk(data)
    risk = 0
    for (y, row) in enumerate(data)
        for (x, ch) in enumerate(row)
            if x > 1 && row[x-1] <= ch
                continue
            elseif x < length(row) && row[x+1] <= ch
                continue
            elseif y > 1 && data[y-1][x] <= ch
                continue
            elseif y < length(data) && data[y+1][x] <= ch
                continue
            end
            risk += ch - '0' + 1
        end
    end
    risk
end
##
sum_risk(tdata)
##
data = readlines("input9.txt")
sum_risk(data)
##
function basin_sizes(data)
    lowpoints = []
    for (y, row) in enumerate(data)
        for (x, ch) in enumerate(row)
            if x > 1 && row[x-1] <= ch
                continue
            elseif x < length(row) && row[x+1] <= ch
                continue
            elseif y > 1 && data[y-1][x] <= ch
                continue
            elseif y < length(data) && data[y+1][x] <= ch
                continue
            end
            push!(lowpoints, (x,y))
        end
    end

    bsz = []

    for start in lowpoints
        basin = Set()
        stack = [start]
        while length(stack) > 0
            (x,y) = pop!(stack)
            push!(basin,(x,y))
            ch = data[y][x]
            if x > 1
                cand = data[y][x-1]
                if cand > ch && cand < '9'
                    push!(stack, (x-1,y))
                end
            end
            if x < length(data[1])
                cand = data[y][x+1]
                if cand > ch && cand < '9'
                    push!(stack, (x+1,y))
                end
            end
            if y > 1
                cand = data[y-1][x]
                if cand > ch && cand < '9'
                    push!(stack, (x,y-1))
                end
            end
            if y < length(data)
                cand = data[y+1][x]
                if cand > ch && cand < '9'
                    push!(stack, (x,y+1))
                end
            end
        end

        push!(bsz, length(basin))
    end
    prod(sort(bsz)[end-2:end])

end
##
basin_sizes(tdata)
##
basin_sizes(data)
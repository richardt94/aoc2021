data = readlines("input2.txt")
tdata = readlines("test2.txt")

##

function coursecalc(course)
    x = 0
    y = 0
    for move = split.(course)
        direction = move[1]
        distance = parse(Int, move[2])
        if direction == "forward"
            x += distance
        elseif direction == "up"
            y -= distance
        else
            y += distance
        end
    end
    x*y
end

##
coursecalc(tdata)
##
coursecalc(data)
##
function aimcalc(course)
    aim = 0
    x = 0
    y = 0
    for move = split.(course)
        command = move[1]
        amount = parse(Int, move[2])
        if command == "forward"
            x += amount
            y += aim * amount
        elseif command == "up"
            aim -= amount
        else
            aim += amount
        end
    end
    x*y
end
##
aimcalc(tdata)
##
aimcalc(data)
##

max_y(vy0) = vy0*(vy0+1)÷2
##
function max_vy_target(y2,y1)
    max_v = 0
    for initial_v = 0:(-y2+1)
        v = initial_v+1
        y = 0
        while y >= y2
            y -= v
            v += 1
            if y <= y1 && y >= y2
                max_v = initial_v
                break
            end
        end
    end
    max_v
end
##
max_vy_target(-5,-10)
max_y(max_vy_target(-10,-5))
##
max_y(max_vy_target(-91,-54))

##
function distinct_vs(x1,x2,y2,y1)
    max_v = max_vy_target(y2,y1)
    nvs = 0
    for vy0 = y2:max_v
        for vx0 = 0:x2
            vy = vy0
            vx = vx0
            x = 0
            y = 0
            while y >= y2 && x <= x2
                y += vy
                x += vx
                vy -= 1
                if vx > 0
                    vx -= 1
                end
                if x >= x1 && x <= x2 && y <= y1 && y >= y2
                    nvs += 1
                    break
                end
            end
        end
    end
    nvs
end
##
distinct_vs(20,30,-10,-5)
##
distinct_vs(244,303,-91,-54)
##
test_input = readlines("test22-3.txt")
##
pattern = r"(on|off) x=(-?[0-9]+)\.\.(-?[0-9]+),y=(-?[0-9]+)\.\.(-?[0-9]+),z=(-?[0-9]+)\.\.(-?[0-9]+)"
function parse_rules(inputs)
    rules = []
    for line in inputs
        m = match(pattern, line)
        if ~isnothing(m)
            push!(rules, (m[1] == "on", (parse(Int, m[i]) for i=2:7)...))
        end
    end
    rules
end
##
tr = parse_rules(test_input)
##
function num_on(rules)
    n = 0
    for x=-50:50,y=-50:50,z=-50:50
        for rule in reverse(rules)
            if x >= rule[2] && x <= rule[3] && y >= rule[4] && y <= rule[5] && z >= rule[6] && z <= rule[7]
                rule[1] && (n += 1)
                break
            end
        end
    end
    n
end
##
num_on(parse_rules(test_input))
##
rr = parse_rules(readlines("input22.txt"))
##
num_on(rr)
##
struct Cuboid
    x1::Integer
    x2::Integer
    y1::Integer
    y2::Integer
    z1::Integer
    z2::Integer
end
##
function difference(c1::Cuboid, c2::Cuboid)
    #calculate c1 - c2 as a set of up to 6 cuboids
    ((c2.x1 > c1.x2 || c2.x2 < c1.x1) ||
    (c2.y1 > c1.y2 || c2.y2 < c1.y1) ||
    (c2.z1 > c1.z2 || c2.z2 < c1.z1)) && return [c1]
    new_cuboids = []
    c1_left = [c1.x1, c1.x2, c1.y1, c1.y2, c1.z1, c1.z2]
    if c1_left[2] >= c2.x1 && c1_left[1] < c2.x1
        nc = copy(c1_left)
        nc[2] = c2.x1 - 1
        push!(new_cuboids, Cuboid(nc...))
        c1_left[1] = c2.x1
    end
    if c1_left[1] <= c2.x2 && c1_left[2] > c2.x2
        nc = copy(c1_left)
        nc[1] = c2.x2 + 1
        push!(new_cuboids, Cuboid(nc...))
        c1_left[2] = c2.x2
    end
    if c1_left[4] >= c2.y1 && c1_left[3] < c2.y1
        nc = copy(c1_left)
        nc[4] = c2.y1 - 1
        push!(new_cuboids, Cuboid(nc...))
        c1_left[3] = c2.y1
    end
    if c1_left[3] <= c2.y2 && c1_left[4] > c2.y2
        nc = copy(c1_left)
        nc[3] = c2.y2 + 1
        push!(new_cuboids, Cuboid(nc...))
        c1_left[4] = c2.y2
    end
    if c1_left[6] >= c2.z1 && c1_left[5] < c2.z1
        nc = copy(c1_left)
        nc[6] = c2.z1 - 1
        nc[6] >= nc[5] && push!(new_cuboids, Cuboid(nc...))
        c1_left[5] = c2.z1
    end
    if c1_left[5] <= c2.z2 && c1_left[6] > c2.z2
        nc = copy(c1_left)
        nc[5] = c2.z2 + 1
        push!(new_cuboids, Cuboid(nc...))
        c1_left[6] = c2.z2
    end
    new_cuboids
end
##
c1 = Cuboid(0,3,0,3,0,3)
c2 = Cuboid(1,5,1,2,1,2)
difference(c1,c2)
##
size(c::Cuboid) = (c.x2 - c.x1 + 1) * (c.y2 - c.y1 + 1) * (c.z2 - c.z1 + 1)
##
function num_on_all(rules)
    on = []
    for (i,rule) in enumerate(rules)
        c2 = Cuboid(rule[2:end]...)
        new_on = []
        for c1 in on
            push!(new_on, difference(c1,c2)...)
        end
        rule[1] && push!(new_on, c2)
        on = new_on
    end
    sum(size.(on))
end
##
num_on_all(tr)
##
rr = parse_rules(readlines("input22.txt"))
num_on_all(rr)
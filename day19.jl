## could programmatically generate these but cbf
orientations = 
[(1,2,3), (1,3,-2), (1,-2,-3), (1,-3,2),
(-1,2,-3), (-1,-3,-2), (-1,-2,3), (-1,3,2),
(2,-1,3), (2,3,1), (2,1,-3), (2,-3,-1),
(-2,1,3), (-2,3,-1), (-2,-1,-3), (-2,-3,1),
(3,2,-1), (3,-1,-2), (3,-2,1), (3,1,2),
(-3,2,1), (-3,1,-2), (-3,-2,-1), (-3,-1,2)]
##
length(orientations)
##
transform(orientation, position) = tuple((sign(ax) * position[abs(ax)] for ax in orientation)...)
##
function read_scanners(file)
    data = readlines(file)
    scanners = []
    this_scanner = Set{Tuple{Int,Int,Int}}()
    for line in data[2:end]
        length(line) == 0 && continue
        if startswith(line, "---")
            push!(scanners, this_scanner)
            this_scanner = Set{Tuple{Int,Int,Int}}()
            continue
        end
        coords = tuple(parse.(Int, split(line,","))...)
        push!(this_scanner,coords)
    end
    push!(scanners, this_scanner)
    scanners
end
##
test_scanners = read_scanners("test19.txt")
##
function associate_scanners(scanners)
    scanner_graph = [[] for _ in 1:length(scanners)]
    for (i, s1) = enumerate(scanners)
        for (j, s2) = enumerate(scanners)
            i == j && continue
            for bp1 = s1, bp2 = s2, ornt = orientations
                translation = bp1 .- transform(ornt,bp2)
                transformed = Set(transform(ornt, p) .+ translation for p = s2)
                n_common = length(intersect(transformed,s1))
                if n_common >= 12
                    push!(scanner_graph[i], (j, ornt, translation))
                    break
                end
            end
        end
    end
    scanner_graph       
end
##
associate_scanners(test_scanners)
##
real_scanners = read_scanners("input19.txt")
##
associate_scanners(real_scanners)
##
function compose_transformations(step1, step2)
    r1, t1 = step1
    r2, t2 = step2
    rtot = transform(r2,r1)
    ttot = transform(r2, t1) .+ t2
    (rtot, ttot)
end
##
function scanner_bfs(source, scanner_graph)
    n_scanners = length(scanner_graph)
    q = [(source,((1,2,3),(0,0,0)))]
    visited = zeros(Bool, n_scanners)
    paths = [((1,2,3),(0,0,0)) for _ in 1:n_scanners]
    while ~all(visited)
        cur_scanner, cur_path = popfirst!(q)
        visited[cur_scanner] = true
        for (neighbour, rot, trans) in scanner_graph[cur_scanner]
            visited[neighbour] && continue
            next_path = compose_transformations((rot, trans), cur_path)
            paths[neighbour] = next_path
            push!(q,(neighbour, next_path))
        end
    end
    paths
end
##
function count_beacons(scanners)
    scanner_graph = associate_scanners(scanners)
    paths = scanner_bfs(1, scanner_graph)
    beacons = Set{Tuple{Int,Int,Int}}()
    for (si, (rot, trans)) in enumerate(paths)
        this_scanner = scanners[si]
        this_scanner = (transform(rot,b) .+ trans for b in this_scanner)
        println(this_scanner)        
        push!(beacons, this_scanner...)
    end
    length(beacons)
end

##
count_beacons(real_scanners)

##
function max_dist(scanners)
    scanner_graph = associate_scanners(scanners)
    max_dist = 0
    for source in 1:length(scanner_graph)
        paths = scanner_bfs(source, scanner_graph)
        tmd = maximum(sum(abs.(p[2])) for p in paths)
        if tmd > max_dist
            max_dist = tmd
        end
    end
    max_dist
end
    
##
max_dist(real_scanners)
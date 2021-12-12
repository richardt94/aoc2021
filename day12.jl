##
data = readlines("input12.txt")
tdata = readlines("test12.txt")
tdata2 = readlines("test12-2.txt")
##
function build_graph(data)
    graph = Dict()
    for line = data
        node1, node2 = split(line, "-")
        if ~in(node1, keys(graph))
            graph[node1] = [node2]
        else
            push!(graph[node1], node2)
        end
        if ~in(node2, keys(graph))
            graph[node2] = [node1]
        else
            push!(graph[node2], node1)
        end
    end
    graph
end
##
build_graph(tdata)
##
function enumerate_paths(data, src, dest)
    g = build_graph(data)
    npaths = 0
    marked = Set()

    function process(cur)
        if all(islowercase(c) for c in cur)
            push!(marked, cur)
        end
        if cur == dest
            npaths += 1
        end
        for next in g[cur]
            if ~in(next, marked)
                process(next)
            end
        end

        if in(cur, marked)
            delete!(marked, cur)
        end
    end

    process(src)
    npaths
end
##
enumerate_paths(data, "start", "end")
##
enumerate_paths(tdata2, "start", "end")
##
function enumerate_paths_twice(data, src, dest)
    g = build_graph(data)
    npaths = 0
    marked = Set()
    visited_twice = ""

    function process(cur)
        if all(islowercase(c) for c in cur)
            push!(marked, cur)
        end
        if cur == dest
            npaths += 1
        end
        for next in g[cur]
            if ~in(next, marked)
                process(next)
            elseif visited_twice == ""
                (next == src || next == dest) && continue
                visited_twice = next
                process(next)
            end 
        end

        if in(cur, marked)
            if cur == visited_twice
                visited_twice = ""
            else
                delete!(marked, cur)
            end
        end
    end

    process(src)
    npaths
end
##
enumerate_paths_twice(tdata, "start", "end")
##
enumerate_paths_twice(tdata2, "start", "end")
##
enumerate_paths_twice(data, "start", "end")
##
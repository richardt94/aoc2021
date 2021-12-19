mutable struct SnailNode
    ch_left::Union{Integer,SnailNode,Nothing}
    ch_right::Union{Integer,SnailNode,Nothing}
    par::Union{SnailNode,Nothing}
end
SnailNode() = SnailNode(nothing,nothing,nothing)
##
function parse_snailnumber(st::String)
    root_node = nothing
    cur_node = nothing
    left = true
    for ch in st
        if ch == '['
            new_node = SnailNode()
            if isnothing(root_node)
                root_node = new_node
            else
                new_node.par = cur_node
                if left
                    cur_node.ch_left = new_node
                else
                    cur_node.ch_right = new_node
                end
            end
            cur_node = new_node
            left = true            
        elseif ch == ','
            left = false
        elseif ch == ']'
            left = true
            cur_node = cur_node.par
        else
            if left
                cur_node.ch_left = ch - '0'
            else
                cur_node.ch_right = ch - '0'
            end
        end
    end
    root_node
end
    
##
function snail_to_string(sn::Union{SnailNode,Integer})
    if typeof(sn)<:Integer
        return string(sn)
    end
    "["*snail_to_string(sn.ch_left)*","*snail_to_string(sn.ch_right)*"]"
end
##
function split(sn::SnailNode)
    if typeof(sn.ch_left)<:Integer
        if sn.ch_left > 9
            spl = sn.ch_left / 2
            sn.ch_left = SnailNode(floor(Int,spl), ceil(Int,spl), sn)
            return true
        end
    else
        if split(sn.ch_left)
            return true
        end
    end

    if typeof(sn.ch_right)<:Integer
        if sn.ch_right > 9
            spl = sn.ch_right / 2
            sn.ch_right = SnailNode(floor(Int,spl), ceil(Int,spl), sn)
            return true
        end
    else
        if split(sn.ch_right)
            return true
        end
    end
    false
end
##
function explode(sn::SnailNode, d::Integer)
    if d == 4
        if typeof(sn.ch_left)==SnailNode
            lval = sn.ch_left.ch_left
            rval = sn.ch_left.ch_right
            sn.ch_left = 0
            #right value will always go to the right child
            #if we call explode in the right order
            #the right child will at most be one level deep
            if typeof(sn.ch_right)<:Integer
                sn.ch_right += rval
            else
                sn.ch_right.ch_left += rval
            end
            #find the leftmost neighbour
            cur_node = sn
            while ~isnothing(cur_node.par) && cur_node == cur_node.par.ch_left
                cur_node = cur_node.par
            end
            cur_node = cur_node.par
            if ~isnothing(cur_node)
                if typeof(cur_node.ch_left)<:Integer
                    cur_node.ch_left += lval
                    return true
                end
                cur_node = cur_node.ch_left
                while typeof(cur_node.ch_right) == SnailNode
                    cur_node = cur_node.ch_right
                end
                cur_node.ch_right += lval
            end
            return true
        elseif typeof(sn.ch_right) == SnailNode
            lval = sn.ch_right.ch_left
            rval = sn.ch_right.ch_right
            sn.ch_right = 0
            #left value will always go to the left child
            #if we call explode in the right order
            #the left child will at most be one level deep
            if typeof(sn.ch_left)<:Integer
                sn.ch_left += lval
            else
                sn.ch_left.ch_right += lval
            end
            #find the leftmost neighbour
            cur_node = sn
            while ~isnothing(cur_node.par) && cur_node == cur_node.par.ch_right
                cur_node = cur_node.par
            end
            cur_node = cur_node.par
            if ~isnothing(cur_node)
                if typeof(cur_node.ch_right)<:Integer
                    cur_node.ch_right += rval
                    return true
                end
                cur_node = cur_node.ch_right
                while typeof(cur_node.ch_left) == SnailNode
                    cur_node = cur_node.ch_left
                end
                cur_node.ch_left += rval
            end
            return true

        end
    else
        if typeof(sn.ch_left) == SnailNode && explode(sn.ch_left,d+1)
            return true
        elseif typeof(sn.ch_right) == SnailNode && explode(sn.ch_right, d+1)
            return true
        end
    end
    false
end
##
tree = parse_snailnumber("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")

explode(tree,1)
explode(tree,1)

snail_to_string(tree)
##
function add(sn1::SnailNode, sn2::SnailNode)
    sn_root = SnailNode(sn1,sn2,nothing)
    sn1.par = sn_root
    sn2.par = sn_root

    while true
        if explode(sn_root,1)
            continue
        end
        if ~split(sn_root)
            break
        end
    end

    sn_root
end
##
t1 = parse_snailnumber("[[[[4,3],4],4],[7,[[8,4],9]]]")
t2 = parse_snailnumber("[1,1]")

tres = add(t1,t2)
##
snail_to_string(tres)
##
function sum_file(file)
    snails = readlines(file)
    cur_snail = parse_snailnumber(snails[1])
    for sstr in snails[2:end]
        new_snail = parse_snailnumber(sstr)
        cur_snail = add(cur_snail, new_snail)
    end
    cur_snail
end
##
sum_file("test18-3.txt")
##
function magnitude(sn::Union{SnailNode,Integer})
    if typeof(sn)<:Integer
        return sn
    else
        return 3 * magnitude(sn.ch_left) + 2 * magnitude(sn.ch_right)
    end
end
##
magnitude(sum_file("test18-3.txt"))
magnitude(sum_file("input18.txt"))
##
function max_mag(file)
    snailstrings = readlines(file)
    max_m = 0
    for (i,st1) in enumerate(snailstrings), (j,st2) in enumerate(snailstrings)
        (i == j) && continue
        sn1 = parse_snailnumber(st1)
        sn2 = parse_snailnumber(st2)
        mag = magnitude(add(sn1,sn2))
        if mag > max_m
            max_m = mag
        end
    end
    
    max_m
end
##
max_mag("test18-4.txt")
##
max_mag("input18.txt")
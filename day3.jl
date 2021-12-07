tdata = readlines("test3.txt")
##
function poweruse(data)
    nbits = length(data[1])
    counts = zeros(Int, nbits)
    for number = data
        for i = 1:nbits
            counts[i] += number[i] == '1'
        end
    end
    gammabits = [c >= length(data)/2 for c = counts]
    gamma = 0
    b = 0
    for bit = reverse(gammabits)
        gamma += 2^b * bit
        b += 1
    end
    gamma * (2^nbits - gamma - 1)
end
##
poweruse(tdata)
##
data = readlines("input3.txt")
poweruse(data)
##
function bits2num(bs)
    b = 0
    num = 0
    for bit = reverse(bs)
        num += 2^b * (bit=='1')
        b += 1
    end
    num
end
##
function lifesupport(data)
    n_num = length(data)
    eliminated = zeros(Bool, n_num)
    nbits = length(data[1])
    n_elim = 0
    for b = 1:nbits
        mb = false
        count = 0
        for (i, n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if n[b] == '1'
                count += 1
            end
        end
        if count >= (n_num - n_elim)/2
            mb = true
        end
        for (i,n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if (n[b] == '1') != mb
                eliminated[i] = true
                n_elim += 1
            end
        end
        if n_elim >= n_num - 1
            break
        end
    end
    
    #retrieve o2
    o2 = ""
    for (i, n) = enumerate(data)
        if ~eliminated[i]
            o2 = n
        end
    end

    eliminated = zeros(Bool, n_num)
    n_elim = 0
    for b = 1:nbits
        mb = false
        count = 0
        for (i, n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if n[b] == '1'
                count += 1
            end
        end
        if count < (n_num - n_elim)/2
            mb = true
        end
        for (i,n) = enumerate(data)
            if eliminated[i]
                continue
            end
            if (n[b] == '1') != mb
                eliminated[i] = true
                n_elim += 1
            end
        end
        if n_elim >= n_num - 1
            break
        end
    end

    co2 = ""
    for (i, n) = enumerate(data)
        if ~eliminated[i]
            co2 = n
        end
    end

    bits2num(o2)*bits2num(co2)

end

##

lifesupport(tdata)

##
lifesupport(data)
##
mutable struct Node
    ch0::Union{Node,Nothing}
    ch1::Union{Node,Nothing}
    n::Integer
end

Node() = Node(nothing, nothing, 0)
##
function tree_insert!(tree::Node, s::String)
    tree.n += 1
    if length(s) == 0
        return
    end
    if s[1] == '1'
        if isnothing(tree.ch1)
            tree.ch1 = Node()
        end
        tree_insert!(tree.ch1, s[2:end])
    else
        if isnothing(tree.ch0)
            tree.ch0 = Node()
        end
        tree_insert!(tree.ch0, s[2:end])
    end
end

function build_tree(data)
    tree = Node()
    for number = data
        tree_insert!(tree, number)
    end
    tree
end
##
function traverse(tree::Node; most_common=true)
    num = 0
    while ~(isnothing(tree.ch0) && isnothing(tree.ch1))
        num *= 2
        if isnothing(tree.ch0)
            num += 1
            tree = tree.ch1
            continue
        end
        if isnothing(tree.ch1)
            tree = tree.ch0
            continue
        end
        next = false
        if (tree.ch1.n >= tree.ch0.n && most_common) || (tree.ch1.n < tree.ch0.n && ~most_common)
            next = true
        end
        if next
            num += 1
            tree = tree.ch1
        else
            tree = tree.ch0
        end
    end
    num
end
##
tree = build_tree(tdata)
##
traverse(tree, most_common = false)
##
function lifesupport_tree(data)
    tree = build_tree(data)
    o2 = traverse(tree, most_common=true)
    co2 = traverse(tree, most_common=false)
    o2*co2
end
##
lifesupport_tree(data)
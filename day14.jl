tdata = readlines("test14.txt")
data = readlines("input14.txt")
##
function polymerise_fast(data, nsteps)
    poly = data[1]
    rules = Dict()
    for line in data[3:end]
        rule = strip.(split(line,"->"))
        rules[rule[1]] = rule[2]
    end

    char_count = Dict()
    pair_count = Dict()
    char_count[poly[1:1]] = 1
    for i=1:length(poly)-1
        pair = poly[i:i+1]
        if ~in(pair, keys(pair_count))
            pair_count[pair] = 1
        else
            pair_count[pair] += 1
        end
        if ~in(poly[i+1:i+1], keys(char_count))
            char_count[poly[i+1:i+1]] = 1
        else
            char_count[poly[i+1:i+1]] += 1
        end
    end

    for _ in 1:nsteps
        npair_count = Dict()
        for pair in keys(pair_count)
            nthispair = pair_count[pair]
            new_char = rules[pair]
            new_pairs = ["$(pair[1])$new_char", "$new_char$(pair[2])"]
            for npair in new_pairs
                if ~in(npair, keys(npair_count))
                    npair_count[npair] = nthispair
                else
                    npair_count[npair] += nthispair
                end
            end
            if ~in(new_char, keys(char_count))
                char_count[new_char] = nthispair
            else
                char_count[new_char] += nthispair
            end
        end
        pair_count = npair_count
    end
    maximum(char_count[c] for c in keys(char_count)) - minimum(char_count[c] for c in keys(char_count))
    # char_count, pair_count
end
##
polymerise_fast(data, 40)
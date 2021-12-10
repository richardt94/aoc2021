tdata = readlines("test10.txt")
##
function corrupted(data)
    score = 0
    for line in data
        stack = []
        for ch in line
            if ch == '(' || ch == '[' || ch == '{' || ch == '<'
                push!(stack, ch)
            else
                match = '0'
                if length(stack) != 0
                    match = pop!(stack)
                end
                if ch == ')' && match != '('
                    score += 3
                    break
                elseif ch == ']' && match != '['
                    score += 57
                    break
                elseif ch == '}' && match != '{'
                    score += 1197
                    break
                elseif ch == '>' && match != '<'
                    score += 25137
                    break
                end
            end
        end
    end
    score
end
##
corrupted(tdata)
##
data = readlines("input10.txt")
corrupted(data)
##

function incomplete(data)
    scores = []
    for line in data
        stack = []
        corrupt = false
        for ch in line
            if ch == '(' || ch == '[' || ch == '{' || ch == '<'
                push!(stack, ch)
            else
                match = '0'
                if length(stack) != 0
                    match = pop!(stack)
                end
                if ch == ')' && match != '('
                    corrupt = true
                    break
                elseif ch == ']' && match != '['
                    corrupt = true
                    break
                elseif ch == '}' && match != '{'
                    corrupt = true
                    break
                elseif ch == '>' && match != '<'
                    corrupt = true
                    break
                end
            end
        end
        if ~corrupt
            score = 0 
            for opener in reverse(stack)
                score *= 5
                score += (1 * (opener == '(') + 2 * (opener == '[') + 3 * (opener == '{') + 4 * (opener == '<'))
            end
            push!(scores, score)
        end
    end
    sort(scores)[length(scores)÷2+1]
end
##
incomplete(tdata)
##
incomplete(data)
##
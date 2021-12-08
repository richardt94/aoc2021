tdata = readlines("test8-1.txt")
data = readlines("input8.txt")
##
function out_number(data)
    nunq = 0
    for d = data
        combo_str, out_str = split(d, "|")
        output = split(out_str)
        for out = output
            if length(out) == 2 || length(out) == 3 || length(out) == 4 || length(out) == 7
                nunq += 1
            end
        end
    end
    nunq
end
##
out_number(tdata)
##
out_number(data)
##
function out_sum(data)
    sum_ans = 0
    for d = data
        combo_str, out_str = split(d, "|")
        output = split(out_str)
        combos = split(combo_str)
        one = zeros(Int, 7)
        four = zeros(Int, 7)
        seven = zeros(Int, 7)
        eight = ones(Int, 7)
        fivesegs = []
        sixsegs = []
        for c = combos
            segments = zeros(Int,7)
            segments[[ch - 'a' + 1 for ch = c]] .= 1
            if length(c) == 2
                one = segments
            elseif length(c) == 3
                seven = segments
            elseif length(c) == 4
                four = segments
            elseif length(c) == 5
                push!(fivesegs, segments)
            elseif length(c) == 6
                push!(sixsegs, segments)
            end
        end
        bd = four .- one
        five = zeros(Int,7)
        for f = fivesegs
            if all(f .>= bd)
                five = f
            end
        end
        six = zeros(Int, 7)
        for s = sixsegs
            if all(s .>= bd) && ~all(s .>= one)
                six = s
            end
        end
        nine = zeros(Int, 7)
        for s = sixsegs
            if all(s .>= five) && ~all(s .== six)
                nine = s
            end
        end
        zero = zeros(Int,7)
        for s = sixsegs
            if ~(all(s .== six) || all(s .== nine))
                zero = s
            end
        end
        three = zeros(Int, 7)
        for f = fivesegs
            if all(f .== five)
                continue
            end
            if all(f .<= nine)
                three = f
            end
        end
        two = zeros(Int, 7)
        for f = fivesegs
            if ~(all(f .== five) || all(f .== three))
                two = f
            end
        end
        segments = [zero, one, two, three, four, five, six, seven, eight, nine]
        onum = 0
        for outword = output
            onum *= 10
            outsegs = zeros(Int, 7)
            outsegs[[ch - 'a' + 1 for ch = outword]] .= 1
            for i = 0:9
                if all(outsegs .== segments[i+1])
                    onum += i
                end
            end
        end
        sum_ans += onum
    end
    sum_ans
end
##
tdata2 = readlines("test8-1.txt")
out_sum(tdata2)
##
out_sum(data)
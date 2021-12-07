using Statistics
##
data = readline("input7.txt")
tdata = readline("test7.txt")
##
function best_fuel(data)
    xpos = parse.(Int, split(data, ","))
    target = median(xpos)
    sum(abs.(xpos .- target))
end
##
best_fuel(tdata)
##
best_fuel(data)
##
function best_fuel_2(data)
    xpos = parse.(Int, split(data, ","))
    target_mean = round(Int, mean(xpos))
    target_median = Int(median(xpos))
    x1 = min(target_mean, target_median)
    x2 = max(target_mean, target_median)
    dist = xpos .- x1
    bestcost = Int(sum((dist.^2 + abs.(dist)) / 2))
    for target = (x1+1):x2
        dist = xpos .- target
        cost = Int(sum((dist.^2 + abs.(dist)) / 2))
        if cost < bestcost
            bestcost = cost
        end
    end
    bestcost
end
##
best_fuel_2(tdata)
##
best_fuel_2(data)
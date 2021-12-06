tdata = readline("test6.txt")
data = readline("input6.txt")
##
function simulate(data, time)
    init_timers = parse.(Int, split(data, ","))
    timer_bins = zeros(Int, 9)
    for t = init_timers
        timer_bins[t+1] += 1
    end

    for _ = 1:time
        n_spawn = timer_bins[1]
        timer_bins[1:end-1] = timer_bins[2:end]
        timer_bins[7] += n_spawn
        timer_bins[9] = n_spawn
    end

    sum(timer_bins)
end
##
simulate(data, 256)

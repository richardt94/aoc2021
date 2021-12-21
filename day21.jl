##
function play(start1, start2)
    sc1 = 0
    sc2 = 0
    pos1 = start1
    pos2 = start2
    die = 1
    n_rolls = 0
    while true
        p1_roll = 0
        for _ in 1:3
            p1_roll += die
            die = (die % 100) + 1
        end
        n_rolls += 3
        pos1 = (pos1 + p1_roll - 1) % 10 + 1
        sc1 += pos1
        (sc1 >= 1000) && break
        p2_roll = 0
        for _ in 1:3
            p2_roll += die
            die = (die % 100) + 1
        end
        n_rolls += 3
        pos2 = (pos2 + p2_roll - 1) % 10 + 1
        sc2 += pos2
        (sc2 >= 1000) && break
    end
    n_rolls * ((sc1 < sc2) ? sc1 : sc2)
end
    
##
play(1,3)
##
function n_wins(scp1,scp2,pos1,pos2,roll_idx,dp)
    if (scp1,scp2,pos1,pos2,roll_idx) in keys(dp)
        return dp[(scp1,scp2,pos1,pos2,roll_idx)]
    end
    if scp1 >= 21
        dp[(scp1,scp2,pos1,pos2,roll_idx)] = (1,0)
        return (1,0)
    elseif scp2 >= 21
        dp[(scp1,scp2,pos1,pos2,roll_idx)] = (0,1)
        return (0,1)
    end

    nwins = (0,0)
    for roll_out = 1:3
        if roll_idx < 3
            npos1 = (pos1 + roll_out - 1) % 10 + 1
            if roll_idx == 2
                nwins = nwins .+ n_wins(scp1 .+ npos1, scp2, npos1, pos2, 3, dp)
            else
                nwins = nwins .+ n_wins(scp1, scp2, npos1, pos2, roll_idx + 1, dp)
            end
        else
            npos2 = (pos2 + roll_out - 1) % 10 + 1
            if roll_idx == 5
                nwins = nwins .+ n_wins(scp1, scp2 .+ npos2, pos1, npos2, 0, dp)
            else
                nwins = nwins .+ n_wins(scp1, scp2, pos1, npos2, roll_idx + 1, dp)
            end
        end
    end

    dp[(scp1,scp2,pos1,pos2,roll_idx)] = nwins
    return nwins
end
##
dp = Dict()
n_wins(0,0,1,3,0,dp)
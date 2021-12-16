##
tdata = readlines("test16.txt")
data = readlines("input16.txt")
##
function bits(hex)
    str = ""
    for letter = hex
        if letter == '0'
            str *= "0000"
        elseif letter == '1'
            str *= "0001"
        elseif letter == '2'
            str *= "0010"
        elseif letter == '3'
            str *= "0011"
        elseif letter == '4'
            str *= "0100"
        elseif letter == '5'
            str *= "0101"
        elseif letter == '6'
            str *= "0110"
        elseif letter == '7'
            str *= "0111"
        elseif letter == '8'
            str *= "1000"
        elseif letter == '9'
            str *= "1001"
        elseif letter == 'A'
            str *= "1010"
        elseif letter == 'B'
            str *= "1011"
        elseif letter == 'C'
            str *= "1100"
        elseif letter == 'D'
            str *= "1101"
        elseif letter == 'E'
            str *= "1110"
        elseif letter == 'F'
            str *= "1111"
        end
    end
    str
end
##
bits(tdata[2])
##
function parse_packet_vnums(ind, packet)
    version_number_sum = parse(Int, packet[ind:ind+2]; base=2)
    println("packet version number $version_number_sum starting at index $ind")
    type = parse(Int, packet[ind+3:ind+5]; base=2)
    typestring = type == 4 ? "literal" : "operator"
    println("type is $typestring")
    if type == 4
        i = ind + 6
        chunk = parse(Int, packet[i:i+4]; base=2)
        num = chunk % 16
        while chunk > 16
            num *= 16
            i += 5
            chunk = parse(Int, packet[i:i+4]; base=2)
            num += chunk % 16
        end
        println("value is $num")
        bitlength = i + 5 - ind
        println("finished parsing literal packet starting at $ind, ending at $(i+4)")
        return (version_number_sum, bitlength)
    end
    type_id = packet[ind+6] == '1'
    if type_id
        total_packets_sub = parse(Int, packet[ind+7:ind+17]; base=2)
        println("number of subpackets is $total_packets_sub")
        subind = ind + 18
        for _ = 1:total_packets_sub
            (vs, bl) = parse_packet_vnums(subind, packet)
            version_number_sum += vs
            subind += bl
        end
        bitlength = subind - ind
        println("finished parsing operator packet starting at $ind, ending at $(subind-1)")
    else
        total_bits_sub = parse(Int, packet[ind+7:ind+21]; base=2)
        println("number of subpacket bits is $total_bits_sub")
        subind = ind + 22
        while (subind - (ind + 22)) < total_bits_sub
            (vs, bl) = parse_packet_vnums(subind, packet)
            version_number_sum += vs
            subind += bl
        end
        bitlength = subind - ind
        println("finished parsing operator packet starting at $ind, ending at $(subind-1)")
    end
    return (version_number_sum, bitlength)

end

##
litpack = bits(tdata[1])
##
parse_packet_vnums(1,litpack)
##
subpack_number = bits(tdata[2])
##
parse_packet_vnums(1,subpack_number)
##
subpack_bits = bits(tdata[3])
##
parse_packet_vnums(1, subpack_bits)
##
open("day16dump.txt", "w") do dump
    redirect_stdout(dump)
    parse_packet_vnums(1, bits(data[1]))
end

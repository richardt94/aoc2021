test_input = readlines("test20.txt")
##
mutable struct ImageEnhancer
    rule::String
    image::Matrix{Bool}
    infinity_lit::Bool
end
ImageEnhancer(rule, image) = ImageEnhancer(rule,image,false)
##
function parse_image(data)
    rule = data[1]
    image = zeros(Bool, length(data), length(data[3]))
    for (y,line) in enumerate(data[3:end]), (x,ch) in enumerate(line)
        if ch == '#'
            image[y,x] = true
        end
    end
    ImageEnhancer(rule, image)
end

##
test_image = parse_image(test_input)
##
neighbourhood(y,x) = [(y-1,x-1),(y-1,x),(y-1,x+1),(y,x-1),(y,x),(y,x+1),(y+1,x-1),(y+1,x),(y+1,x+1)]
##
function get_rule(y,x,im)
    idx = 0
    for (yn,xn) in neighbourhood(y,x)
        idx *= 2
        if yn >= 1 && yn <= size(im.image,1) && xn >= 1 && xn <= size(im.image,2)
            im.image[yn,xn] && (idx += 1)
        elseif im.infinity_lit
            idx += 1
        end
    end
    im.rule[idx+1] == '#'
end
##
function enhance_image(im)
    nimage = zeros(Bool, (size(im.image).+2)...)
    for yn in 0:(size(im.image,1)+1), xn in 0:(size(im.image,2)+1)
        if get_rule(yn,xn,im)
            nimage[yn+1,xn+1] = true
        end
    end
    infl = im.infinity_lit
    if im.rule[1] == '#' && ~im.infinity_lit
        infl = true
    end
    if im.rule[end] == '.' && im.infinity_lit
        infl = false
    end
    ImageEnhancer(im.rule, nimage, infl)
end
##
test_enhanced = enhance_image(enhance_image(test_image))

sum(test_enhanced.image)
##
real_input = readlines("input20.txt")
real_image = parse_image(real_input)
##
real_enhanced = enhance_image(enhance_image(real_image))
##
sum(real_enhanced.image)
##
function display_image(image)
    for y=1:size(image,1)
        for x=1:size(image,2)
            if image[y,x]
                print("#")
            else
                print(".")
            end
        end
        print("\n")
    end
end
##
display_image(test_enhanced.image)

##
function enhance_50(im)
    for i in 1:50
        im = enhance_image(im)
    end
    im
end
##
test_enhanced2 = enhance_50(test_image)
##
real_enhanced2 = enhance_50(real_image)
##
sum(real_enhanced2.image)
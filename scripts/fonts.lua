local fonts = {}

fonts.getFont = function(font, size)
    if not fonts[themes.current] then fonts[themes.current] = {} end
    if not fonts[themes.current][font .. size] then
        fonts[themes.current][font .. size] = love.graphics.newFont("data/themes/" .. themes.current .. "/" .. font .. ".ttf", size)
    end
    return fonts[themes.current][font .. size]
end

fonts.drawText = function(font, size, ...)
    local font = fonts.getFont(font, size)

    love.graphics.setFont(font)
    dxDrawText(...)
end

fonts.findall = function(code, find)
    local found = {}
    local lastPos = 0
    while code:find(find, lastPos) do
        local pos = code:find(find, lastPos)
        table.insert(found, pos)
        lastPos = pos + find:len()
    end
    return found
end

fonts.hex2rgb = function(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

fonts.richText = function(font, size, text, x, y, w, h, ...)
    local t = {}
    local last = 1
    for k,v in pairs(fonts.findall(text, "|")) do
        if text:sub(v+7, v+7) == "|" then
            local color = text:sub(v+1, v+6)
            local temp = text:sub(v+8, v+100)
            temp = temp:sub(1, (temp:find("|") or #temp+1)-1)
            table.insert(t, {text=temp, color={fonts.hex2rgb(color)}})
        end
    end
    if #t == 0 then t = {{text=text, color={255,255,255}}} end
    for k,v in pairs(t) do
        fonts.drawText(font, size, v.text, x, y, w, h, v.color)
        x = x + fonts.getWidth(font, size, v.text)
    end
end

fonts.getHeight = function(font, size, text, w)
    local font = fonts.getFont(font, size)

    local _, wt = font:getWrap(text or " ", tonumber(w) or math.huge)
    return #wt * font:getHeight()
end

fonts.getWrap = function(font, size, text, w)
    local font = fonts.getFont(font, size)
    return font:getWrap(text, w)
end

fonts.getWidth = function(font, size, text, w)
    local font = fonts.getFont(font, size)

    local _, wt = font:getWrap(text or " ", tonumber(w) or math.huge)
    local max = 0
    for k,v in pairs(wt) do
        local c = font:getWidth((text or ""))
        if c > max then
            max = c
        end
    end
    return max
end

return fonts
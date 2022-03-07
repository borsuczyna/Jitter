local search = {
    open = false,
    scroll = 1,
}

search.useKey = function(key)
    if key == "return" then
        if not search.open then
            local cx, cy = love.mouse.getPosition()
            search.open = true
            search.x = cx
            search.y = cy
            search.text = ""
            love.keyboard.setTextInput(true)
        else
            love.keyboard.setTextInput(false)
        end
    elseif search.open then
        if #key == 1 then
            search.text = search.text .. key
        elseif key == "backspace" then
            search.text = search.text:sub(1, #search.text-1)
        elseif key == "space" then
            search.text = search.text .. " "
        end
    end
end

search.findall = function(code, find)
    local found = {}
    local lastPos = 0
    while code:find(find, lastPos) do
        local pos = code:find(find, lastPos)
        table.insert(found, pos)
        lastPos = pos + find:len()
    end
    return found
end

search.functionsByName = function(text)
    local count = 0
    local t = {}
    for k,v in pairs(scripting) do
        if v.name and languages.text(v.name):lower():find(text:lower()) then
            if #text > 0 then
                local p = languages.text(v.name):lower():find(text:lower())
                if p then
                    t[k] = {data=v, position=p}
                    count = count + 1
                end
            else
                t[k] = {data=v, position=0}
                count = count + 1
            end
        end
    end
    return t, count
end

search.drawSearch = function()
    if not search.open then return end

    local zoom = 2
    local path = "data/themes/" .. themes.current .. "/"
    local side, top = getImageSize(path .. "block_top_side.png")
    side, top = side*zoom, top*zoom
    local x, y = search.x, search.y
    local w = 150

    local t, count = search.functionsByName(search.text)
    search.scroll = math.min(math.max(search.scroll, 1), count-12)

    for k,v in pairs(t) do
        local curr = fonts.getWidth("regular", 14, languages.text(v.data.name))+side*1.2
        if w < curr then
            w = curr
        end
    end

    dxDrawImage(x, y, side, side, path .. "search_top_side.png")
    dxDrawImage(x + side, y, w-side*2, side, path .. "search_top.png")
    dxDrawImage(x + w, y, -side, side, path .. "search_top_side.png")
    dxDrawImage(x, y+side, side, side*10, path .. "search_side.png")
    dxDrawImage(x + w, y+side, -side, side*10, path .. "search_side.png")
    dxDrawImage(x + w, y+side*12, -side, -side, path .. "search_top_side.png")
    dxDrawImage(x, y+side*12, side, -side, path .. "search_top_side.png")
    dxDrawImage(x + side, y + side*12, w-side*2, -side, path .. "search_top.png")
    dxDrawImage(x + side, y + side, w-side*2, side*10, path .. "search_middle.png")

    if not isMouseInPosition(x, y, side*7, side*12) and love.mouse.isDown(1) then
        search.open = false
    end

    dxDrawRectangle(x+side/2, y+side/2, w-side, side/1.2, {0, 0, 0, 55})

    local text = search.text .. (tickCount % 1000 > 500 and "|" or "")
    while fonts.getWidth("regular", 14, text) > w - side*2 do
        text = text:sub(1, #text-1)
    end
    fonts.drawText("regular", 14, text, x+side/1.6, y+side/1.5, sx, sy)

    local _y = 23
    local id = 1
    for k,v in pairs(t) do
        if id >= search.scroll and id <= search.scroll + 12 then
            local pre, mid, fot = languages.text(v.data.name), "", ""
            if v.position > 0 then
                pre = languages.text(v.data.name):sub(1, v.position-1)
                mid = languages.text(v.data.name):sub(v.position, v.position+#search.text-1)
                fot = languages.text(v.data.name):sub(v.position+#search.text, #languages.text(v.data.name))
            end

            if isMouseInPosition(x+side/2.2, y+side/1.7 + _y, side*6, 18) then
                dxDrawRectangle(x+side/2.2, y+side/1.7 + _y, w-side, 18, {25, 25, 25, 100})

                if love.mouse.isDown(1) then
                    local x, y = love.mouse.getPosition()
                    x, y = render.getWorldFromScreenPosition(x, y)
                    blocks.addBlock(k, x, y)
                    party.updateBlocks()
                    search.open = false
                end
            end

            fonts.drawText("regular", 14, pre, x+side/1.6, y+side/1.5 + _y, sx, sy, {255, 255, 255, 155})
            fonts.drawText("bold", 14, mid, x+side/1.6 + fonts.getWidth("regular", 14, pre), y+side/1.5 + _y, sx, sy, {255, 155, 155, 255})
            fonts.drawText("regular", 14, fot, x+side/1.6 + fonts.getWidth("regular", 14, pre) + fonts.getWidth("bold", 14, mid), y+side/1.5 + _y, sx, sy, {255, 255, 255, 155})
            _y = _y + 20
        end
        id = id + 1
    end
end

search.wheelmoved = function(x, y)
    if not search.open then return end
    search.scroll = search.scroll - y
end

return search
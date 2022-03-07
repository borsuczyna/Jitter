local blocks = {
    binAlpha = 0,
    smoothPosition = {},
    blocks = {}
}

blocks.addBlock = function(data, x, y)
    table.insert(blocks.blocks, {
        x = x,
        y = y,
        active = false,
        data = data,
        continue = false,
        continued = false,
        input = {},
        output = {}
    })
end

blocks.getBlockColorPicker = function(x, y)
    local w, h =  getImageSize("data/themes/" .. themes.current .. "/color_picker.png")
    local r, g, b, a = getImagePixelColor(math.max(math.min(x*w, w-1), 0), math.max(math.min(y*h, h-1), 0), "data/themes/" .. themes.current .. "/color_picker.png")
    return {math.floor(r*255), math.floor(g*255), math.floor(b*255), math.floor(a*255)}
end

blocks.drawComment = function(data, id)
    local path = "data/themes/" .. themes.current .. "/"

    local zoom = 2*render.zoom

    local x, y = render.getScreenFromWorldPosition(data.x, data.y)
    local side, top = getImageSize(path .. "comment_side_top.png")
    side, top = math.floor(side*zoom), math.floor(top*zoom)

    local script = scripting[data.data]

    local w, h = (data.comment_w and data.comment_w*zoom or 200*zoom), (data.comment_h and data.comment_h*zoom or 150*zoom)

    --dxDrawRectangle(x, y, w, h, {255, 0, 0, 15})
    dxDrawImage(x, y, side, side, path.."comment_side_top.png")
    dxDrawImage(x+side, y, w-side*2, side, path.."comment_top.png")
    dxDrawImage(x+w, y, -side, side, path.."comment_side_top.png")
    dxDrawImage(x, y+side, side, h-side*2, path.."comment_side.png")
    dxDrawImage(x, y+h, side, -side, path.."comment_side_top.png")
    dxDrawImage(x+side, y+h, w-side*2, -side, path.."comment_top.png")
    dxDrawImage(x+w, y+side, -side, h-side*2, path.."comment_side.png")
    dxDrawImage(x+w, y+h, -side, -side, path.."comment_side_top.png")
    dxDrawImage(x+side, y+side, w-side*2, h-side*2, path.."comment_middle.png")

    local commentText = data.commentText and (data.commentText .. ((tickCount % 1000 > 500 and data.editing) and "|" or "")) or languages.text("Comment")
    local ww = 100*zoom
    local textw = fonts.getWidth("regular", 12, commentText)*zoom
    
    if isMouseInPosition(x+w/2-ww/2, y+5*zoom, ww, 12*zoom) and love.mouse.isDown(1) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
        data.editing = true
        blocks.holdingComment = true
        data.commentText = (data.commentText or "")
    elseif love.mouse.isDown(1) and not isMouseInPosition(x+w/2-ww/2, y+5*zoom, ww, 12*zoom) then
        data.editing = false
        data.commentText = ((data.commentText and #data.commentText > 0) and data.commentText or false)
    end

    love.graphics.push()
    love.graphics.scale(zoom, zoom)
    fonts.drawText("regular", 12, commentText, x/zoom, y/zoom + 5, w/zoom, h/zoom, {255, 255, 255}, false, "center")
    love.graphics.pop()

    if not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
        local cx, cy = love.mouse.getPosition()
        cx, cy = render.getWorldFromScreenPosition(cx, cy)
        if isMouseInPosition(x, y, w, side) and not render.holdScene and love.mouse.isDown(1) then
            blocks.grabBlock = {id=id, x=cx-data.x, y=cy-data.y}
        end
    elseif blocks.grabBlock then
        if not love.mouse.isDown(1) then
            blocks.grabBlock = false
        else
            local cx, cy = love.mouse.getPosition()
            cx, cy = render.getWorldFromScreenPosition(cx, cy)
            blocks.blocks[blocks.grabBlock.id].x = cx - blocks.grabBlock.x
            blocks.blocks[blocks.grabBlock.id].y = cy - blocks.grabBlock.y
        end
    end

    if isMouseInPosition(x+w-side*1.5, y+h-side*1.5, side*2, side*2) and love.mouse.isDown(1) and not blocks.holdingComment then
        local cx, cy = love.mouse.getPosition()
        cx, cy = render.getWorldFromScreenPosition(cx, cy)
        cx, cy = cx - data.x, cy - data.y

        data.comment_w = math.max(cx/2+side/4, side*4/zoom)
        data.comment_h = math.max(cy/2+side/4, side*3/zoom)
        blocks.holdingComment = true
        render.holdScene = false
    end

    data.comment_w = math.max((data.comment_w or 0), math.max(textw/zoom+side/zoom, side*4/zoom))
end

blocks.drawBlock = function(data, id)
    local path = "data/themes/" .. themes.current .. "/"
    local zoom = 2*render.zoom

    local x, y = render.getScreenFromWorldPosition(data.x, data.y)
    local side, top = getImageSize(path .. (data.active and "block_top_side_active.png" or "block_top_side.png"))
    side, top = math.floor(side)*zoom, math.floor(top)*zoom

    local script = scripting[data.data]

    local w, h = math.max(fonts.getWidth("regular", 13, languages.text(script.name))*zoom+10*zoom, 100*zoom), fonts.getHeight("regular", 13)*zoom/5
    local maxw = 0
    for k,v in pairs(script.input) do
        local ic = 0
        local left = side+fonts.getWidth("regular", 13, languages.text(v.name))*zoom+side/2
        if v.type == "number" or v.type == "string" then
            local text = (((data.input[k] and data.input[k].value and #data.input[k].value > 0) and data.input[k].value or (data.input[k] and data.input[k].editActive) and ((data.input[k].value or "")))) or v.default
            local _w = math.max(fonts.getWidth("regular", 13, text)*zoom+4*zoom, side*3)
            ic = _w
        end
        if #script.output > 0 then
            for _,c in pairs(script.output) do
                local iw = ic + left
                iw = iw + side+fonts.getWidth("regular", 13, languages.text(c.name))*zoom
                if iw > maxw then
                    maxw = iw
                end
            end
        else
            if ic > maxw then
                maxw = ic + side*5
            end
        end
    end
    if maxw > w then w = maxw end
    if script.color then
        w = w+getImageSize(path .. "color_picker.png")*zoom/2-side*3
    end

    local startx, starty = x, y
    local blockw, blocktop = w+side*2, h+side*2

    dxDrawImage(x, y, side+1, top+1, path .. (data.active and "block_top_side_active.png" or "block_top_side.png"))
    dxDrawImageSection(x+side, y, w+2, top+1, 0, 0, w/zoom, top/zoom, path .. (data.active and "block_top_active.png" or "block_top.png"))
    dxDrawImage(x+w+side*2, y, -side-1, top+1, path .. (data.active and "block_top_side_active.png" or "block_top_side.png"))
    dxDrawImageSection(x, y+top, side+1, h+1, 0, 0, side/zoom, h/zoom, path .. (data.active and "block_side_active.png" or "block_side.png"))
    dxDrawImage(x, y+h+top, side+1, top+1, path .. (data.active and "block_down_side_active.png" or "block_down_side.png"))
    dxDrawImageSection(x+w+side*2, y+top, -side-1, h+1, 0, 0, side/zoom, h/zoom, path .. (data.active and "block_side_active.png" or "block_side.png"))
    dxDrawImage(x+w+side*2, y+h+top, -side-1, top+1, path .. (data.active and "block_down_side_active.png" or "block_down_side.png"))
    dxDrawImageSection(x+side, y+h+top, w+1, top+1, 0, 0, w/zoom, top/zoom, path .. (data.active and "block_down_active.png" or "block_down.png"))
    dxDrawImageSection(x+side-1.25, y+top-1.25, w+2.5, h+2.5, 0, 0, w/zoom, h/zoom, path .. (data.active and "block_middle_active.png" or "block_middle.png"))

    dxDrawRectangle(x+2*zoom, y+2*zoom, w+side*2-4*zoom, 1*zoom, (script.shared and {0, 255, 0, 255}) or (script.server and {255, 155, 0, 255}) or {255, 0, 0, 255})

    love.graphics.push()
    love.graphics.scale(zoom, zoom)
    fonts.drawText("regular", 13, languages.text(script.name), x/zoom+side/2/zoom, y/zoom+top/1.6/zoom, w/zoom+side/zoom, render.sy, {255, 255, 255}, false, "center")
    love.graphics.pop()

    y = y + h + top*2
    local h = 0

    local ih = 0
    for k,v in pairs(script.input) do
        ih = ih + 18*zoom
    end
    if ih-top*1.5 > h then h = ih-top*1.5 end
    local ih = 0
    for k,v in pairs(script.output) do
        ih = ih + 18*zoom
    end
    if ih-top*1.5 > h then h = ih-top*1.5 end

    if script.else_out then
        h = h + side*1.2
    end

    if script.input_able then
        h = h + side
    elseif script.condition then
        h = h + side

        for k,v in pairs(data.conditions or {}) do
            h = h + side*1.2
        end
    elseif script.continue then
        h = h + side
    end

    if script.color then
        picker_side, picker_top = getImageSize(path .. "color_picker.png")
        picker_side, picker_top = picker_side*zoom/2,picker_top*zoom/2
        h = h+picker_top-side
    end

    blockh = h+side*2
    dxDrawImage(x, y, side+1, top+1, path .. "info_top_side" .. (data.active and "_active.png" or ".png"))
    dxDrawImageSection(x+side, y, w+2, top+1, 0, 0, w/zoom, top/zoom, path .. "info_top" .. (data.active and "_active.png" or ".png"))
    dxDrawImage(x+w+side*2, y, -side-1, top+1, path .. "info_top_side" .. (data.active and "_active.png" or ".png"))
    dxDrawImageSection(x, y+top, side+1, h+1, 0, 0, side/zoom, h/zoom, path .. "info_side" .. (data.active and "_active.png" or ".png"))
    dxDrawImage(x, y+h+top, side+1, top+1, path .. "info_down_side" .. (data.active and "_active.png" or ".png"))
    dxDrawImageSection(x+w+side*2, y+top, -side-1, h+1, 0, 0, side/zoom, h/zoom, path .. "info_side" .. (data.active and "_active.png" or ".png"))
    dxDrawImage(x+w+side*2, y+h+top, -side-1, top+1, path .. "info_down_side" .. (data.active and "_active.png" or ".png"))
    dxDrawImageSection(x+side, y+h+top, w+1, top+1, 0, 0, w/zoom, top/zoom, path .. "info_down" .. (data.active and "_active.png" or ".png"))
    dxDrawImageSection(x+side-1.25, y+top-1.25, w+2.5, h+2.5, 0, 0, w/zoom, h/zoom, path .. "info_middle" .. (data.active and "_active.png" or ".png"))

    if script.color then
        dxDrawImage(x+side/2, y+side/2, picker_side, picker_top, path .. "color_picker.png")
        dxDrawRectangle(x+side/2 + picker_side+side/3, y+side/2, side, picker_top, blocks.getBlockColorPicker(data.color_picker and data.color_picker[1] or 0, data.color_picker and data.color_picker[2] or 0))
        dxDrawImage(x+side/2-7*zoom+(data.color_picker and data.color_picker[1] or 0)*picker_side, y+side/2-7*zoom+(data.color_picker and data.color_picker[2] or 0)*picker_top, 14*zoom, 14*zoom, path .. "pick.png")

        if isMouseInPosition(x+side/2, y+side/2, picker_side, picker_top) and love.mouse.isDown(1) then
            local cx, cy = love.mouse.getPosition()
            data.color_picker = {(cx - (x+side/2))/picker_side, (cy - (y+side/2))/picker_top}
            blocks.changingPickerColor = true
        end
    end

    if script.condition then
        dxDrawRectangle(x+side/2 - 3*zoom, y+top*1.6 - 1*zoom, 100*zoom, 15*zoom, {0, 0, 0, 65})
        love.graphics.push()
        love.graphics.scale(zoom, zoom)
        fonts.drawText("regular", 13, "Add condition", x/zoom+side/2/zoom, y/zoom+top*1.6/zoom, 5000, 5000)
        love.graphics.pop()

        if isMouseInPosition(x+side/2 - 3*zoom, y+top*1.6 - 1*zoom, 100*zoom, 15*zoom) and love.mouse.isDown(1) and tickCount - (lastcondition or 0) > 1000 and not blocks.addedCondition then
            if not data.conditions then data.conditions = {} end
            table.insert(data.conditions, {connection=false})
            lastcondition = tickCount
            blocks.addedCondition = true
        end

        for k,v in pairs(data.conditions or {}) do
            local color = scripting.dataTypes.condition.color
            local canConnect = (blocks.holdConnection and blocks.holdConnection.type == "output" and blocks.holdConnection.id ~= id and not v.connection)
            color = ((not blocks.holdConnection and color) or canConnect and color or {color[1], color[2], color[3], 55})
            local cx, cy = x-side*1.3, y+top/4 + side + side/2 + side*k*1.2
            dxDrawImage(cx + side/3, cy + side/3, side/2, side/2, path .. "ball.png", color)

            if blocks.holdConnection and not love.mouse.isDown(1) and isMouseInPosition(cx + side/4, cy + side/4, side, side) and canConnect then
                local data = blocks.blocks[blocks.holdConnection.id].output[blocks.holdConnection.index]
                if not data then
                    data = {}
                end
                v.connection = {blocks.holdConnection.id, blocks.holdConnection.index}
                data.connection = {id, k, "condition"}
                blocks.holdConnection = false

                party.updateBlocks()
            end

            if v.connection then
                table.insert(connections, {type="condition_input", x = cx + side/3 + side/4, y = cy + side/3 + side/4, id = v.connection[1], index = v.connection[2]})
            end

            for d,c in pairs(connections) do
                if c.id == id and c.index == k and c.type == "condition_output" then
                    render.cubicLine({c.x, c.y}, {cx + side/3 + side/4, cy + side/3 + side/4}, {c.x + (cx + side/3 + side/4 - c.x)/2, c.y}, {cx + side/3 + side/4 - (cx + side/3 + side/4 - c.x)/2, cy + side/3 + side/4}, color, 1)
                end
            end

            love.graphics.push()
            love.graphics.scale(zoom, zoom)
            fonts.drawText("regular", 13, "condition", x/zoom+side/2/zoom, y/zoom+top*1.6/zoom + side/4/zoom + side*1.2/zoom*k, 5000, 5000)
            love.graphics.pop()
        end
    end

    if script.input_able then
        local cx, cy = x-side*1.3, y+top/4
        local color = scripting.dataTypes.connection.color
        local canConnect = (blocks.holdConnection and (blocks.holdConnection.type == "execute_output" or blocks.holdConnection.type == "execute_output_else") and blocks.holdConnection.id ~= id and not data.continued and not data.continued_else)
        color = ((not blocks.holdConnection and color) or canConnect and color or {color[1], color[2], color[3], 55})
        dxDrawImage(cx, cy, side, side, path .. "arrow.png", color)
        dxDrawImage(x+side/3, y+top/4, side, side, path .. "arrow2.png", color)
        y = y + side*1.3

        for d,c in pairs(connections) do
            if c.connection == id and (c.type == "continue_output" or c.type == "continue_output_else") then
                render.cubicLine({c.x, c.y}, {cx + side/2, cy + side/2}, {c.x + (cx + side/2 - c.x)/2, c.y}, {cx + side/2 - (cx - c.x)/2, cy + side/2}, color, 1)
            end
        end

        if data.continued then
            table.insert(connections, {type="continue_input", x = cx + side/2, y = cy + side/2, connection = data.continued})
        end

        if data.continued_else then
            table.insert(connections, {type="continue_input_else", x = cx + side/2, y = cy + side/2, connection = data.continued_else})
        end

        if blocks.holdConnection and blocks.holdConnection.type == "execute_input" and blocks.holdConnection.id == id then
            local c = {x=cx + side/2, y=cy + side/2}
            local cx, cy = love.mouse.getPosition()
            render.cubicLine({c.x, c.y}, {cx, cy}, {c.x + (cx - c.x)/2, c.y}, {cx - (cx - c.x)/2, cy}, scripting.dataTypes.connection.color, 1)
        end

        if isMouseInPosition(cx - side/4, cy - side/4, side, side) and not blocks.grabBlock and not search.open and not code.open and not saving.open then
            if love.mouse.isDown(1) and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
                if data.continued then
                    blocks.blocks[data.continued].continue = false
                    data.continued = false
                end
                if data.continued_else then
                    blocks.blocks[data.continued_else].continue_else = false
                    data.continued_else = false
                end
                blocks.holdConnection = {type="execute_input", id=id, value_type="execute"}
            elseif blocks.holdConnection and (blocks.holdConnection.type == "execute_output" or blocks.holdConnection.type == "execute_output_else") and blocks.holdConnection.id ~= id and not love.mouse.isDown(1) and canConnect then
                if blocks.holdConnection.type == "execute_output" then
                    data.continued = blocks.holdConnection.id
                    blocks.blocks[blocks.holdConnection.id].continue = id
                else
                    data.continued_else = blocks.holdConnection.id
                    blocks.blocks[blocks.holdConnection.id].continue_else = id
                end
                blocks.holdConnection = false

                party.updateBlocks()
            end
        end
    end

    if script.continue then
        if script.input_able then
            y = y - side*1.3
        end
        local cx, cy = x+w+side/2+side*2, y+top/3 + side/4
        local color = scripting.dataTypes.connection.color
        local canConnect = (blocks.holdConnection and blocks.holdConnection.type == "execute_input" and blocks.holdConnection.id ~= id and not data.continue and not data.continue_else)
        color = ((not blocks.holdConnection and color) or canConnect and color or {color[1], color[2], color[3], 55})
        dxDrawImage(cx, cy, side/2, side/2, path .. "arrow.png", color)
        dxDrawImage(x+w+side/2, y+top/3, side, side, path .. "arrow.png", color)

        love.graphics.push()
        love.graphics.scale(zoom, zoom)
        fonts.drawText("regular", 13, languages.text("Execute"), x/zoom+side*1.6/zoom, y/zoom+top/3/zoom + 1, w/zoom - side/zoom*1.4, 500, {255, 255, 255}, false, "right")
        love.graphics.pop()

        for d,c in pairs(connections) do
            if c.connection == id and c.type == "continue_input" then
                render.cubicLine({c.x, c.y}, {cx + side/4, cy + side/4}, {c.x + (cx + side/2 - c.x)/2, c.y}, {cx + side/2 - (cx + side/2 - c.x)/2, cy + side/2}, color, 1)
            end
        end

        if data.continue then
            table.insert(connections, {type="continue_output", x = cx + side/4, y = cy + side/4, connection = data.continue})
        end

        if blocks.holdConnection and blocks.holdConnection.type == "execute_output" and blocks.holdConnection.id == id then
            local c = {x=cx + side/4, y=cy + side/4}
            local cx, cy = love.mouse.getPosition()
            render.cubicLine({c.x, c.y}, {cx, cy}, {c.x + (cx - c.x)/2, c.y}, {cx - (cx - c.x)/2, cy}, scripting.dataTypes.connection.color, 1)
        end

        if isMouseInPosition(cx - side/4, cy - side/4, side, side) and not blocks.grabBlock and not search.open and not code.open and not saving.open then
            if love.mouse.isDown(1) and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
                if data.continue then
                    blocks.blocks[data.continue].continued = false
                    data.continue = false
                end
                blocks.holdConnection = {type="execute_output", id=id, value_type="execute"}
            elseif blocks.holdConnection and blocks.holdConnection.type == "execute_input" and blocks.holdConnection.id ~= id and not love.mouse.isDown(1) and canConnect then
                data.continue = blocks.holdConnection.id
                blocks.blocks[blocks.holdConnection.id].continued = id
                blocks.holdConnection = false

                party.updateBlocks()
            end
        end

        y = y + side*1.3
    end

    if script.else_out then
        local cx, cy = x+w+side/2+side*2, y+top/3 + side/4
        local color = scripting.dataTypes.connection.color
        local canConnect = (blocks.holdConnection and blocks.holdConnection.type == "execute_input" and blocks.holdConnection.id ~= id and not data.continue and not data.continue_else)
        color = ((not blocks.holdConnection and color) or canConnect and color or {color[1], color[2], color[3], 55})
        dxDrawImage(cx, cy, side/2, side/2, path .. "arrow.png", color)
        dxDrawImage(x+w+side/2, y+top/3, side, side, path .. "arrow.png", color)

        love.graphics.push()
        love.graphics.scale(zoom, zoom)
        fonts.drawText("regular", 13, "Else", x/zoom+side*1.6/zoom, y/zoom+top/3/zoom + 1, w/zoom - side/zoom*1.4, 500, {255, 255, 255}, false, "right")
        love.graphics.pop()

        for d,c in pairs(connections) do
            if c.connection == id and c.type == "continue_input_else" then
                render.cubicLine({c.x, c.y}, {cx + side/4, cy + side/4}, {c.x + (cx + side/2 - c.x)/2, c.y}, {cx + side/2 - (cx + side/2 - c.x)/2, cy + side/2}, color, 1)
            end
        end

        if data.continue_else then
            table.insert(connections, {type="continue_output_else", x = cx + side/4, y = cy + side/4, connection = data.continue_else})
        end

        if blocks.holdConnection and blocks.holdConnection.type == "execute_output_else" and blocks.holdConnection.id == id then
            local c = {x=cx + side/4, y=cy + side/4}
            local cx, cy = love.mouse.getPosition()
            render.cubicLine({c.x, c.y}, {cx, cy}, {c.x + (cx - c.x)/2, c.y}, {cx - (cx - c.x)/2, cy}, scripting.dataTypes.connection.color, 1)
        end

        if isMouseInPosition(cx - side/4, cy - side/4, side, side) and not blocks.grabBlock and not search.open and not code.open and not saving.open then
            if love.mouse.isDown(1) and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
                if data.continue_else then
                    blocks.blocks[data.continue_else].continued_else = false
                    data.continue_else = false
                end
                blocks.holdConnection = {type="execute_output_else", id=id, value_type="execute"}
            elseif blocks.holdConnection and blocks.holdConnection.type == "execute_input" and blocks.holdConnection.id ~= id and not love.mouse.isDown(1) and canConnect then
                data.continue_else = blocks.holdConnection.id
                blocks.blocks[blocks.holdConnection.id].continued_else = id
                blocks.holdConnection = false

                party.updateBlocks()
            end
        end

        y = y + side*1.3
    end

    for k,v in pairs(script.input) do
        local cx, cy = x-side*1.3+side/4, y+top/3 + (k-1)*18*zoom+side/4
        local color = scripting.dataTypes[v.type].color
        
        local connected = (data.input and data.input[k] and data.input[k].connection)
        local canConnect = (blocks.holdConnection and (blocks.holdConnection.value_type == v.type or v.type == "everything" or blocks.holdConnection.value_type == "everything") and blocks.holdConnection.type == "output" and not connected and blocks.holdConnection.id ~= id)
        color = ((not blocks.holdConnection and color or canConnect) and color or {color[1], color[2], color[3], 50})
        dxDrawImage(cx, cy, side/2, side/2, path .. v.icon .. ".png", color)
        dxDrawImage(x+side/3, y+top/3 + (k-1)*18*zoom, side, side, path .. v.icon .. ".png", color)

        if isMouseInPosition(cx - side/4, cy - side/4, side, side) and not blocks.grabBlock and not search.open and not code.open and not saving.open then
            if love.mouse.isDown(1) and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
                blocks.holdConnection = {type="input", id=id, index=k, value_type=v.type}

                if data.input and data.input[k] and data.input[k].connection then
                    local _id = id
                    local id = data.input[k].connection
                    local ndata = blocks.blocks[id[1]]
                    if ndata and ndata.output and ndata.output[id[2]] and ndata.output[id[2]].connection then
                        for j,m in pairs(ndata.output[id[2]].connection) do
                            if m[1] == _id and m[2] == k then
                                table.remove(ndata.output[id[2]].connection, j)
                            end
                        end
                    end
                    if data.input[k] then
                        data.input[k].connection = false
                    else
                        data.input[k] = {}
                    end
                end
            elseif blocks.holdConnection and canConnect and not love.mouse.isDown(1) then
                if not blocks.blocks[blocks.holdConnection.id].output then
                    blocks.blocks[blocks.holdConnection.id].output = {}
                end
                if not blocks.blocks[blocks.holdConnection.id].output[blocks.holdConnection.index] then
                    blocks.blocks[blocks.holdConnection.id].output[blocks.holdConnection.index] = {}
                end
                if not blocks.blocks[blocks.holdConnection.id].output[blocks.holdConnection.index].connection then
                    blocks.blocks[blocks.holdConnection.id].output[blocks.holdConnection.index].connection = {}
                end
                table.insert(blocks.blocks[blocks.holdConnection.id].output[blocks.holdConnection.index].connection, {id, k})
                
                if not blocks.blocks[id].input then
                    blocks.blocks[id].input = {}
                end
                if not blocks.blocks[id].input[k] then
                    blocks.blocks[id].input[k] = {}
                end
                blocks.blocks[id].input[k].connection = {blocks.holdConnection.id, blocks.holdConnection.index}

                blocks.holdConnection = false

                party.updateBlocks()
            end
        end

        if blocks.holdConnection and blocks.holdConnection.type == "input" and blocks.holdConnection.id == id and blocks.holdConnection.index == k then
            local c = {x=cx + side/4, y=cy + side/4}
            local cx, cy = love.mouse.getPosition()
            render.cubicLine({c.x, c.y}, {cx, cy}, {c.x + (cx - c.x)/2, c.y}, {cx - (cx - c.x)/2, cy}, scripting.dataTypes[v.type].color, 1)
        end

        if v.type == "number" or v.type == "string" then
            local namew = fonts.getWidth("regular", 13, languages.text(v.name))*zoom
            local text = (((data.input[k] and data.input[k].value and #data.input[k].value > 0) and data.input[k].value or (data.input[k] and data.input[k].editActive) and ((data.input[k].value or "")))) or v.default
            local _w = math.max(fonts.getWidth("regular", 13, text)*zoom+4*zoom, side*3)
            if text ~= (v.default or "") and tickCount % 1000 > 500 and data.input[k] and data.input[k].editActive then
                text = text .. "|"
            end
            if not data.input[k] or not data.input[k].connection then
                dxDrawRectangle(x+side*2 + namew, y+top/3 + (k-1)*18*zoom, _w, side, {25, 25, 25, 150})

                love.graphics.push()
                love.graphics.scale(zoom, zoom)
                fonts.drawText("regular", 13, text, x/zoom+side*2/zoom+1 + namew/zoom, y/zoom+top/3/zoom + (k-1)*18+.5, _w/zoom+15, side)
                love.graphics.pop()
            end

            if isMouseInPosition(x+side*2 + namew, y+top/3 + (k-1)*18*zoom, _w, side) and love.mouse.isDown(1) then
                for _,c in pairs(blocks.blocks) do
                    for _,l in pairs(c.input) do
                        l.editActive = false
                        love.keyboard.setTextInput(false)
                    end
                end
                if not data.input[k] then
                    data.input[k] = {}
                end
                data.input[k].editActive = v.type
                love.keyboard.setTextInput(true)
            elseif love.mouse.isDown(1) and data.input[k] then
                data.input[k].editActive = false
                love.keyboard.setTextInput(false)
            end
        end

        love.graphics.push()
        love.graphics.scale(zoom, zoom)
        fonts.drawText("regular", 13, languages.text(v.name), x/zoom+side*1.6/zoom, y/zoom+top/3/zoom + (k-1)*18 + 1, {255, 255, 255}, false)
        love.graphics.pop()

        for d,c in pairs(connections) do
            if c.connection_id == id and c.connection_input == k and c.type == "output" then
                render.cubicLine({c.x, c.y}, {cx + side/4, cy + side/4}, {c.x + (cx + side/4 - c.x)/2, c.y}, {cx + side/4 - (cx + side/4 - c.x)/2, cy + side/4}, color, 1)
            end
        end

        if data.input and data.input[k] and data.input[k].connection then
            table.insert(connections, {type="input", x = cx + side/4, y = cy + side/4, connection_id = data.input[k].connection[1], connection_input = data.input[k].connection[2]})
        end
    end

    for k,v in pairs(script.output) do
        local cx, cy = x+w+side/2+side*2, y+top/3 + (k-1)*18*zoom+side/4

        local color = scripting.dataTypes[v.type].color

        local connected = false
        if data.output and data.output[k] and data.output[k].connection then
            for d,c in pairs(data.output[k].connection) do
                if c[1] == id and c[2] == k then
                    connected = true
                end
            end
        end
        local canConnect = (blocks.holdConnection and (blocks.holdConnection.value_type == v.type or v.type == "everything" or blocks.holdConnection.value_type == "everything") and blocks.holdConnection.type == "input" and not connected and blocks.holdConnection.id ~= id)
        color = ((not blocks.holdConnection and color or canConnect) and color or {color[1], color[2], color[3], 50})
        dxDrawImage(cx, cy, side/2, side/2, path .. v.icon .. ".png", color)
        dxDrawImage(x+w+side/2, y+top/3 + (k-1)*18*zoom, side, side, path .. v.icon .. ".png", color)

        if isMouseInPosition(cx - side/4, cy - side/4, side, side) and not blocks.grabBlock and not search.open and not code.open and not saving.open then
            if love.mouse.isDown(1) and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
                blocks.holdConnection = {type="output", id=id, index=k, value_type=v.type}

                --[[if data.output and data.output[k] and data.output[k].connection then
                    local id = data.output[k].connection
                    local ndata = blocks.blocks[ id[1] ]
                    if ndata.input and ndata.input[ id[2] ] and id[3] ~= "condition" then
                        ndata.input[ id[2] ].connection = false
                    elseif ndata.conditions and ndata.conditions[ id[2] ] and id[3] == "condition" then
                        ndata.conditions[ id[2] ].connection = false
                    end
                end
                if data.output[k] then
                    data.output[k].connection = false
                else
                    data.output[k] = {}
                end]]
            elseif blocks.holdConnection and canConnect and not love.mouse.isDown(1) then
                if not blocks.blocks[blocks.holdConnection.id].input then
                    blocks.blocks[blocks.holdConnection.id].input = {}
                end
                if not blocks.blocks[blocks.holdConnection.id].input[blocks.holdConnection.index] then
                    blocks.blocks[blocks.holdConnection.id].input[blocks.holdConnection.index] = {}
                end
                blocks.blocks[blocks.holdConnection.id].input[blocks.holdConnection.index].connection = {id, k}
                
                if not blocks.blocks[id].output then
                    blocks.blocks[id].output = {}
                end
                if not blocks.blocks[id].output[k] then
                    blocks.blocks[id].output[k] = {}
                end
                if not blocks.blocks[id].output[k].connection then
                    blocks.blocks[id].output[k].connection = {}
                end
                table.insert(blocks.blocks[id].output[k].connection, {blocks.holdConnection.id, blocks.holdConnection.index})

                blocks.holdConnection = false

                party.updateBlocks()
            end
        end

        if blocks.holdConnection and blocks.holdConnection.type == "output" and blocks.holdConnection.id == id and blocks.holdConnection.index == k then
            local c = {x=cx + side/4, y=cy + side/4}
            local cx, cy = love.mouse.getPosition()
            render.cubicLine({c.x, c.y}, {cx, cy}, {c.x + (cx - c.x)/2, c.y}, {cx - (cx - c.x)/2, cy}, scripting.dataTypes[v.type].color, 1)
        end

        love.graphics.push()
        love.graphics.scale(zoom, zoom)
        fonts.drawText("regular", 13, languages.text(v.name), x/zoom+side*1.6/zoom, y/zoom+top/3/zoom + (k-1)*18 + 1, w/zoom - side/zoom*1.4, 500, {255, 255, 255}, false, "right")
        love.graphics.pop()

        for d,c in pairs(connections) do
            if c.connection_id == id and c.connection_input == k and c.type == "input" then
                render.cubicLine({c.x, c.y}, {cx + side/4, cy + side/4}, {c.x + (cx + side/4 - c.x)/2, c.y}, {cx + side/4 - (cx + side/4 - c.x)/2, cy + side/4}, color, 1)
            elseif c.id == id and c.index == k and c.type == "condition_input" then
                render.cubicLine({c.x, c.y}, {cx + side/4, cy + side/4}, {c.x + (cx + side/4 - c.x)/2, c.y}, {cx + side/4 - (cx + side/4 - c.x)/2, cy + side/4}, color, 1)
            end
        end

        if data.output and data.output[k] and data.output[k].connection then
            for e,d in pairs(data.output[k].connection) do
                if d[3] == "condition" then
                    table.insert(connections, {type="condition_output", x = cx + side/4, y = cy + side/4, id = d[1], index = d[2]})
                else
                    table.insert(connections, {type="output", x = cx + side/4, y = cy + side/4, connection_id = d[1], connection_input = d[2]})
                end
            end
        end
    end

    if not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.holdingComment then
        local cx, cy = love.mouse.getPosition()
        cx, cy = render.getWorldFromScreenPosition(cx, cy)
        if isMouseInPosition(startx, starty, blockw, blocktop) and not render.holdScene and love.mouse.isDown(1) then
            blocks.grabBlock = {id=id, x=cx-data.x, y=cy-data.y}
        end
    elseif blocks.grabBlock then
        if not love.mouse.isDown(1) then
            blocks.grabBlock = false
        else
            local cx, cy = love.mouse.getPosition()
            cx, cy = render.getWorldFromScreenPosition(cx, cy)
            blocks.blocks[blocks.grabBlock.id].x = cx - blocks.grabBlock.x
            blocks.blocks[blocks.grabBlock.id].y = cy - blocks.grabBlock.y
        end
    end
end

blocks.inputValue = function(key)
    for block,data in pairs(blocks.blocks) do
        if data.editing then
            if #key == 1 then
                data.commentText = data.commentText .. key
                party.updateBlock(block)
            end

            if key == "backspace" then
                data.commentText = data.commentText:sub(1, #data.commentText-1)
                party.updateBlock(block)
            end

            if key == "space" then
                data.commentText = data.commentText .. " "
                party.updateBlock(block)
            end
        end
        for k,v in pairs(data.input) do
            if v.editActive then
                if key == "backspace" then
                    local t = (v.value or "")
                    v.value = t:sub(1, #t-1)
                    party.updateBlock(block)
                end
                
                if v.editActive == "number" then
                    if #key == 1 and tonumber(key) or key == "." or key == "-" then
                        v.value = (v.value or "") .. key
                        party.updateBlock(block)
                    end
                elseif v.editActive == "string" then
                    if #key == 1 then
                        v.value = (v.value or "") .. key
                        party.updateBlock(block)
                    elseif key == "space" then
                        v.value = (v.value or "") .. " "
                        party.updateBlock(block)
                    elseif key == "return" then
                        v.editActive = false
                        love.keyboard.setTextInput(false)
                    end
                end
            end
        end
    end
end

blocks.drawBlocks = function()
    local sx, sy = love.graphics.getDimensions()

    discordrpc.downText = (languages.current == "PL" and (#blocks.blocks .. " bloczków! W party ") or (#blocks.blocks .. " blocks! In party "))

    blocks.changingPickerColor = false
    blocks.holdingComment = false

    if blocks.grabBlock then
        local cx, cy = love.mouse.getPosition()
        if getDistanceBetweenPoints2D(sx/2, sy - 50, cx, cy) < 80 then
            blocks.binAlpha = blocks.binAlpha + (255 - blocks.binAlpha)*0.1

            if not love.mouse.isDown(1) then
                local data = blocks.blocks[blocks.grabBlock.id]
                if data.continue then
                    blocks.blocks[data.continue].continued = false
                end
                if data.continued then
                    blocks.blocks[data.continued].continue = false
                end
                if data.continue_else then
                    blocks.blocks[data.continue_else].continued_else = false
                end
                if data.continued_else then
                    blocks.blocks[data.continued_else].continue_else = false
                end
                if data.input then
                    for k,v in pairs(data.input) do
                        if v.connection and blocks.blocks[v.connection[1]].output[v.connection[2]].connection then
                            for j,m in pairs(blocks.blocks[v.connection[1]].output[v.connection[2]].connection) do
                                if m[1] == blocks.grabBlock.id then
                                    table.remove(blocks.blocks[v.connection[1]].output[v.connection[2]].connection, j)
                                end
                            end
                        end
                    end
                end
                if data.output then
                    for k,v in pairs(data.output) do
                        if v.connection then
                            for d,c in pairs(v.connection) do
                                if blocks.blocks[c[1]] and blocks.blocks[c[1]].input[c[2]] then
                                    blocks.blocks[c[1]].input[c[2]].connection = false
                                end
                            end
                        end
                    end
                end

                blocks.blocks[blocks.grabBlock.id] = nil
                blocks.grabBlock = false

                party.updateBlocks()
            end
        else
            blocks.binAlpha = blocks.binAlpha + (100 - blocks.binAlpha)*0.1
        end

        if blocks.grabBlock and blocks.grabBlock.id then
            party.updateBlock(blocks.grabBlock.id)
            blocks.smoothPosition[blocks.grabBlock.id] = nil
        end
    else
        blocks.binAlpha = blocks.binAlpha - blocks.binAlpha*0.1
    end

    if blocks.addedCondition and not love.mouse.isDown(1) then
        blocks.addedCondition = false
    end

    connections = {}
    for block,data in pairs(blocks.blocks) do
        local script = scripting[data.data]
        if script.comment then
            blocks.drawComment(data, block)
        end
    end
    for block,data in pairs(blocks.blocks) do
        local script = scripting[data.data]
        if not script.comment then
            blocks.drawBlock(data, block)
        end
    end
    if blocks.holdConnection and not love.mouse.isDown(1) then
        blocks.holdConnection = false

        party.updateBlocks()
    end

    dxDrawImage(sx/2-40, sy - 90, 80, 80, "data/themes/" .. themes.current .. "/bin.png", {255, 255, 255, blocks.binAlpha})
end

blocks.updateBlocks = function(dt)
    for k,v in pairs(blocks.smoothPosition) do
        if blocks.blocks[k] then
            blocks.blocks[k].x = (blocks.blocks[k].x or v.x) - ((blocks.blocks[k].x or v.x) - v.x)*(dt*10)
            blocks.blocks[k].y = (blocks.blocks[k].y or v.y) - ((blocks.blocks[k].y or v.y) - v.y)*(dt*10)
        end
    end
end

return blocks
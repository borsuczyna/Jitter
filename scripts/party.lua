local socket = require("socket")
local party = {
    users = 1,
    max = 1,

    lastAlive = os.time(),
    lastReceive = 0,
    lastMouse = 0,
    lastBlocksUpdate = 0,
    mousePositions = {},
    lastMousePositions = {},
    name = "borsuczyna"
}

party.joinParty = function(host, port)
    party.server, err = socket.connect(host, port)
    party.server:setoption('keepalive', true)
    party.server:send("setName," .. party.name)
    party.server:settimeout(0)
end

party.sendAllBlocks = function()
    if not party.server then return end

    party.server:send("takeMyBlocks,"..serpent.dump(blocks.blocks))
end

party.messageReceived = function(message)
    if message[1] == "Kick" then
        print("Kicked from party, reason: " .. message[2])

        party.server = nil
    elseif message[1] == "clients" then
        party.users = tostring(message[2] or 1)
        party.max = tostring(message[4] or 1)
    elseif message[1] == "mouse_position" then
        if tonumber(message[5]) then
            party.mousePositions[tonumber(message[5])] = {tonumber(message[2]), tonumber(message[3]), message[4]}
        end
    elseif message[1] == "send_me_blocks" then
        party.sendAllBlocks()
    end
end

party.render = function()
    for k,v in pairs(party.lastMousePositions) do
        local x, y = render.getScreenFromWorldPosition(v[1], v[2])
        dxDrawImage(x, y, 25, 25, "data/themes/" .. themes.current .. "/cursor.png")
        local w = fonts.getWidth("regular", 16, party.mousePositions[k][3])
        dxDrawRectangle(x + 30, y, w + 6, 23, {25, 25, 25, 155})
        fonts.drawText("regular", 16, party.mousePositions[k][3], x + 33, y + 3, w + 10, 250)
    end
end

party.onBlocksCodeReceived = function(message)
    local header = "START_OF_THE_BLOCKS"
    local footer = "END_OF_THE_BLOCKS"
    local code = message:sub(message:find(header)+#header, #message)
    code = code:sub(1, code:find(footer)-1)
    if code:sub(1, 1) == "," then code = code:sub(2, #code) end
    blocks.blocks = loadstring(code)()
end

party.onBlockCodeReceived = function(message)
    local header = "START_OF_THE_BLOCKS"
    local footer = "END_OF_THE_BLOCKS"
    local code = message:sub(message:find(header)+#header, #message)
    code = code:sub(1, code:find(footer)-1)
    if code:sub(1, 1) == "," then code = code:sub(2, #code) end
    local id = tonumber(code:sub(1, code:find(",")-1))
    code = code:sub(code:find(",")+1, #code)
    
    local x, y = (blocks.blocks[id] and blocks.blocks[id].x or false), (blocks.blocks[id] and blocks.blocks[id].y or false)
    blocks.blocks[id] = loadstring(code)()
    blocks.smoothPosition[id] = {x=blocks.blocks[id].x, y=blocks.blocks[id].y}
    if x and y then
        blocks.blocks[id].x = x
        blocks.blocks[id].y = y
    end
end

party.updateBlocks = function()
    if not party.server then return end

    party.server:send("takeMyBlocks,"..serpent.dump(blocks.blocks))
end

party.updateBlock = function(id)
    if not party.server or not blocks.blocks[id] then return end

    if tickCount - party.lastBlocksUpdate > 50 then
        party.server:send("updateBlock,"..id..","..serpent.dump(blocks.blocks[id]))
        
        party.lastBlocksUpdate = tickCount
    end
end

party.update = function(dt)
    if not party.server then return end

    -- Keep alive
    if os.time() - party.lastAlive > 1 then
        --party.server:send("Alive!")
        party.lastAlive = os.time()
    end

    -- Send mouse position
    if tickCount - party.lastMouse > 50 then
        local cx, cy = love.mouse.getPosition()
        cx, cy = render.getWorldFromScreenPosition(cx, cy)
        party.server:send("sendall,mouse_position,"..math.floor(cx)..","..math.floor(cy))

        party.lastMouse = tickCount
    end
    
    -- Receive message
    if tickCount - party.lastReceive > 50 then
        s, status, message = party.server:receive(50000)
        if message and message:len() > 0 then
            for k in message:gmatch('([^|]+)') do
                local msg = {}
                for e in k:gmatch('([^,]+)') do
                    table.insert(msg, e)
                end
                if msg[1] == "blocks" then
                    party.onBlocksCodeReceived(message)
                elseif msg[1] == "block" then
                    party.onBlockCodeReceived(message)
                end
                party.messageReceived(msg)
            end
        end
        
        party.lastReceive = tickCount
    end

    for k,v in pairs(party.mousePositions) do
        if not party.lastMousePositions[k] then
            party.lastMousePositions[k] = {0, 0}
        end

        party.lastMousePositions[k][1] = party.lastMousePositions[k][1] + (party.mousePositions[k][1] - party.lastMousePositions[k][1])*(dt*10)
        party.lastMousePositions[k][2] = party.lastMousePositions[k][2] + (party.mousePositions[k][2] - party.lastMousePositions[k][2])*(dt*10)
    end
end

--party.joinParty("3.91.157.194", 9999)

return party
local saving = {
    open = false,
}

saving.renderBg = function()
    local path = "data/themes/" .. themes.current .. "/"
    local sx, sy = love.graphics.getDimensions()

    local side, top = getImageSize(path .. "block_top_side.png")
    side, top = math.floor(side*2.5), math.floor(top*2.5)

    dxDrawImage(20, 20, side, side, path .. "block_top_side.png")
    dxDrawImage(sx - 20, 20, -side, side, path .. "block_top_side.png")
    dxDrawImage(20+side, 20, sx-side*2-40, side, path .. "block_top.png")
    dxDrawImage(20, 20+side, side, sy-side*2-150, path .. "block_side.png")
    dxDrawImage(sx - 20, 20+side, -side, sy-side*2-150, path .. "block_side.png")
    dxDrawImage(20, 20+side+sy-side-150, side, -side, path .. "block_top_side.png")
    dxDrawImage(sx-20, 20+side+sy-side-150, -side, -side, path .. "block_top_side.png")
    dxDrawImage(20+side, 20+side+sy-side-150, sx-side*2-40, -side, path .. "block_top.png")
    dxDrawImage(20+side, 20+side, sx-side*2-40, sy-side*2-150, path .. "block_middle.png")
end

saving.renderSaving = function()
    if not saving.open then return end
    
    local sx, sy = love.graphics.getDimensions()

    saving.renderBg()

    dxDrawImage(sx/2 - 115, sy - 120, 230, 50, "data/themes/" .. themes.current .. "/button.png")
    dxDrawImage(sx/2 - 240, sy - 60, 230, 50, "data/themes/" .. themes.current .. "/button.png")
    dxDrawImage(sx/2 + 10, sy - 60, 230, 50, "data/themes/" .. themes.current .. "/button.png")
    fonts.drawText("regular", 17, (#saving.savename > 0 and saving.savename or languages.text("Type name")) .. (tickCount % 1000 > 500 and "|" or ""), sx/2 - 115, sy - 120, 230, 50, false, false, "center", "center")
    fonts.drawText("regular", 17, saving.type == "save" and languages.text("Save") or languages.text("Load"), sx/2 - 240, sy - 60, 230, 52, false, false, "center", "center")
    fonts.drawText("regular", 17, languages.text("Close"), sx/2 + 10, sy - 60, 230, 52, false, false, "center", "center")

    fonts.drawText("regular", 14, languages.text("Name"), 32, 5)
    fonts.drawText("regular", 14, languages.text("Save time"), 252, 5)
    fonts.drawText("regular", 14, languages.text("Blocks"), 442, 5)

    local y = 0
    for k,v in pairs(saving.saves) do
        fonts.drawText("regular", 14, v.name, 32, 32 + y)
        fonts.drawText("regular", 14, v.info.savetime, 252, 32 + y)
        fonts.drawText("regular", 14, v.info.blocks, 442, 32 + y)
        y = y + 15
    end
end

saving.saveGame = function(name)
    love.filesystem.createDirectory("saves")

    if saving.saveExists(name) then
        for k,v in pairs(love.filesystem.getDirectoryItems("saves/" .. name)) do
            love.filesystem.remove("saves/name/" .. v)
        end
    end

    love.filesystem.createDirectory("saves/" .. name)
    local data = {
        savetime = os.date("%c", os.time()),
        blocks = #blocks.blocks,
    }
    love.filesystem.write("saves/" .. name .. "/info.lua", serpent.dump(data))
    love.filesystem.write("saves/" .. name .. "/blocks.lua", serpent.dump(blocks.blocks))
    saving.loadSaves()

    local text = (languages.current == "EN" and "Working on " or "Pracuje nad ") .. name
    if text ~= discordrpc.topText then
        discordrpc.now = os.time(os.date("*t"))
        discordrpc.topText = text
    end
end

saving.loadGame = function(name)
    if saving.saveExists(name) then
        local data = love.filesystem.read("saves/" .. name .. "/blocks.lua")
        data = loadstring(data)
        if pcall(data) then
            blocks.blocks = data()
        end

        local text = (languages.current == "EN" and "Working on " or "Pracuje nad ") .. name
        if text ~= discordrpc.topText then
            discordrpc.now = os.time(os.date("*t"))
            discordrpc.topText = text
        end
        party.updateBlocks()
    end
end

saving.clickUI = function()
    if not saving.open then return end

    local sx, sy = love.graphics.getDimensions()

    if isMouseInPosition(sx/2 - 240, sy - 60, 230, 52) then
        if saving.type == "save" then
            if #saving.savename > 2 then
                saving.saveGame(saving.savename)
            end
        else
            saving.loadGame(saving.savename)
        end
    elseif isMouseInPosition(sx/2 + 10, sy - 60, 230, 52) then
        saving.open = false
    end
end

saving.saveExists = function(name)
    for k,v in pairs(saving.saves) do
        if v.name == name then
            return true
        end
    end
    return false
end

saving.inputKey = function(key)
    if not saving.open then return end
    if #key == 1 then
        saving.savename = saving.savename .. key
    elseif key == "backspace" then
        saving.savename = saving.savename:sub(1, #saving.savename-1)
    elseif key == "space" then
        saving.savename = saving.savename .. " "
    end

    saving.savename = saving.savename:sub(1, 16)
end

saving.loadSaves = function()
    saving.savename = ""
    love.filesystem.createDirectory("saves")

    saving.saves = {}
    for k,v in pairs(love.filesystem.getDirectoryItems("saves")) do
        local info = love.filesystem.read("saves/" .. v .. "/info.lua")
        info = loadstring(info or "")
        local data = pcall(info)
        if data then
            table.insert(saving.saves, {name=v, info=info()})
        end
    end
end

return saving
language = "lua"

require("scripts.functions")
discordrpc = require("scripts.discordrpc")
themes = require("scripts.themes")
fonts = require("scripts.fonts")
languages = require("scripts.languages")
http = require("socket.http")
--protect = require("scripts.protect")
settings = require("scripts.settings")
generator = require("scripting." .. language .. ".generator")
saving = require("scripts.saving")
search = require("scripts.search")
code = require("scripts.code")
scripting = require("scripts.scripting")
blocks = require("scripts.blocks")
render = require("scripts.render")
serpent = require("scripts.serpent")
party = require("scripts.party")
tickCount = 0

--protect.tryProtect()

function love.load()
    discordrpc.init()
end

function love.draw()
    --[[if not protect.tryProtect() then
        local sx, sy = love.graphics.getDimensions()
        dxDrawRectangle(0, 0, sx, sy, {25, 25, 25})
        fonts.drawText("bold", 55, "Access denied!", 0, 0, sx, sy, false, false, "center", "center")
        fonts.drawText("regular", 16, "ask for access here: discord.gg/nSmZHzAxXs\nYour HWID: " .. protect.getHWID(), 0, 35, sx, sy, false, false, "center", "center")
        return
    end]]
    render.drawScene()
    party.render()
end

function love.update(dt)
    --if not protect.tryProtect() then return end
    tickCount = tickCount + dt * 1000
    render.update(dt)
    discordrpc.update()
    party.update(dt)
    blocks.updateBlocks(dt)
end

function love.wheelmoved(x, y)
    --if not protect.tryProtect() then return end
    render.wheelmoved(x, y)
    search.wheelmoved(x, y)
end

function love.keypressed(key)
    --if not protect.tryProtect() then return end
    --[[if key == "space" then
        generator.generateProject()
    end]]

    saving.inputKey(key)
    search.useKey(key)
    blocks.inputValue(key)
end

function love.mousereleased(btn)
    --if not protect.tryProtect() then return end
    render.clickUI(btn)
    saving.clickUI(btn)
end

function love.quit()
    discordrpc.shutdown()
end
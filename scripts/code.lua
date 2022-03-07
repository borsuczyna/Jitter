local code = {
    open = false,
    code = ""
}

code.renderCode = function()
    if not code.open then return end
    
    local sx, sy = love.graphics.getDimensions()

    local _, lines = fonts.getWrap("regular", 13, code.code, sx-50)
    saving.renderBg()

    local y = 0
    for k,v in pairs(lines) do
        if k < 43 then
            fonts.drawText("regular", 13, v, 30, 30 + y, sx, sy)
            y = y + 13
        end
    end

    dxDrawImage(sx/2 - 240, sy - 100, 230, 50, "data/themes/" .. themes.current .. "/button.png")
    dxDrawImage(sx/2 + 10, sy - 100, 230, 50, "data/themes/" .. themes.current .. "/button.png")
    fonts.drawText("regular", 17, languages.text("Copy to clipboard"), sx/2 - 240, sy - 100, 230, 52, false, false, "center", "center")
    fonts.drawText("regular", 17, languages.text("Close"), sx/2 + 10, sy - 100, 230, 52, false, false, "center", "center")

    if isMouseInPosition(sx/2 - 240, sy - 100, 230, 52) and love.mouse.isDown(1) then
        love.system.setClipboardText(code.code)
    elseif isMouseInPosition(sx/2 + 10, sy - 100, 230, 52) and love.mouse.isDown(1) then
        code.open = false
    end
end

code.showCode = function()
    code.open = true
    code.code = generator.generateProject()
end

return code
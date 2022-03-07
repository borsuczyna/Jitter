local render = {
    sx = love.graphics.getWidth(),
    sy = love.graphics.getHeight(),
    x = 0,
    y = 0,
    zoom = 1,
    zoomTarget = 1,
}

render.update = function(dt)
    render.dt = dt
    render.sx = love.graphics.getWidth()
    render.sy = love.graphics.getHeight()
    render.zoom = render.zoom + (render.zoomTarget - render.zoom)*dt*10
end

render.wheelmoved = function(x, y)
    if search.open then return end
    render.zoomTarget = math.max(math.min(render.zoomTarget + y/5, 3), 0.2)
end

render.getScreenFromWorldPosition = function(x, y)
    return render.sx/2 + x*render.zoom + render.x*render.zoom, render.sy/2 + y*render.zoom + render.y*render.zoom
end

render.getWorldFromScreenPosition = function(x, y)
    return (x - render.sx/2)/render.zoom - render.x, (y - render.sy/2)/render.zoom - render.y
end

render.drawBackground = function()
    local sx, sy = render.sx, render.sy
    dxDrawImageSection(sx/2, sy/2, sx/2, -sy/2, -render.x*0.8+1, render.y*0.8+1, sx/2/render.zoom, sy/2/render.zoom, "data/themes/" .. themes.current .. "/bg.png")
    dxDrawImageSection(sx/2, sy/2, -sx/2, -sy/2, render.x*0.8+1, render.y*0.8+1, sx/2/render.zoom, sy/2/render.zoom, "data/themes/" .. themes.current .. "/bg.png")
    dxDrawImageSection(sx/2, sy/2, -sx/2, sy/2, render.x*0.8+1, -render.y*0.8+1, sx/2/render.zoom, sy/2/render.zoom, "data/themes/" .. themes.current .. "/bg.png")
    dxDrawImageSection(sx/2, sy/2, sx/2, sy/2, -render.x*0.8+1, -render.y*0.8+1, sx/2/render.zoom, sy/2/render.zoom, "data/themes/" .. themes.current .. "/bg.png")
end

render.quadLine = function(from, to, approx, color)
    setColor(color)
	local prevx, prevy
    local sx, sy = love.graphics.getDimensions()
    if from.x >= 0 and from.y >= 0 and from.x <= sx and from.y <= sy and to.x >= 0 and to.y >= 0 and to.x <= sx and to.y <= sy then
        for t = 0, 1, 0.01 do
            local x = (1-t)^2*from[1] + 2*(1-t)*t*approx[1] + t^2*to[1]
            local y = (1-t)^2*from[2] + 2*(1-t)*t*approx[2] + t^2*to[2] 
            if prevx then
                love.graphics.line(prevx,prevy,x,y)
            end
            prevx, prevy = x, y
        end
    end
end

render.cubicLine = function(from, to, approx, approx2, color, size)
	local prevx, prevy
    setColor(color)
	for t = 0, 1, 0.02 do
		local x = (1-t)^3*from[1] + 3*(1-t)^2*t*approx[1] + 3*(1-t)*t^2*approx2[1] + t^3*to[1] 
		local y = (1-t)^3*from[2] + 3*(1-t)^2*t*approx[2] + 3*(1-t)*t^2*approx2[2] + t^3*to[2]
		if prevx then
			love.graphics.line(prevx,prevy,x,y)
		end
		prevx, prevy = x, y
	end
end

render.grabScene = function()
    if render.holdScene then
        if love.mouse.isDown(1) then
            local cx, cy = love.mouse.getPosition()
            render.x = render.x + (cx - render.holdScene[1])/render.zoom
            render.y = render.y + (cy - render.holdScene[2])/render.zoom
            render.holdScene = {cx, cy}
        else
            render.holdScene = false
        end
    else
        if love.mouse.isDown(1) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open and not saving.open and not blocks.changingPickerColor then
            local cx, cy = love.mouse.getPosition()
            render.holdScene = {cx, cy}
        end
    end

    local touches = love.touch.getTouches()
    if #touches == 2 then
        local lx, ly = love.touch.getPosition(touches[1])
        local rx, ry = love.touch.getPosition(touches[2])

        if lx < rx then
            local _lx = lx
            lx = rx
            rx = _lx
        end

        if render.mobileGrab then
            local ldiff = lx - render.mobileGrab[1]
            local rdiff = render.mobileGrab[2] - rx
            render.zoomTarget = math.max(math.min(render.zoomTarget + (ldiff + rdiff)/100, 3), 0.2)
        end

        render.mobileGrab = {lx, rx}
    else
        render.mobileGrab = false
    end
end

render.drawUI = function()
    local sx, sy = love.graphics.getDimensions()
    dxDrawImage(20, sy - 80, 60, 60, "data/themes/" .. themes.current .. "/add.png")
    dxDrawImage(80, sy - 80, 60, 60, "data/themes/" .. themes.current .. "/new.png")
    dxDrawImage(140, sy - 80, 60, 60, "data/themes/" .. themes.current .. "/save.png")
    dxDrawImage(200, sy - 80, 60, 60, "data/themes/" .. themes.current .. "/load.png")
    dxDrawImage(260, sy - 80, 60, 60, "data/themes/" .. themes.current .. "/code.png")
    dxDrawImage(320, sy - 80, 60, 60, "data/themes/" .. themes.current .. "/settings.png")
end

render.clickUI = function(btn)
    local sx, sy = love.graphics.getDimensions()

    if isMouseInPosition(20, sy - 80, 60, 60) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open and not saving.open then
        search.open = true
        search.x = sx/2 - 100
        search.y = sy/2 - 100
        search.text = ""
    elseif isMouseInPosition(80, sy - 80, 60, 60) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open then
        if (lastnew or 0) > tickCount - 500 then
            blocks.blocks = {}
        end
        lastnew = tickCount
    elseif isMouseInPosition(140, sy - 80, 60, 60) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open then
        saving.loadSaves()
        saving.open = true
        saving.type = "save"
    elseif isMouseInPosition(200, sy - 80, 60, 60) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open then
        saving.loadSaves()
        saving.open = true
        saving.type = "load"
    elseif isMouseInPosition(260, sy - 80, 60, 60) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open and not saving.open then
        code.showCode()
    elseif isMouseInPosition(320, sy - 80, 60, 60) and not blocks.grabBlock and not blocks.holdConnection and not search.open and not code.open and not saving.open then
        settings.showSettings()
    end
end

local runs = http.request("http://jitter.mtasa.eu/runs.php")

render.drawScene = function()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    render.drawBackground()

    local sx, sy = love.graphics.getDimensions()

    if not render.selectedLanguage then
        fonts.drawText("bold", 30, "Select language", 0, -sy/2+200, sx, sy, white, false, "center", "center")

        dxDrawImage(sx/2 - 350, 50, 200, 120, "data/en.png", {255, 255, 255, isMouseInPosition(sx/2 - 350, 50, 200, 120) and 200 or 100})
        dxDrawImage(sx/2 + 150, 50, 200, 120, "data/pl.png", {255, 255, 255, isMouseInPosition(sx/2 + 150, 50, 200, 120) and 200 or 100})
        fonts.drawText("bold", 18, "American English", sx/2 - 350, 130, 200, 120, white, false, "center", "center")
        fonts.drawText("bold", 16, "Polish (Temp not working)", sx/2 + 150, 130, 200, 120, white, false, "center", "center")

        fonts.drawText("bold", 40, "BETA TESTY 0.45", 10, sy/2, sx, sy)
        fonts.drawText("regular", 25, "Ostatnie aktualizacje", 10, sy/2+35, sx, sy)
        fonts.drawText("regular", 15, "• Błędy logiczne generatora\n\n\n\n\n• Tworzenie GUI w następnej aktualizacji", 10, sy/2+70, sx, sy)

        if isMouseInPosition(sx/2 - 350, 50, 200, 120) and love.mouse.isDown(1) then
            render.selectedLanguage = true
            languages.current = "EN"
            discordrpc.topText = "Working on Untitled Project"
        elseif isMouseInPosition(sx/2 + 150, 50, 200, 120) and love.mouse.isDown(1) then
            render.selectedLanguage = true
            languages.current = "PL"
            discordrpc.topText = "Pracuje nad Bez Nazwy"
        end
        return
    end

    love.graphics.setDefaultFilter(themes.getFilterMode(), themes.getFilterMode(), 1)
    blocks.drawBlocks()
    search.drawSearch()
    render.grabScene()
    render.drawUI()
    saving.renderSaving()
    code.renderCode()

    dxDrawImage(sx - 120, sy - 45, 110, 40, "data/logo.png")

    --fonts.richText("regular", 15, "{ff0000}te{00ff00}st", 50, 50)

    local text = "x: " .. math.floor(render.x) .. "\ny: " .. math.floor(render.y) .. "\nfps: " .. love.timer.getFPS() .. "\ntheme: " .. themes.current .. "\nzoom: " .. ("%.2f"):format(render.zoom) .. "\nsession: " .. math.floor(tickCount/1000) .. "s"
    --fonts.drawText("regular", 13, "Total program runs: " .. tonumber(runs or 0), 0, render.sy - 35, render.sx, 50, white, false, "center", "center")
    --fonts.drawText("regular", 15, text, render.sx - fonts.getWidth("regular", 15, text) - 5, render.sy - fonts.getHeight("regular", 15)*6, render.sx, render.sy)
end

return render
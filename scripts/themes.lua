local themes = {
    current = "dark",
    cache = {},
}

themes.getFilterMode = function(id)
    if not id then id = themes.current end
    if themes.cache[id] then
        return themes.cache[id]
    else
        local image = getImageFromCache("data/themes/" .. id .. "/filter_mode.png")
        local r = image.imageData:getPixel(1, 1)
        themes.cache[id] = (r > 0.9 and "nearest" or "linear")
        return themes.cache[id]
    end
end

themes.setTheme = function(id)
    themes.current = id
end

return themes
local generator = {}

generator.findByID = function(id)
    return blocks.blocks[id]
end

generator.addCode = function(code)
    if #code < 1 then return end
    generator.cache.code = generator.cache.code .. code .. "\n"
end

generator.colorTableToRGBA = function(color)
    local r, g, b, a = 255,255,255,255
    if color then
        r, g, b, a = unpack(loadstring("return " .. color)())
    end
    return r, g, b, a
end

generator.getBlockArguments = function(data)
    local args = {}
    local script = scripting[data.data]

    if script.condition then
        local ac = {}
        for k,v in pairs(data.conditions or {}) do
            if v.connection then
                local ndata = blocks.blocks[v.connection[1]]
                local nscript = scripting[ndata.data]
                local args = generator.getBlockArguments(ndata)
                local code = nscript.generator.header(unpack(args))
                ac[k] = code
            end
        end
        args[1] = table.concat(ac, " and ")
    elseif script.color then
        local color = blocks.getBlockColorPicker(data.color_picker and data.color_picker[1] or 0, data.color_picker and data.color_picker[2] or 0)
        args[1] = color[1]
        args[2] = color[2]
        args[3] = color[3]
        args[4] = color[4]
    else
        for k,v in pairs(script.input) do
            if data.input[k] and data.input[k].connection and data.input[k].connection[1] then
                args[k] = (generator.getArgument(data.input[k].connection[1], data.input[k].connection[2]))
            elseif data.input[k] and data.input[k].value then
                args[k] = (tonumber(data.input[k].value) and data.input[k].value or '"' .. data.input[k].value .. '"')
            elseif script.input[k].default then
                args[k] = (tonumber(script.input[k].default) and script.input[k].default or '"' .. script.input[k].default .. '"')
            end
        end
    end

    return args
end

generator.getArgument = function(id, index)
    if generator.cache.variables[id] and generator.cache.variables[id][index] then
        return generator.cache.variables[id][index]
    end

    local data = generator.findByID(id)
    local args = generator.getBlockArguments(data)
    generator.generateBlock(data, args, id)
    return generator.getArgument(id, index)
end

generator.gonnaBeUsed = function(id, index)
    for k,v in pairs(blocks.blocks) do
        if v.input then
            for d,c in pairs(v.input) do
                if c.connection and c.connection[1] == id and c.connection[2] == index then return true end
            end
        end
    end
    return false
end

generator.getScope = function(id)
    for k,v in pairs(blocks.blocks) do
        if scripting[v.data].event and v.continue then
            local data = generator.findByID(v.continue)
            if id == v.continue then
                return k
            end
            while data.continue do
                if id == data.continue then
                    return k
                end
                data = generator.findByID(data.continue)
            end
        end
    end
end

generator.generateBlock = function(data, args, _id)
    local script = scripting[data.data]
    local code = script.generator.header(unpack(args))
    local precode = ""

    if #script.output > 1 or data.continue then
        if generator.specialVariable then
            generator.addCode(generator.specialVariable .. " = " .. code)
            if not generator.cache.variables[_id] then
                generator.cache.variables[_id] = {}
            end
            generator.cache.variables[_id][1] = generator.specialVariable

            generator.specialVariable = false
        else
            for k,v in pairs(script.output) do
                if generator.cache.variables[_id] and generator.cache.variables[_id][k] then
                    precode = precode .. (#precode > 1 and ", " or "") .. generator.cache.variables[_id][k]
                else
                    precode = precode .. (#precode > 1 and ", var" or "var") .. generator.cache.variable

                    if not generator.cache.variables[_id] then
                        generator.cache.variables[_id] = {}
                    end
                    generator.cache.variables[_id][k] = "var" .. generator.cache.variable

                    if script.event then
                        if code:find("{var" .. k .. "}") then
                            code = code:gsub("{var" .. k .. "}", "var" .. generator.cache.variable)
                        else
                            break
                        end
                    end

                    generator.cache.variable = generator.cache.variable + 1
                end
            end
            if script.event then
                generator.addCode(code)
            else
                local currentScope = generator.getScope(_id)
                    
                if (generator.cache.generatingScope == currentScope or not script.input_able) and not script.specialVariable then
                    generator.addCode(precode .. (#precode > 1 and " = " or "") .. code)
                end
            end
        end
    elseif #script.output == 1 and not data.continued then
        if not generator.cache.variables[_id] then
            generator.cache.variables[_id] = {}
        end
        generator.cache.variables[_id][1] = code
        if not generator.gonnaBeUsed(_id, 1) then
            generator.addCode(code)
        end
    else
        if not generator.gonnaBeUsed(_id, 1) and not generator.specialVariable then
            generator.addCode(code)
        else
            if generator.specialVariable then
                generator.addCode(generator.specialVariable .. " = " .. code)
                if not generator.cache.variables[_id] then
                    generator.cache.variables[_id] = {}
                end
                generator.cache.variables[_id][1] = generator.specialVariable

                generator.specialVariable = false
            else
                if generator.cache.variables[_id] and generator.cache.variables[_id][1] then
                    generator.addCode(generator.cache.variables[_id][1] .. " = " .. code)
                else
                    local currentScope = generator.getScope(_id)
                    
                    if generator.cache.generatingScope == currentScope or not script.input_able then
                        generator.addCode("var" .. generator.cache.variable .. " = " .. code)
                    end
                    
                    if not generator.cache.variables[_id] then
                        generator.cache.variables[_id] = {}
                    end
                    generator.cache.variables[_id][1] = "var" .. generator.cache.variable
    
                    generator.cache.variable = generator.cache.variable + 1
                end
            end
        end
    end
end

generator.generateObject = function(data, _id)
    local args = generator.getBlockArguments(data)
    local script = scripting[data.data]

    generator.generateBlock(data, args, _id)

    if script.specialVariable then
        local args = generator.getBlockArguments(data)
        local pre = args[1]
        if pre:sub(1, 1) == "\"" then
            pre = pre:sub(2, #pre-1)
        end
        generator.addCode("if not " .. pre .. " then " .. pre .. " = {} end")
        generator.specialVariable = pre .. "[" .. args[2] .. "]"
    end

    if data.continue then
        local ndata = generator.findByID(data.continue)
        generator.generateObject(ndata, data.continue)
    end

    if script.else_out and data.continue_else then
        generator.addCode("else")

        local ndata = generator.findByID(data.continue_else)
        generator.generateObject(ndata, data.continue_else)
    end

    if script.generator.footer then
        generator.addCode(script.generator.footer(args))
    end
end

generator.generateProject = function()
    -- just clear the cache
    generator.cache = {code = languages.text("precode"), variable = 1, variables = {}, generatingScope = 1}

    for k,v in pairs(blocks.blocks) do
        local data = scripting[v.data]
        generator.cache.generatingScope = k
        if data and data.event then
            generator.generateObject(v, k)
        end
    end

    return generator.cache.code
end

return generator
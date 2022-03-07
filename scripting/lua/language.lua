-- getOriginalHandling, getVehicleCompatibleUpgrades, getVehicleComponents, getVehicleHandling

return {
    ["vector3"] = {
        name = "Vector3",
        input_able = false,
        shared = true,
        input = {
            {name = "X", icon = "ball", type = "number", default = "0"},
            {name = "Y", icon = "ball", type = "number", default = "0"},
            {name = "Z", icon = "ball", type = "number", default = "0"},
        },
        output = {
            {name = "Vector3", icon = "ball", type = "vector3"},
        },

        generator = {
            header = function(x, y, z)
                return ("Vector3(%s, %s, %s)"):format(x, y, z)
            end,
        }
    },
    ["createVehicle"] = {
        name = "Create Vehicle",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Model", icon = "ball", type = "number", default = "400"},
            {name = "Vector3", icon = "ball", type = "vector3"},
        },
        output = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },

        generator = {
            header = function(model, position)
                return ("createVehicle(%s, %s)"):format(model, position)
            end,
        }
    },
    ["attachTrailerToVehicle"] = {
        name = "Attach Trailer To Vehicle",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Trailer", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Success", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle, trailer)
                return ("attachTrailerToVehicle(%s, %s)"):format(vehicle, trailer)
            end,
        }
    },
    ["detachTrailerFromVehicle"] = {
        name = "Detach Trailer From Vehicle",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Trailer (optional)", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Success", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle, trailer)
                return ("detachTrailerFromVehicle(%s, %s)"):format(vehicle, trailer)
            end,
        }
    },
    ["blowVehicle"] = {
        name = "Blow Vehicle",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Explode", icon = "ball", type = "boolean"},
        },
        output = {
            {name = "Success", icon = "ball", type = "boolean",
            },
        },

        generator = {
            header = function(vehicle, explode)
                return ("blowVehicle(%s, %s)"):format(vehicle, explode)
            end,
        }
    },
    ["fixVehicle"] = {
        name = "Fix Vehicle",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Success", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle)
                return ("fixVehicle(%s)"):format(vehicle)
            end,
        }
    },
    ["getHeliBladeCollisionsEnabled"] = {
        name = "Is Heli Blade Collision Enabled",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Enabled", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle)
                return ("getHeliBladeCollisionsEnabled(%s)"):format(vehicle)
            end,
        }
    },
    ["getHelicopterRotorSpeed"] = {
        name = "Get Helicopter Rotor Speed",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Value", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getHelicopterRotorSpeed(%s)"):format(vehicle)
            end,
        }
    },
    ["getTrainDirection"] = {
        name = "Get Train Direction",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Direction", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle)
                return ("getTrainDirection(%s)"):format(vehicle)
            end,
        }
    },
    ["getTrainPosition"] = {
        name = "Get Train Position",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Position", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getTrainPosition(%s)"):format(vehicle)
            end,
        }
    },
    ["getTrainSpeed"] = {
        name = "Get Train Speed",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Speed", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getTrainSpeed(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleAdjustableProperty"] = {
        name = "Get Vehicle Adjustable Property",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Value", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleAdjustableProperty(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleComponentPosition"] = {
        name = "Get Vehicle Component Position",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Component", icon = "ball", type = "string", default="chassis"},
            {name = "Base", icon = "ball", type = "string", default="parent"},
        },
        output = {
            {name = "X", icon = "ball", type = "number"},
            {name = "Y", icon = "ball", type = "number"},
            {name = "Z", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle, component, base)
                return ("getVehicleComponentPosition(%s, %s, %s)"):format(vehicle, component, base)
            end,
        }
    },
    ["getVehicleComponentRotation"] = {
        name = "Get Vehicle Component Rotation",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Component", icon = "ball", type = "string", default="chassis"},
            {name = "Base", icon = "ball", type = "string", default="parent"},
        },
        output = {
            {name = "RX", icon = "ball", type = "number"},
            {name = "RY", icon = "ball", type = "number"},
            {name = "RZ", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle, component, base)
                return ("getVehicleComponentRotation(%s, %s, %s)"):format(vehicle, component, base)
            end,
        }
    },
    ["getVehicleComponentScale"] = {
        name = "Get Vehicle Component Scale",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Component", icon = "ball", type = "string", default="chassis"},
            {name = "Base", icon = "ball", type = "string", default="parent"},
        },
        output = {
            {name = "SX", icon = "ball", type = "number"},
            {name = "SY", icon = "ball", type = "number"},
            {name = "SZ", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle, component, base)
                return ("getVehicleComponentScale(%s, %s, %s)"):format(vehicle, component, base)
            end,
        }
    },
    ["getVehicleComponentVisible"] = {
        name = "Is Vehicle Component Visible",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Component", icon = "ball", type = "string", default="chassis"},
        },
        output = {
            {name = "Visible", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle, component)
                return ("getVehicleComponentVisible(%s, %s)"):format(vehicle, component)
            end,
        }
    },
    ["getVehicleController"] = {
        name = "Get Vehicle Controller",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Player", icon = "ball", type = "player"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleController(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleCurrentGear"] = {
        name = "Get Vehicle Current Gear",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Gear", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleCurrentGear(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleDoorOpenRatio"] = {
        name = "Get Vehicle Door Open Ratio",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Door", icon = "ball", type = "number", default="0"},
        },
        output = {
            {name = "Open ratio", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle, door)
                return ("getVehicleDoorOpenRatio(%s, %s)"):format(vehicle, door)
            end,
        }
    },
    ["getVehicleDoorState"] = {
        name = "Get Vehicle Door State",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Door", icon = "ball", type = "number", default="0"},
        },
        output = {
            {name = "State", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle, door)
                return ("getVehicleDoorState(%s, %s)"):format(vehicle, door)
            end,
        }
    },
    ["getVehicleDummyPosition"] = {
        name = "Get Vehicle Dummy Position",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Dummy", icon = "ball", type = "string", default="engine"},
        },
        output = {
            {name = "X", icon = "ball", type = "number"},
            {name = "Y", icon = "ball", type = "number"},
            {name = "Z", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle, dummy)
                return ("getVehicleDummyPosition(%s, %s)"):format(vehicle, dummy)
            end,
        }
    },
    ["getVehicleEngineState"] = {
        name = "Get Vehicle Engine State",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "State", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleEngineState(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleGravity"] = {
        name = "Get Vehicle Gravity",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "X", icon = "ball", type = "number"},
            {name = "Y", icon = "ball", type = "number"},
            {name = "Z", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleDummyPosition(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleHeadLightColor"] = {
        name = "Get Vehicle Headlights Color",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "R", icon = "ball", type = "number"},
            {name = "G", icon = "ball", type = "number"},
            {name = "B", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleHeadLightColor(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleLandingGearDown"] = {
        name = "Is Vehicle Landing Gear Down",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Is Down", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleLandingGearDown(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleColorInt"] = {
        name = "Get Vehicle Color (int)",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Color 1", icon = "ball", type = "number"},
            {name = "Color 2", icon = "ball", type = "number"},
            {name = "Color 3", icon = "ball", type = "number"},
            {name = "Color 4", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleColor(%s, false)"):format(vehicle)
            end,
        }
    },
    ["getVehicleColorRGB"] = {
        name = "Get Vehicle Color (RGB)",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Color 1 R", icon = "ball", type = "number"},
            {name = "Color 1 G", icon = "ball", type = "number"},
            {name = "Color 1 B", icon = "ball", type = "number"},
            {name = "Color 2 R", icon = "ball", type = "number"},
            {name = "Color 2 G", icon = "ball", type = "number"},
            {name = "Color 2 B", icon = "ball", type = "number"},
            {name = "Color 3 R", icon = "ball", type = "number"},
            {name = "Color 3 G", icon = "ball", type = "number"},
            {name = "Color 3 B", icon = "ball", type = "number"},
            {name = "Color 4 R", icon = "ball", type = "number"},
            {name = "Color 4 G", icon = "ball", type = "number"},
            {name = "Color 4 B", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleColor(%s, true)"):format(vehicle)
            end,
        }
    },
    ["getVehicleMaxPassengers"] = {
        name = "Get Vehicle Max Passengers",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Max passengers", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleMaxPassengers(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleModelMaxPassengers"] = {
        name = "Get Vehicle Model Max Passengers",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "number", default="400"},
        },
        output = {
            {name = "Max passengers", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle)
                return ("getVehicleMaxPassengers(%s)"):format(vehicle)
            end,
        }
    },
    ["areVehicleLightsOn"] = {
        name = "Are Vehicle Lights On",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
        },
        output = {
            {name = "Enabled", icon = "ball", type = "boolean"},
        },

        generator = {
            header = function(vehicle)
                return ("areVehicleLightsOn(%s)"):format(vehicle)
            end,
        }
    },
    ["getVehicleLightState"] = {
        name = "Get Vehicle Light State",
        input_able = false,
        continue = false,
        client = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Light", icon = "ball", type = "number", default="0"},
        },
        output = {
            {name = "State", icon = "ball", type = "number"},
        },

        generator = {
            header = function(vehicle, light)
                return ("getVehicleLightState(%s, %s)"):format(vehicle, light)
            end,
        }
    },
    ["cloner"] = {
        name = "Cloner",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Input", icon = "ball", type = "everything"},
        },
        output = {
            {name = "Output", icon = "ball", type = "everything"},
        },

        generator = {
            header = function(input)
                return ("%s"):format(input)
            end,
        }
    },
    ["specialVariable"] = {
        name = "Special variable",
        input_able = true,
        continue = true,
        shared = true,
        specialVariable = true,
        input = {
            {name = "Name", icon = "ball", type = "string", default = "none"},
            {name = "Index", icon = "ball", type = "everything"},
        },
        output = {
            {name = "Variable", icon = "ball", type = "everything"},
        },

        generator = {
            header = function(name, key)
                return (name:gsub("\"", "")) .. "[" .. key .. "]"
            end,
        }
    },
    ["sendMessage"] = {
        name = "Send Message (server)",
        input_able = true,
        continue = true,
        server = true,
        input = {
            {name = "Message", icon = "ball", type = "string", default = "Hello world!"},
            {name = "Player", icon = "ball", type = "player"},
            {name = "Color", icon = "ball", type = "color"},
        },
        output = {},

        generator = {
            header = function(message, player, color)
                local r, g, b, a = generator.colorTableToRGBA(color)
                return ("outputChatBox(%s, %s, %s, %s, %s, true)"):format(message, player, r, g, b)
            end,
        }
    },
    ["sendMessageC"] = {
        name = "Send Message (client)",
        input_able = true,
        continue = true,
        client = true,
        input = {
            {name = "Message", icon = "ball", type = "string", default = "Hello world!"},
            {name = "Color", icon = "ball", type = "color"},
        },
        output = {},

        generator = {
            header = function(message, color)
                local r, g, b, a = generator.colorTableToRGBA(color)
                return ("outputChatBox(%s, %s, %s, %s, true)"):format(message, r, g, b)
            end,
        }
    },
    ["addVehicleUpgrade"] = {
        name = "Add Vehicle Upgrade",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Upgrade", icon = "ball", type = "number", default = "1000"},
        },
        output = {},

        generator = {
            header = function(vehicle, upgrade)
                return ("addVehicleUpgrade(%s, %s)"):format(vehicle, upgrade)
            end,
        }
    },
    ["if"] = {
        name = "If",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Condition", icon = "ball", type = "condition"},
        },
        output = {},

        generator = {
            header = function(condition)
                return ("if %s then"):format(condition)
            end,
            footer = function()
                return "end"
            end,
        }
    },
    ["ifelse"] = {
        name = "If Else",
        input_able = true,
        continue = true,
        else_out = true,
        shared = true,
        input = {
            {name = "Condition", icon = "ball", type = "condition"},
        },
        output = {},

        generator = {
            header = function(condition)
                return ("if %s then"):format(condition)
            end,
            footer = function()
                return "end"
            end,
            half = function()
                return "else"
            end,
        }
    },
    ["condition"] = {
        name = "Condition",
        input_able = false,
        continue = false,
        condition = true,
        shared = true,
        input = {},
        output = {
            {name = "Condition", icon = "ball", type = "condition",}
        },

        generator = {
            header = function(value)
                return value
            end,
        }
    },
    ["getPlayerPosition"] = {
        name = "Get Player Position",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Player", icon = "ball", type = "player"},
        },
        output = {
            {name = "X", icon = "ball", type = "number"},
            {name = "Y", icon = "ball", type = "number"},
            {name = "Z", icon = "ball", type = "number"},
        },

        generator = {
            header = function(player)
                return ("getElementPosition(%s)"):format(player)
            end,
        }
    },
    ["getPlayerPositionVector3"] = {
        name = "Get Player Position (Vector3)",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "Player", icon = "ball", type = "player"},
        },
        output = {
            {name = "Vector3", icon = "ball", type = "vector3"},
        },

        generator = {
            header = function(player)
                return ("Vector3(getElementPosition(%s))"):format(player)
            end,
        }
    },
    ["comment"] = {
        name = "Comment",
        input_able = false,
        continue = false,
        input = {},
        shared = true,
        output = {},
        comment = true,

        generator = {
            header = function()
                return ""
            end,
        }
    },
    ["getLocalPlayer"] = {
        name = "Get Local Player",
        input_able = false,
        continue = false,
        client = true,
        input = {},
        output = {
            {name = "Player", icon = "ball", type = "player"},
        },

        generator = {
            header = function()
                return "localPlayer"
            end,
        }
    },
    ["clientResourceStart"] = {
        name = "Client Resource Start",
        event = true,
        input_able = false,
        continue = true,
        client = true,
        input = {},
        output = {},

        generator = {
            header = function()
                return "addEventHandler(\"onClientResourceStart\", resourceRoot, function()"
            end,
            footer = function()
                return "end)"
            end
        }
    },
    ["resourceStart"] = {
        name = "Resource Start",
        event = true,
        input_able = false,
        continue = true,
        server = true,
        input = {},
        output = {},

        generator = {
            header = function()
                return "addEventHandler(\"onResourceStart\", resourceRoot, function()"
            end,
            footer = function()
                return "end)"
            end
        }
    },
    ["commandUsed"] = {
        name = "Command Used (client)",
        event = true,
        input_able = false,
        client = true,
        continue = true,
        input = {
            {name = "Command", icon = "ball", type = "string", default = "none",
            },
        },
        output = {},

        generator = {
            header = function(command)
                return ("addCommandHandler(%s, function()"):format(command)
            end,
            footer = function()
                return "end)"
            end
        }
    },
    ["render"] = {
        name = "On Render",
        event = true,
        input_able = false,
        continue = true,
        client = true,
        input = {},
        output = {},

        generator = {
            header = function()
                return "addEventHandler(\"onClientRender\", root, function()"
            end,
            footer = function()
                return "end)"
            end
        }
    },
    ["console"] = {
        name = "On Console",
        event = true,
        input_able = false,
        continue = true,
        client = true,
        input = {},
        output = {
            {name = "Text", icon = "ball", type = "string", default = "0",
            },
        },

        generator = {
            header = function()
                return "addEventHandler(\"onClientConsole\", root, function({var1})"
            end,
            footer = function()
                return "end)"
            end
        }
    },
    ["playerMarkerHit"] = {
        name = "On Player Marker Hit",
        event = true,
        input_able = false,
        continue = true,
        server = true,
        input = {},
        output = {
            {name = "Player", icon = "ball", type = "player", default = "0"},
            {name = "Marker", icon = "ball", type = "marker", default = "0"},
        },

        generator = {
            header = function()
                return "addEventHandler(\"onPlayerMarkerHit\", root, function({var2})\n{var1} = source"
            end,
            footer = function()
                return "end)"
            end
        }
    },
    ["createMarker"] = {
        name = "Create Marker",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Vector3", icon = "ball", type = "vector3"},
            {name = "Type", icon = "ball", type = "string", default = "cylinder"},
            {name = "Size", icon = "ball", type = "number", default = "1.0"},
            {name = "Color", icon = "ball", type = "color"},
            {name = "Visible to", icon = "ball", type = "player"},
        },
        output = {
            {name = "Marker", icon = "ball", type = "marker"},
        },

        generator = {
            header = function(position, _type, size, color, visibleto)
                local r, g, b, a = generator.colorTableToRGBA(color)
                return ("createMarker(%s,%s,%s,%s,%s,%s,%s,%s)"):format(position,_type,size,r,g,b,a,visibleto)
            end,
        }
    },
    ["createObject"] = {
        name = "Create Object",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Model", icon = "ball", type = "number", default = "2000"},
            {name = "Vector3", icon = "ball", type = "vector3"},
            {name = "Rotation", icon = "ball", type = "vector3"},
        },
        output = {
            {name = "Object", icon = "ball", type = "object"},
        },

        generator = {
            header = function(model, position, rotation)
                return ("createObject(%s, %s, %s)"):format(model,position,rotation)
            end,
        }
    },
    ["createBlip"] = {
        name = "Create Blip",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Vector3", icon = "ball", type = "vector3"},
            {name = "Icon", icon = "ball", type = "number", default = "41"},
            {name = "Size", icon = "ball", type = "number", default = "2.0"},
            {name = "Color", icon = "ball", type = "color"},
            {name = "Visible distance", icon = "ball", type = "number", default = "250"},
            {name = "Visible to", icon = "ball", type = "player"},
        },
        output = {
            {name = "Blip", icon = "ball", type = "blip"},
        },

        generator = {
            header = function(position, icon, size, color, visibleto)
                local r, g, b, a = generator.colorTableToRGBA(color)
                return ("createBlip(%s,%s,%s,%s,%s,%s,%s)"):format(position, icon, size, r, g, b, a, 0, visibledistance, visibleto)
            end,
        }
    },
    ["warpPedIntoVehicle"] = {
        name = "Warp player into vehicle",
        input_able = true,
        continue = true,
        shared = true,
        input = {
            {name = "Player", icon = "ball", type = "player"},
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Seat", icon = "ball", type = "number", default = "0"},
        },
        output = {},

        generator = {
            header = function(player, vehicle, seat)
                return ("warpPedIntoVehicle(%s,%s,%s)"):format(player, vehicle, seat)
            end,
        }
    },
    ["add"] = {
        name = "Add",
        input_able = false,
        shared = true,
        input = {
            {name = "A", icon = "ball", type = "everything", default = "0"},
            {name = "B", icon = "ball", type = "everything", default = "0"},
        },
        output = {
            {name = "Result", icon = "ball", type = "everything"},
        },

        generator = {
            header = function(a, b)
                return ("%s + %s"):format(a, b)
            end,
        }
    },
    ["destroyElement"] = {
        name = "Destroy Element",
        input_able = true,
        shared = true,
        continue = true,
        input = {
            {name = "Element", icon = "ball", type = "everything"},
        },
        output = {},

        generator = {
            header = function(element)
                return ("destroyElement(%s)"):format(element)
            end,
        }
    },
    ["setVehicleColor"] = {
        name = "Set Vehicle Color",
        input_able = true,
        shared = true,
        continue = true,
        input = {
            {name = "Vehicle", icon = "ball", type = "vehicle"},
            {name = "Color", icon = "ball", type = "color"},
        },
        output = {},

        generator = {
            header = function(vehicle,color)
                local r, g, b, a = generator.colorTableToRGBA(color)
                return ("setVehicleColor(%s,%s,%s,%s)"):format(vehicle,r,g,b)
            end,
        }
    },
    ["color"] = {
        name = "Color",
        input_able = false,
        continue = false,
        color = true,
        shared = true,
        input = {},
        output = {
            {name = "Color", icon = "ball", type = "color"},
        },

        generator = {
            header = function(r,g,b,a)
                return ("{%s,%s,%s,%s}"):format(r, g, b, a)
            end,
        }
    },
    ["collectgarbage"] = {
        name = "collectgarbage",
        input_able = true,
        continue = true,
        shared = true,
        input = {},
        output = {},

        generator = {
            header = function()
                return "collectgarbage()"
            end,
        }
    },
    ["equal"] = {
        name = "Is equal",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "A", icon = "ball", type = "everything", default = "0"},
            {name = "B", icon = "ball", type = "everything", default = "0"},
        },
        output = {
            {name = "Condition", icon = "ball", type = "condition"},
        },

        generator = {
            header = function(a, b)
                return ("%s == %s"):format(a, b)
            end,
        }
    },
    ["istrue"] = {
        name = "Is true",
        input_able = false,
        continue = false,
        shared = true,
        input = {
            {name = "A", icon = "ball", type = "everything", default = "0"},
        },
        output = {
            {name = "Condition", icon = "ball", type = "condition"},
        },

        generator = {
            header = function(a)
                return ("%s"):format(a)
            end,
        }
    },
}
local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)
local ui_components = modules.ui_components

local sub_components = script.Parent.sub_components
local toggle_option = require(sub_components.toggle_option)
local input_option = require(sub_components.input_option)

local configurations_panel = roact.Component:extend("configurations_panel")

function configurations_panel:render()
    return roact.createElement("Frame", {
        Size = UDim2.new(0, 320, 0, 375),
        Position = UDim2.new(0, 30, 0, 10),
        BackgroundTransparency = 1,
    }, {
        roact.createElement("TextLabel", {
            Size = UDim2.new(0, 320, 0, 30),
            BackgroundTransparency = 1,
            Font = "Roboto",
            TextSize = 25,
            TextColor3 = Color3.fromRGB(161, 161, 161),
            Text = "Configuration"
        }),

        -- Container for all the options
        roact.createElement("Frame", {
            Size = UDim2.new(0, 320, 0, 325),
            Position = UDim2.new(0, 0, 0, 50),
            BackgroundTransparency = 1,
        }, {
            roact.createElement("UIListLayout", {
                Padding = UDim.new(0, 5),
            }),
            
            roact.createElement(toggle_option, {
                option_name = "Display Rejections",
                config_id = "display_rejections",
                option_description = "Choose if rejected usernames will be displayed in the output",
            }),

            roact.createElement(toggle_option, {
                option_name = "Use Numbers",
                config_id = "use_numbers",
                option_description = "Choose if tested usernames will include numbers.",
            }),

            roact.createElement(toggle_option, {
                option_name = "Use Underscores",
                config_id = "use_underscores",
                option_description = "Choose if tested usernames will include underscores.",
            }),

            roact.createElement(input_option, {
                option_name = "Username Length",
                option_description = "Choose the length of tested usernames (4-20) characters.",
                config_id = "username_length",
                default = "5",
                sanitise = function(new)
                    new = tonumber(new)
                    if new == nil then
                        return false
                    end

                    return new >= 4 and new <= 20
                end
            })
        })
    })
end

return configurations_panel
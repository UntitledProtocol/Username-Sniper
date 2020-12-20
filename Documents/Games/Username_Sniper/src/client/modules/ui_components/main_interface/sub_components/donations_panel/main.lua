local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)

local sub_components = script.Parent.sub_components
local donation_option = require(sub_components.donation_option)

local donations_panel = roact.Component:extend("donations_panel")

function donations_panel:render()
    return roact.createElement("Frame", {
        Size = UDim2.new(0, 320, 0, 200),
        Position = UDim2.new(0, 30, 0, 295),
        BackgroundTransparency = 1,
    }, {
        roact.createElement("TextLabel", {
            Size = UDim2.new(0, 320, 0, 40),
            BackgroundTransparency = 1,
            Font = "Roboto",
            TextSize = 25,
            TextColor3 = Color3.fromRGB(161, 161, 161),
            Text = "Donations",
        }),
        roact.createElement("TextLabel", {
            Size = UDim2.new(0, 320, 0, 50),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1,
            Font = "Roboto",
            TextWrapped = true,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(74, 74, 74),
            Text = "Like my work? Please consider donating in order to support the creation of new projects just like this in the future! (Thank you if you have already donated)",
        }),
        roact.createElement("Frame", {
            Size = UDim2.new(0, 320, 0, 300),
            Position = UDim2.new(0, 0, 0, 90),
            BackgroundTransparency = 1,
        }, {
            roact.createElement("UIGridLayout", {
                CellSize = UDim2.new(0, 155, 0, 30),
                CellPadding = UDim2.new(0, 10, 0, 10),
            }),

            -- All donation options should go here:
            roact.createElement(donation_option, {
                cost = 20,
                id = 1127137553,
            }),

            roact.createElement(donation_option, {
                cost = 50,
                id = 1127138353
            }),

            roact.createElement(donation_option, {
                cost = 80,
                id = 1127138639
            }),

            roact.createElement(donation_option, {
                cost = 150,
                id = 1127138823,
            }),
        })
    })
end

return donations_panel
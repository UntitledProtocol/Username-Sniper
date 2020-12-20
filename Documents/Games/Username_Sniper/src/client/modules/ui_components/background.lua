local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)

local background = roact.Component:extend("background")

function background:render()
    return roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 2, 0 ),
        Position = UDim2.new(0, 0, -1, 0),
        BorderSizePixel = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
end

return background
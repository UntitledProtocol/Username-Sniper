local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)

local donation_option = roact.Component:extend("donation_option")

local MarketplaceService = game:GetService("MarketplaceService")

local local_player = game:GetService("Players").LocalPlayer

function donation_option:render()
    return roact.createElement("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxassetid://6060585870"
    }, {
        roact.createElement("TextLabel", {
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(0, 65, 0, 30),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 20,
            BackgroundTransparency = 1,
            Font = "Roboto",
            Text = self.props.cost
        }, {
            roact.createElement("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                BackgroundTransparency = 1,

                [roact.Event.Activated] = function()
                    MarketplaceService:PromptProductPurchase(local_player, self.props.id)
                end
            })
        })
    })
end

return donation_option
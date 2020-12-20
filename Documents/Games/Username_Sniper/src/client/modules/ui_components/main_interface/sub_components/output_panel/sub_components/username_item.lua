local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)
local otter = require(libraries.ui.otter)
local ui_components = modules.ui_components

local username_item = roact.Component:extend("username_item")

function username_item:init()
    self._fade_in_motor = otter.createSingleMotor(100)
    self._motor_value, self._update_motor_value = roact.createBinding(100)
end

function username_item:render()
    return roact.createElement("ImageLabel", {
        Size = UDim2.new(0, 385, 0, 60),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6046287930",
        LayoutOrder = self.props.order,
        ImageTransparency = self._motor_value:map(function(value)
            return value / 100
        end)
    }, {
        roact.createElement("TextBox", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Font = "Roboto",
            TextSize = 20,
            TextColor3 = Color3.fromRGB(74, 74, 74),
            Text = self.props.username,
            TextTransparency =  self._motor_value:map(function(value)
                return value / 100
            end),

            [roact.Change.Text] = function(rbx)
                rbx.Text = self.props.username
            end,
        }),

        roact.createElement("TextLabel", {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            Font = "Roboto",
            TextSize = 20,
            TextColor3 = Color3.fromRGB(161, 161, 161),
            Text = self.props.description,
            RichText = true,
            TextTransparency =  self._motor_value:map(function(value)
                return value / 100
            end)
        }),
    })
end

function username_item:didMount()
    local on_step_disconnect = self._fade_in_motor:onStep(function(value)
        self._update_motor_value(value)
    end)

    local on_complete_disconnect
    on_complete_disconnect = self._fade_in_motor:onComplete(function()
        on_step_disconnect()
        on_complete_disconnect()
        self._fade_in_motor:destroy()
    end)

    self._fade_in_motor:setGoal(otter.spring(0))
end

return username_item
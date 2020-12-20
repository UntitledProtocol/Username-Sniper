local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)
local roact_redux = require(libraries.ui.roact_rodux)
local otter = require(libraries.ui.otter)

local toggle_option = roact.Component:extend("toggle_option")

function toggle_option:init()
    self:setState({
        switch_enabled = false
    })
    
    self._switch_motor = otter.createSingleMotor(0)
    self._switch_pos, self._update_switch_pos = roact.createBinding(0)
end

function toggle_option:render()
    return roact.createElement("Frame", {
        Size = UDim2.new(0, 250, 0, 50),
        BackgroundTransparency = 1,
    }, {
        roact.createElement("TextLabel", {
            Size = UDim2.new(0, 320, 0, 30),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = "Roboto",
            TextSize = 20,
            TextColor3 = Color3.fromRGB(74, 74, 74),
            Text = self.props.option_name
        }),

        roact.createElement("TextLabel", {
            Size = UDim2.new(0, 320, 0, 20),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = "Roboto",
            TextSize = 10,
            TextColor3 = Color3.fromRGB(161, 161, 161),
            Text = self.props.option_description
        }),

        -- This is the actual toggle switch.
        roact.createElement("ImageLabel", {
            Size = UDim2.new(0, 60, 0 , 30),
            Position = UDim2.new(0, 260, 0, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6046287725"
        }, {
            roact.createElement("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",

                [roact.Event.Activated] = function()
                    self:setState(function(old)
                        return {
                            switch_enabled = not old.switch_enabled
                        }
                    end)

                    self.props.change_config(self.props.config_id, self.state.switch_enabled)
                    self._switch_motor:setGoal(otter.spring(self.state.switch_enabled and 30 or 0, {frequency = 1000, dampingRatio = 200}))
                end
            }),

            roact.createElement("ImageLabel", {
                Size = UDim2.new(0, 26, 0 , 26),
                Position = self._switch_pos:map(function(value)
                    return UDim2.new(0, 2 + value, 0, 2)
                end),
                BackgroundTransparency = 1,
                ImageColor3 = self.state.switch_enabled and Color3.fromRGB(97, 255, 184)or Color3.fromRGB(255, 105, 97),
                Image = "rbxassetid://6046287625"
            })
        })
    })
end

function toggle_option:didMount()
    self._switch_motor:onStep(function(now)
        self._update_switch_pos(now)
    end)
end

return roact_redux.connect(
    function(state, old)
        return {}
    end,
    function(dispatch)
        return {
            change_config = function(config_id, value)
                dispatch({
                    type = "change_config",
                    config = config_id,
                    value = value,
                })
            end
        }
    end
)(toggle_option)
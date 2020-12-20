local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)
local roact_redux = require(libraries.ui.roact_rodux)

local input_option = roact.Component:extend("input_option")

function input_option:render()
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

        roact.createElement("ImageLabel", {
            Size = UDim2.new(0, 60, 0, 30),
            Position = UDim2.new(0, 260, 0, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6051407239"
        }, {
            roact.createElement("TextBox", {
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0.1 , 0, 0, 0),
                BackgroundTransparency = 1,
                TextSize = 20,
                Font = "Roboto",
                TextColor3 = Color3.fromRGB(74, 74, 74),
                Text = self.props.default,

                [roact.Event.FocusLost] = function(rbx)
                    local was_valid = self.props.sanitise(rbx.Text)
                    if not was_valid then
                        rbx.Text = self.props.default
                    else
                        self.props.value_changed(self.props.config_id, tonumber(rbx.Text))
                    end
                end
            })
        })
    })
end

return roact_redux.connect(
    function()
        return {}
    end,
    function(dispatch)
        return {
            value_changed = function(config_id, new)
                return dispatch({
                    type = "change_config",
                    config = config_id,
                    value = new,
                })
            end
        }
    end
)(input_option)
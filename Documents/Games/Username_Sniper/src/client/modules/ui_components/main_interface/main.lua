local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)
local roact_redux = require(libraries.ui.roact_rodux)
local ui_components = modules.ui_components

local sub_components = script.Parent.sub_components
local configurations_panel = require(sub_components.configurations_panel.main)
local output_panel = require(sub_components.output_panel.main)
local donations_panel = require(sub_components.donations_panel.main)

local main_interface = roact.Component:extend("main_interface")

function main_interface:init()
    self:setState({
        generation_on = false
    })
end

function main_interface:render()
    return roact.createElement("ImageLabel", {
        Size = UDim2.new(0, 800, 0, 500),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6046287526",
        ZIndex = 2,
    }, {
        roact.createElement(configurations_panel),
        roact.createElement(output_panel),
        roact.createElement(donations_panel),

        -- Toggle for generation:
        roact.createElement("ImageButton", {
            Size = UDim2.new(0, 200, 0, 40),
            Position = UDim2.new(0, 590, 0, 450),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6046288017",

            ImageColor3 = self.state.generation_on and Color3.fromRGB(255, 105, 97) or Color3.fromRGB(97, 255, 184),
            [roact.Event.Activated] = function()
                self:setState(function(old)
                    return {
                        generation_on = not old.generation_on
                    }
                end)

                self.props.toggle_name_generation(self.state.generation_on)
            end
        }, {
            roact.createElement("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = "Roboto",
                TextSize = 20,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Text = self.state.generation_on and "Stop" or "Start"
            })
        }),

        -- button for wiping:
        roact.createElement("ImageButton", {
            Size = UDim2.new(0, 200, 0, 40),
            Position = UDim2.new(0, 380, 0, 450),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6046288190",

            [roact.Event.Activated] = self.props.wipe_items
        }, {
            roact.createElement("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = "Roboto",
                TextSize = 20,
                TextColor3 = Color3.fromRGB(74, 74, 74),
                Text = "Clear"
            })
        })
    })
end

return roact_redux.connect(
    function(state, props)
        return {}
    end,
    function(dispatch)
        return {
            toggle_name_generation = function(value)
                dispatch({
                    type = "toggle_name_generation",
                    value = value
                })
            end,

            wipe_items = function()
                dispatch({
                   type = "wipe_items"
               })
           end
        }
    end
)(main_interface)
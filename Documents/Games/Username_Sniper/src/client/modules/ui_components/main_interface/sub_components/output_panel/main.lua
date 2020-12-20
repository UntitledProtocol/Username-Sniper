local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local roact : Roact = require(libraries.ui.roact)
local roact_rodux = require(libraries.ui.roact_rodux)
local ui_components = modules.ui_components

local sub_components = script.Parent.sub_components
local username_item = require(sub_components.username_item)

local output_panel = roact.Component:extend("output_panel")

local function items_fragment(props)
    local children = {}
    for i, v in ipairs(props.items) do
        if (not props.display_rejections) and (not v.accepted) then
            continue
        end

        children[v.name] = roact.createElement(username_item, {
            username = v.name,
            description = v.description,
            order = i
        })
    end

    return roact.createFragment(children)
end

function output_panel:init()
    self._content_size, self._update_content_size = roact.createBinding(UDim2.new(0, 0, 0, 0))
end

function output_panel:render()
    return roact.createElement("ImageLabel", {
        Size = UDim2.new(0, 410, 0, 430),
        Position = UDim2.new(0, 380, 0, 10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6046287813",
    }, {
        roact.createElement("ScrollingFrame", {
            Size = UDim2.new(0, 398, 0, 425),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 10,
            BorderSizePixel = 0,
            ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75),
            CanvasSize = self._content_size,
        }, {
            roact.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                [roact.Change.AbsoluteContentSize] = function(rbx)
                    local abs = rbx.AbsoluteContentSize
                    self._update_content_size(UDim2.new(0, abs.X, 0, abs.Y + 65))
                end
            }),

            roact.createElement(items_fragment, {
                items = self.props.items,
                display_rejections = self.props.display_rejections,
            })
        })
    })
end

return roact_rodux.connect(
    function(store_state, _)
        return {items = store_state.output_items, display_rejections = store_state.config.display_rejections}
    end
)(output_panel)
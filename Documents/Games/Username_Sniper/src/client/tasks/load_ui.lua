local load_ui_task = {name = "load_ui_task"}

local RunService = game:GetService("RunService")

local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local modules = player_scripts:WaitForChild("modules")

local current_cam = game.Workspace.CurrentCamera

local roact : Roact = require(libraries.ui.roact)
local rodux = require(libraries.state.rodux)
local roact_rodux = require(libraries.ui.roact_rodux)

local ui_components = modules.ui_components
local ui_store = require(modules.ui_store)

function load_ui_task:init()
    local ref = roact.createRef()

    local tree = roact.createElement("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, {
        roact.createElement("UIScale", {Scale = 1, [roact.Ref] = ref}),
        roact.createElement(require(ui_components.main_interface.main)),
        roact.createElement(require(ui_components.background)),
    })

    tree = roact.createElement(roact_rodux.StoreProvider, {store = ui_store}, {tree})
    roact.mount(tree, self:get_local_player().PlayerGui)
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    RunService.RenderStepped:Connect(function()
        local s = ref:getValue()
        s.Scale = math.clamp(current_cam.ViewportSize.Y / 720, 0, 1)
    end)
end

return load_ui_task
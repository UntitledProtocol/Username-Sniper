local frost = require(game:GetService("ReplicatedStorage").framework.frost)
local task_modules = script.Parent:WaitForChild("tasks"):GetChildren()

for _, module in ipairs(task_modules) do
    frost.append_task(require(module))
end

frost.start_framework()
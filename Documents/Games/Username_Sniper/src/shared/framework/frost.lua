local RunService = game:GetService("RunService")

local IS_SERVER = RunService:IsServer()

local task_methods = require(script.Parent.task_methods[IS_SERVER and "server" or "client"])

local famework_started = false
local tasks = {} -- key = task name, value = task table

local function get_task(task_name)
    local wanted_task = tasks[task_name]

    if not wanted_task then
        warn(string.format("Requested task does not exist! Task name:%s", task_name))
    end

    return wanted_task
end

local function append_task(task_table)
    local task_name = task_table.name
    assert(famework_started == false, "Cannot call append_task after framework has started!")
    assert(tasks[task_name] == nil, string.format("Cannot append task. Existing task already uses the name:%s", tostring(task_name)))

    -- expose the task table to framework server/client methods:
    setmetatable(task_table, {__index = task_methods})
    tasks[task_name] = task_table
end

local function start_framework()
    assert(famework_started == false, "Must not call start_framework more than once!")
    famework_started = true

    -- call init in all tasks:
    for task_name, this_task in pairs(tasks) do
        if this_task.init then
            this_task:init()
        end
    end

    -- call start in all tasks:
    for task_name, this_task in pairs(tasks) do
        this_task.__start_called = true

        if this_task.start then
            local c = coroutine.create(function()
                this_task:start()
            end)

            coroutine.resume(c)
        end
    end
end

-- API:
local frost = {
    get_task = get_task,
    append_task = append_task,
    start_framework = start_framework,
}

return frost
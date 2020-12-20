local Players = game:GetService("Players")

local remotes_folder = script.Parent.Parent:WaitForChild("remotes")

function subscribe_to_remote_event(self, remote_name, callback_function)
end

function invoke_remote_function(self, name, ...)
    return remotes_folder[name]:InvokeServer(...)
end

function get_local_player(_)
    return Players.LocalPlayer
end

local methods = {
    subscribe_to_remote_event = subscribe_to_remote_event,
    invoke_remote_function = invoke_remote_function,
    get_local_player = get_local_player,
}

return methods
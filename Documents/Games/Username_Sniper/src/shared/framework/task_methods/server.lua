local ReplicatedStorage = game:GetService("ReplicatedStorage")
local framework = ReplicatedStorage.framework

local remotes_folder = framework.remotes

local function create_remote_event(self, name)
    assert(self.__start_called == false, "Can only create remote events during init!")
    local remote = Instance.new("RemoteEvent")
    remote.Name = name
    remote.Parent = remotes_folder
end

function subscribe_to_remote_event(_, name, callback)
    return remotes_folder[name].OnClientEvent:Connect(callback)
end

function subscribe_to_remote_function(_, name, callback)
    remotes_folder[name].OnServerInvoke = callback
end

function create_remote_function(self, name)
    local remote = Instance.new("RemoteFunction")
    remote.Name = name
    remote.Parent = remotes_folder
end

local methods = {
    subscribe_to_remote_event = subscribe_to_remote_event,
    subscribe_to_remote_function = subscribe_to_remote_function,
    create_remote_function = create_remote_function,
    create_remote_event = create_remote_event,
}

return methods
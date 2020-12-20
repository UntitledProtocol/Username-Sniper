local main = {name = "main"}

local HttpService = game:GetService("HttpService")

local ADDRESS = "http://auth.rprxy.xyz/v2/usernames/validate?request.username=%s&request.context=UsernameChange&request.birthday=10/20/2000"

function main:start()
    self:subscribe_to_remote_function("validate_username", function(player, name)
        local result
        local success, err = pcall(function()
            local url = string.format(ADDRESS, name)
            print(url)
            local response = HttpService:GetAsync(url)
            result = HttpService:JSONDecode(tostring((response)))
        end)

        print(result, err)

        if result then
            return result.code, result.message
        else
            return nil
        end
    end)
end

function main:init()
    game.Players.CharacterAutoLoads = false

    self:create_remote_function("validate_username")
end

return main
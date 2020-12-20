local generate_usernames_task = {name = "generate_usernames_task"}

local Players = game:GetService("Players")
local ui_store = require(Players.LocalPlayer.PlayerScripts:WaitForChild("modules").ui_store)

local username_cache = {}

local on = false
local use_numbers = false
local use_underscores = false
local username_length = 5

local function new_username_action(name, description, accepted)
    return {
        type = "new_item",
        item = {name = name, description = description, accepted = accepted},
    }
end

function generate_usernames_task:start()
    local function random_character_from_ascii_range(min, max)
        return string.char(math.random(min, max))
    end

    local function add_underscore(name)
        local pos = math.random(2, string.len(name) - 1)
        local new = string.sub(name, 1, pos - 1).."_"..string.sub(name, pos + 1, string.len(name))

        return new
    end

    local function add_numbers(name)
        local new = string.sub(name, 1, 1)

        for i = 2, string.len(name), 1 do
            local choice = math.random(1, 2)
            if choice == 1 then
                new = new..string.sub(name, i, i)
            else
                new = new..random_character_from_ascii_range(48, 57) -- Numbers in ascii = 48 to 57
            end
        end

        return new
    end

    local function generate_initial_name(length)
        local txt = ""
        for i = 1, length, 1 do
            local choice = math.random(1, 2) -- use a capital letter or lowercase letter
            local char = random_character_from_ascii_range(65, 90) -- 65 - 90 is the ascii range for capital letters
            if choice == 2 then
                char = string.lower(char)
            end

            txt = txt..char
        end

        return txt
    end

    local function validate_username(name)
        local resultant_code, message = self:invoke_remote_function("validate_username", name)

        return resultant_code, message
    end

    local count = 0

    local function generate()
        while true do
            wait(0.1)
            if not on then
                continue
             end
             
             -- The initial name with only letters
             local name = generate_initial_name(username_length)

             if use_numbers then
                name = add_numbers(name)
             end

             if use_underscores then
                name = add_underscore(name)
             end

             if username_cache[name] then return end
             username_cache[name] = true
             
             -- Validate:
             local code, message = validate_username(name)
             local status = code == 0

             local description = status and "<font color='#61FFB8'>Username Available</font>" or string.format("<font color = '#FF6961'>%s</font>", message)

             if message == "Username not appropriate for Roblox" or nil then
                count += 1
                name = "CENCORED NAME-"..tostring(count)
             end

             ui_store:dispatch(new_username_action(name, description, status))
        end
    end

    local generate_coroutine = coroutine.create(generate)
    coroutine.resume(generate_coroutine)

    ui_store.changed:connect(function(state)
        on = state.generating_names
        use_numbers = state.config.use_numbers
        use_underscores = state.config.use_underscores
        username_length = state.config.username_length
    end)
end

return generate_usernames_task
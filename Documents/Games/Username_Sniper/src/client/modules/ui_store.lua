local player_scripts = game:GetService("Players").LocalPlayer.PlayerScripts
local libraries = player_scripts:WaitForChild("libraries")
local rodux = require(libraries.state.rodux)

local output_reducer = rodux.createReducer({}, {
    new_item = function(old, action)
        local new_state = {}
        for i, v in ipairs(old) do
            new_state[i] = v
        end

        table.insert(new_state, action.item)
        return new_state
    end,
    wipe_items = function(old, action)
        return {}
    end
})

local generating_names_reducer = rodux.createReducer(false, {
    toggle_name_generation = function(_, action)
        return action.value
    end
})

local change_config_reducer = rodux.createReducer({
    display_rejections = false,
    use_numbers = false,
    use_underscores = false,
    username_length = 5,
}, {
    change_config = function(old, action)
        local new_state = {}
        -- Shallow clone old state
        for k, v in pairs(old) do
            new_state[k] = v
        end

        new_state[action.config] = action.value

        return new_state
    end
})

local reducer = rodux.combineReducers({
    output_items = output_reducer,
    generating_names = generating_names_reducer,
    config = change_config_reducer
})

local ui_store = rodux.Store.new(reducer, nil, {
    --rodux.loggerMiddleware
})

return ui_store
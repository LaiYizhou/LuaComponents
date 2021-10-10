local string_gsub = string.gsub
local strStarts   = string.starts

local loaded = {}

function loadfile_ex(moduleName)
    moduleName = string_gsub(moduleName, "%.", "/")
    moduleName = moduleName .. ".lua"
    local ret, msg = loadfile(moduleName)
    if ret then
        return ret, msg
    else
        -- error(msg)
        return nil, msg
    end
end

local require_black_list = {
        global_functions = 1,
        bson = 1,
        bit = 1,
        ffi = 1,
        ["common.ds.ordered_table"] = 1,
    }

function require_ex(moduleName)
    if require_black_list[moduleName] ~= nil then
        return require(moduleName)
    end

    if loaded[moduleName] == nil then
        local ret, _ = loadfile_ex(moduleName)
        if ret == nil then
            return nil
        end

        local moduleEnv = setmetatable({}, {__index = _G})
        -- Lua 5.2 之后版本已经移除了
        setfenv(ret, moduleEnv)()
        loaded[moduleName] = moduleEnv
        return moduleEnv
    else
        return loaded[moduleName]
    end
end
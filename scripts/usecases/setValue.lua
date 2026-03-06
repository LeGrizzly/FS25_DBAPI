-- SetValue Use Case
-- Pure business logic for storing a key-value pair.

--- Stores a value in the database under a namespace.
--- @param adapter table DatabaseAdapter instance
--- @param namespace string The mod namespace
--- @param key string The key to store
--- @param value any The value to store
--- @return boolean success
--- @return string|nil errorMessage
local function SetValue(adapter, namespace, key, value)
    if not namespace or namespace == "" then
        return false, "namespace is required"
    end
    if not key or key == "" then
        return false, "key is required"
    end
    if value == nil then
        return false, "value is required"
    end
    return adapter.set(namespace, key, value)
end

if _G.DBAPI_LOADER then _G.DBAPI_LOADER._temp = SetValue end
return SetValue

-- GetValue Use Case
-- Pure business logic for retrieving a value by key.

--- Retrieves a value from the database under a namespace.
--- @param adapter table DatabaseAdapter instance
--- @param namespace string The mod namespace
--- @param key string The key to retrieve
--- @return any|nil value
--- @return string|nil errorMessage
local function GetValue(adapter, namespace, key)
    if not namespace or namespace == "" then
        return nil, "namespace is required"
    end
    if not key or key == "" then
        return nil, "key is required"
    end
    return adapter.get(namespace, key)
end

if _G.DBAPI_LOADER then _G.DBAPI_LOADER._temp = GetValue end
return GetValue

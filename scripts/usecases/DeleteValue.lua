-- DeleteValue Use Case
-- Pure business logic for removing a key from the database.

--- Deletes a key from the database under a namespace.
--- @param adapter table DatabaseAdapter instance
--- @param namespace string The mod namespace
--- @param key string The key to delete
--- @return boolean success
--- @return string|nil errorMessage
local function DeleteValue(adapter, namespace, key)
    if not namespace or namespace == "" then
        return false, "namespace is required"
    end
    if not key or key == "" then
        return false, "key is required"
    end
    return adapter.delete(namespace, key)
end

if _G.DBAPI_LOADER then _G.DBAPI_LOADER._temp = DeleteValue end
return DeleteValue

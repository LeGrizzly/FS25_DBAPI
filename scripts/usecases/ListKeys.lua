-- ListKeys Use Case
-- Pure business logic for listing all keys in a namespace.

--- Lists all keys stored under a namespace.
--- @param adapter table DatabaseAdapter instance
--- @param namespace string The mod namespace
--- @return table|nil keys Array of key names
--- @return string|nil errorMessage
local function ListKeys(adapter, namespace)
    if not namespace or namespace == "" then
        return nil, "namespace is required"
    end
    return adapter.listKeys(namespace)
end

if _G.DBAPI_LOADER then _G.DBAPI_LOADER._temp = ListKeys end
return ListKeys

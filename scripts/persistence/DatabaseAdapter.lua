-- DatabaseAdapter - Bridges FlatDB with FS25's savegame system
-- Each namespace gets its own FlatDB "page" (saved as namespace.xml).

local DatabaseAdapter = {}

local db = nil
local dbPath = nil

--- Creates the database directory using FS25's sandbox-safe function.
--- @param path string Directory path to create
--- @return boolean success
local function ensureDirectory(path)
    if createFolder then
        createFolder(path)
        return true
    end
    return false
end

--- Initializes the database at the given path.
--- @param flatDB table The FlatDB constructor
--- @param path string File system path for the database
function DatabaseAdapter.init(flatDB, path)
    if db then return end

    if not flatDB then
        print("DBAPI Error: FlatDB module is required for DatabaseAdapter.init")
        return
    end

    dbPath = path or "modSaveData_DBAPI"
    ensureDirectory(dbPath)
    db = flatDB(dbPath)
    print("DBAPI: Database initialized at " .. tostring(dbPath))
end

--- Sets a value in a namespaced page.
--- @param namespace string The mod namespace (e.g. "FS25_MyMod")
--- @param key string The key to store
--- @param value any The value to store (string, number, boolean, table)
--- @return boolean success
--- @return string|nil errorMessage
function DatabaseAdapter.set(namespace, key, value)
    if not db then return false, "Database not initialized" end
    if not namespace or namespace == "" then return false, "namespace is required" end
    if not key or key == "" then return false, "key is required" end
    if value == nil then return false, "value cannot be nil (use delete to remove)" end

    if not db[namespace] then db[namespace] = {} end
    db[namespace][key] = value
    return db:save(namespace)
end

--- Gets a value from a namespaced page.
--- @param namespace string The mod namespace
--- @param key string The key to retrieve
--- @return any|nil value
--- @return string|nil errorMessage
function DatabaseAdapter.get(namespace, key)
    if not db then return nil, "Database not initialized" end
    if not namespace or namespace == "" then return nil, "namespace is required" end
    if not key or key == "" then return nil, "key is required" end

    local page = db[namespace]
    if not page then return nil end
    return page[key]
end

--- Deletes a key from a namespaced page.
--- @param namespace string The mod namespace
--- @param key string The key to delete
--- @return boolean success
--- @return string|nil errorMessage
function DatabaseAdapter.delete(namespace, key)
    if not db then return false, "Database not initialized" end
    if not namespace or namespace == "" then return false, "namespace is required" end
    if not key or key == "" then return false, "key is required" end

    local page = db[namespace]
    if not page then return false, "namespace not found" end

    page[key] = nil
    return db:save(namespace)
end

--- Lists all keys in a namespace.
--- @param namespace string The mod namespace
--- @return table|nil keys Array of key names
--- @return string|nil errorMessage
function DatabaseAdapter.listKeys(namespace)
    if not db then return nil, "Database not initialized" end
    if not namespace or namespace == "" then return nil, "namespace is required" end

    local page = db[namespace]
    if not page then return {} end

    local keys = {}
    for k, _ in pairs(page) do
        keys[#keys + 1] = k
    end
    table.sort(keys)
    return keys
end

--- Persists all data to disk.
function DatabaseAdapter.save()
    if db then db:save() end
end

--- Returns true if the database is initialized.
--- @return boolean
function DatabaseAdapter.isReady()
    return db ~= nil
end

if _G.DBAPI_LOADER then _G.DBAPI_LOADER._temp = DatabaseAdapter end
return DatabaseAdapter

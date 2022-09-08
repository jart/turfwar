sqlite3 = require "lsqlite3"

function ConnectDb()
    if not db then
        db = sqlite3.open("db.sqlite3")
        db:busy_timeout(1000)
        db:exec[[PRAGMA journal_mode=WAL]]
        db:exec[[PRAGMA synchronous=NORMAL]]
    end
end

function OnServerStart()
    local err
    claims_log, err = unix.open("claims.log", unix.O_WRONLY | unix.O_APPEND | unix.O_CREAT, 0644)
    if err ~= nil then
        Log(kLogFatal, string.format("error opening claim log: %s", err))
    end
end

-- Redbean's global route handler
function OnHttpRequest()
    local path = GetPath()
    if path == "/ip" then
        Route(GetHost(), "/ip.lua")
    elseif path == "/summary" then
        Route(GetHost(), "/summary.lua")
    elseif path == "/claim" then
        Route(GetHost(), "/claim.lua")
    else
        -- Default redbean route handling
        Route()
    end
end

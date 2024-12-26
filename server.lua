ServerData = {
    count = 0,
    is_extracting = false,
    grace_periods = {}
}

AddEventHandler("playerConnecting", function(_, _, deferrals)
    local source = source
    local identifier = GetPlayerIdentifierByType(source, Config.identifier_type)
    if identifier then
        deferrals.update("Connecting to the server...")
        if ServerData.grace_periods[identifier] then
            ServerData.grace_periods[identifier] = nil
            deferrals.done()
        else
            Enqueue("insert",
                {
                    time = os.time(),
                    priority = Config.priority[identifier] or 0,
                    deferrals = deferrals,
                    network_violations = 0,
                    id = source
                })
        end
    else
        deferrals.done("You must use " .. Config.identifier_type " to connect to the server")
    end
end)

AddEventHandler("playerDropped", function(_)
    local source = tostring(source)
    local identifier = GetPlayerIdentifierByType(source, Config.identifier_type)
    ServerData.grace_periods[identifier] = os.time()
    Citizen.CreateThread(function()
        Wait(120000)
        if ServerData.grace_periods[identifier] then
            ServerData.grace_periods[identifier] = nil
            Enqueue("decrement", {})
        end
    end)
end)

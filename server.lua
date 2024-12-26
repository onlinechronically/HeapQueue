AddEventHandler("playerConnecting", function(_, _, deferrals)
    local source = source
    local identifier = GetPlayerIdentifierByType(source, Config.identifier_type)
    if identifier then
        deferrals.update("Connecting to the server...")
        Enqueue("insert",
            { time = os.time(), priority = Config.priority[identifier] or 0, deferrals = deferrals, active = true, network_violations = 0 })
    else
        deferrals.done("You must use " .. Config.identifier_type " to connect to the server")
    end
end)

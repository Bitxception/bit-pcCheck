ESX = exports["es_extended"]:getSharedObject()

local pcCheckLocations = {
    maze = vector3(-75.168701171875, -819.44763183594, 326.17517089844),
    fib = vector3(149.86125183105, -760.158203125, 262.85302734375),
    iaa = vector3(133.99104309082, -622.65570068359, 262.85073852539),
    mile = vector3(-149.78370666504, -958.81811523438, 269.13482666016),
    arcadius = vector3(-144.61546325684, -593.0947265625, 211.77502441406),
    schlong = vector3(-195.56243896484, -742.07257080078, 219.9720916748)
}

local pccheckActive = {}

RegisterCommand("pccheck", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "admin" and xPlayer.getGroup() ~= "team" then
         TriggerClientEvent('chat:addMessage', source, { args = { "Du hast keine Berechtigung, diesen Befehl zu nutzen." } })
         return
    end

    if #args < 1 then
         TriggerClientEvent('chat:addMessage', source, { args = { "Usage: /pccheck <id> [location]" } })
         return
    end

    local targetId = tonumber(args[1])
    local locationKey = #args >= 2 and args[2] or "maze"

    if not targetId then
         TriggerClientEvent('chat:addMessage', source, { args = { "Ungültige Spieler-ID." } })
         return
    end

    local location = pcCheckLocations[locationKey]
    if not location then
         TriggerClientEvent('chat:addMessage', source, { args = { "Ungültiger Ort. Verfügbare Orte: maze, fib, iaa, mile, arcadius, schlong" } })
         return
    end

    if pccheckActive[targetId] then
         TriggerClientEvent("myScript:returnPlayer", targetId)
         pccheckActive[targetId] = nil
         print("PC‑Check beendet: Spieler " .. targetId .. " wird zurück teleportiert.")
    else
         TriggerClientEvent("myScript:pcCheck", targetId, location)
         pccheckActive[targetId] = true
         print("PC‑Check aktiviert: Spieler " .. targetId .. " wird zum '" .. locationKey .. "' teleportiert und eingefroren.")
    end
end, false)

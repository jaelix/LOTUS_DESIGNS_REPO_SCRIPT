local vehicleModels = {
    "comet6", "buffalo4", "sultanrs", "zentorno", "tailgater2"
}

local spawnLocations = {
    { coords = vector4(-1111.5, -1682.1, 4.4, 120.0) },
    { coords = vector4(246.2, -372.3, 44.0, 250.0) },
    { coords = vector4(-321.8, -1313.1, 31.3, 180.0) },
    { coords = vector4(1180.2, -330.5, 69.3, 85.0) },
    { coords = vector4(-802.2, -218.8, 37.9, 300.0) }
}

RegisterServerEvent("boost:requestJob")
AddEventHandler("boost:requestJob", function()
    local src = source
    local selected = math.random(1, #vehicleModels)
    local model = vehicleModels[selected]

    local loc = spawnLocations[math.random(1, #spawnLocations)].coords

    TriggerClientEvent("boost:startJob", src, loc, model)

    -- Optional: notify police or log here
end)

RegisterServerEvent("boost:completeJob")
AddEventHandler("boost:completeJob", function()
    local src = source
    print("[BOOSTING] Player ID " .. src .. " completed a job.")
    TriggerClientEvent("chat:addMessage", src, {
        args = { "^2[BOOST]", "Vehicle delivered successfully. Good work!" }
    })
    -- Add payment logic here if needed (e.g., using exports or custom inventory)
end)

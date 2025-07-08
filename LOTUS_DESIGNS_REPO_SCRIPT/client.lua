local boostActive = false
local targetVehicle = nil
local dropOffCoords = vector3(-222.9, -1326.5, 30.9) -- Modify as needed
local vehicleModels = { "comet6", "buffalo4", "sultanrs", "zentorno", "tailgater2" }

RegisterCommand("boost", function()
    if not boostActive then
        TriggerServerEvent("boost:requestJob")
    else
        notify("You already have an active contract.")
    end
end)

RegisterNetEvent("boost:startJob")
AddEventHandler("boost:startJob", function(spawnCoords, vehicleModel)
    boostActive = true

    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do Wait(0) end

    targetVehicle = CreateVehicle(vehicleModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
    SetVehicleDoorsLocked(targetVehicle, 1)
    SetEntityAsMissionEntity(targetVehicle, true, true)

    notify("Contract started. Steal the vehicle and deliver it.")
    SetNewWaypoint(spawnCoords.x, spawnCoords.y)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if boostActive and targetVehicle then
            local player = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(player, false)
            if playerVeh == targetVehicle then
                local coords = GetEntityCoords(playerVeh)
                local dist = #(coords - dropOffCoords)

                DrawMarker(1, dropOffCoords.x, dropOffCoords.y, dropOffCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 0, 255, 0, 100, false, true, 2, false)

                if dist < 5.0 then
                    notify("Press ~INPUT_CONTEXT~ to deliver the vehicle.")
                    if IsControlJustReleased(0, 38) then
                        DeleteVehicle(playerVeh)
                        boostActive = false
                        targetVehicle = nil
                        TriggerServerEvent("boost:completeJob")
                    end
                end
            end
        end
    end
end)

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

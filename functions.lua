playerPed = GetPlayerPed(-1)

function draw3DText(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local coords = GetGameplayCamCoords()
    local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, x, y, z, 1)
    local scale = (1 / dist) * 2
    if onScreen and dist < 7 then
        SetTextScale(0.0, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function showNotification(msg, color, flash, saveToBrief)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    ThefeedNextPostBackgroundColor(color)
    EndTextCommandThefeedPostTicker(flash, saveToBrief)
end

function showAlert(msg, beep, duration)
    AddTextEntry('ALERT', msg)
    BeginTextCommandDisplayHelp('ALERT')
    EndTextCommandDisplayHelp(0, false, beep, duration)
end    

function goOnDuty()
    dutyStatus = true
    showAlert("You are now on duty!", true, -1)
    spawnVehicle(Config.vehicle)
end

function goOffDuty()
    dutyStatus = false
    showAlert("You are now off duty!", true, -1)
    local lastVehicle = GetVehiclePedIsIn(playerPed, true)
    DeleteVehicle(lastVehicle)
end

function spawnVehicle(car)
    vehicleSpawned = true
    local hash = GetHashKey(car)
    local carPaint = 0
    RequestModel(hash)
    
    while not HasModelLoaded(hash) do
        Citzen.Wait(0)
    end

    local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0, 5.0, 0)
    local vehicle = CreateVehicle(hash, ds.vehicle.x, ds.vehicle.y, ds.vehicle.z, ds.vehicle.heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetModelAsNoLongerNeeded(hash)
    SetVehicleColours(vehicle, carPaint, carPaint)
    SetVehicleExtra(vehicle, 1, 0)
    SetVehicleFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end

function checkParkedVehicle(car)
    
end 
onduty = false

vechicleSpawned = false
playerVehicle = nil

onDutyText = "Press [E] for Parking Enforcement"
vehicleSpawnText = "Press [E] to spawn vehicle"


Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            for i = 1, #dutyStations, 1 do
                ds = dutyStations[i]
                DrawMarker(
                    ds.onDuty.marker,
                    ds.onDuty.x,
                    ds.onDuty.y,
                    ds.onDuty.z-0.99,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    ds.onDuty.scale,
                    ds.onDuty.scale,
                    ds.onDuty.scale,
                    ds.onDuty.color[1],
                    ds.onDuty.color[2],
                    ds.onDuty.color[3],
                    ds.onDuty.color[4],
                    false,
                    true,
                    2,
                    false,
                    nil,
                    nil,
                    false
                )
                Draw3DText(ds.onDuty.x, ds.onDuty.y, ds.onDuty.textZ, onDutyText, ds.onDuty.scale)
                local playerCoord = GetEntityCoords(PlayerPedId(), false)
                local locVector = vector3(ds.onDuty.x, ds.onDuty.y, ds.onDuty.z)
                if Vdist2(playerCoord, locVector) < ds.onDuty.scale * 1.15 then
                    if IsControlJustReleased(1, 46) then
                        goOnDuty()
                        
                    end
                end

            end
        end
    end
)

-- Checks for vehicle and sets variable when vehicle is spawned.
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
                local playerId = PlayerPedId(-1)
                local playerPed = GetPlayerPed(-1)
                
                if playerVehicle == nil then
                    if IsPedInAnyVehicle(playerId, false) then 
                        playerVehicle = GetVehiclePedIsIn(playerPed, false)
                    end
                end
                
        end
    end
)

-- Checks if the vehicle the ped was just in is deleted and then 
-- puts them off duty and ends the script.
-- exist = DoesEntityExist(playerVehicle)
-- if exist == false then
--     goOffDuty()
-- break end


    
dutyStatus = false
vechicleSpawned = false
playerVehicle = nil


onDutyText = "Press [E] for Parking Enforcement"
checkVehicleText = "Press [H] to check parking status"
issueTicketText = "Press [E] to place ticket on windshield"
parkingStatus = {"Valid", "Expired", "No Ticket"}


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
                draw3DText(ds.onDuty.x, ds.onDuty.y, ds.onDuty.textZ, onDutyText, ds.onDuty.scale)
                local playerCoords = GetEntityCoords(PlayerPedId(), false)
								local locVector = vector3(ds.onDuty.x, ds.onDuty.y, ds.onDuty.z)
                if Vdist2(playerCoords, locVector) < ds.onDuty.scale * 1.15 then
                    if IsControlJustReleased(1, 46) then
                        if dutyStatus == false then
                            goOnDuty()
														print(dutyStatus)
                        else goOffDuty()
                        end
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(function()
  while true do 
		Citizen.Wait(200)
			if dutyStatus == true then
				local playerCoords = GetEntityCoords(PlayerPedId(), false)
				local parkedCar = GetClosestVehicle(playerCoords, Config.checkDistance, 0, 70)
    		local primary, seconday = GetVehicleColours(parkedCar)
				local model = GetEntityModel(parkedCar)
				local modelName = GetDisplayNameFromVehicleModel(model)
				local plate = GetVehicleNumberPlate(parkedCar)
				primary = Config.colorNames[tostring(primary)]
				
				if parkedCar ~= 0 then
					draw3DText(playerCoords, checkVehicleText, 1.0)
				end

				if IsControlJustReleased(1, 74) then

					local statusNum = math.random(1, 3)
					print(statusNum)
				end
			end
	end
end)
    
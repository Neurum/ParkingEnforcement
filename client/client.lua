dutyStatus = false
vechicleSpawned = false
playerVehicle = nil
checkVehicle = true

onDutyText = "Press [~g~E~w~] for Parking Enforcement"
checkVehicleText = "Press [~g~E~w~] to check parking status"
issueTicketText = "Press [~g~H~w~] to place ticket on windshield"

RegisterNetEvent('TicketSound_CL:Printer')
AddEventHandler('TicketSound_CL:Printer', function(soundFile, soundVolume)
    SendNUIMessage({transactionType = 'playSound', transactionFile = soundFile, transactionVolume = soundVolume})
end)

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
		Citizen.Wait(1)
		if dutyStatus == true then
      checkParkedVehicle()
		end
	end
end)
    

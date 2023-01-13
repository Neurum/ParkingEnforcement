playerPed = GetPlayerPed(-1)
statusNum = nil
parkingStatus = {"~g~Valid", "~r~Expired", "~r~No Ticket"}


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

function showAlert(msg, beep, duration)
    AddTextEntry('ALERT', msg)
    BeginTextCommandDisplayHelp('ALERT')
    EndTextCommandDisplayHelp(0, false, beep, duration)
end  

function checkVehicleNotif(vehColor, vehName, vehPlate, color)
	BeginTextCommandThefeedPost('STRING')
	AddTextComponentSubstringPlayerName("Vehicle : " ..vehColor.. " " ..vehName.. "~n~Plate: " ..vehPlate.. "~n~Checking Status .....")
	ThefeedNextPostBackgroundColor(color)
	EndTextCommandThefeedPostTicker(false, false)
end

function vehicleStatus(vehColor, vehName, vehPlate, color)
	BeginTextCommandThefeedPost('STRING')
	AddTextComponentSubstringPlayerName("Vehicle : " ..vehColor.. " " ..vehName.. "~n~Plate: " ..vehPlate.. "~n~Parking Status: " ..parkingStatus[statusNum])
	ThefeedNextPostBackgroundColor(color)
	EndTextCommandThefeedPostTicker(false, false)
	end

function goOnDuty()
    dutyStatus = true
		checkVehicle = true
    showAlert("You are now on duty!", true, -1)
    spawnVehicle(Config.vehicle)
end

function goOffDuty()
    dutyStatus = false
		checkVehicle = false
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



function checkParkedVehicle()
	local soundFile = 'ticket'
	local soundVolume = 0.7
  local playerCoords = GetEntityCoords(PlayerPedId(), false)
	local carCoords = 0
	local parkedCar = GetClosestVehicle(playerCoords, Config.checkDistance, 0, 70)
	local primary, seconday = GetVehicleColours(parkedCar)
	local model = GetEntityModel(parkedCar)
	local modelName = GetDisplayNameFromVehicleModel(model)
	local trunkpos = GetWorldPositionOfEntityBone(parkedCar, GetEntityBoneIndexByName(parkedCar, "windscreen_r"))
	local plate = GetVehicleNumberPlateText(parkedCar)
	primary = Config.colorNames[tostring(primary)]
	
	if parkedCar ~= 0 then
    carCoords = GetEntityCoords(parkedCar)
	end
	local disFromCar = GetDistanceBetweenCoords(playerCoords, carCoords, false)
	if disFromCar < Config.checkDistance then
		if GetVehicleNumberOfPassengers(parkedCar) == 0 and IsVehicleSeatFree(parkedCar, -1) then
			if checkVehicle == true then
			draw3DText(trunkpos.x, trunkpos.y, trunkpos.z, checkVehicleText, 1.0)
			end
			if IsControlJustReleased(1, 46) then
				math.randomseed(GetGameTimer())
				statusNum = math.random(1, 3)
				checkVehicleNotif(primary, modelName, plate, 120)
      	Citizen.Wait(11000)
				if statusNum == 1 then
					vehicleStatus(primary, modelName, plate, 170)
					checkVehicle = true
					statusNum = nil
				else
					vehicleStatus(primary, modelName, plate, 90)
					checkVehicle = false
				end
			end
		end
	end
	if (statusNum == 2 or statusNum == 3)then
		local ticketPos = GetWorldPositionOfEntityBone(parkedCar, GetEntityBoneIndexByName(parkedCar, "windscreen"))
		draw3DText(ticketPos.x, ticketPos.y, ticketPos.z, issueTicketText, 1.0)
		if IsControlJustReleased(1, 74) then
			RegisterNetEvent('TicketSound_CL:Printer')
			AddEventHandler('TicketSound_CL:Printer', function(soundFile, soundVolume)
				SendNUIMessage({transactionType = 'playSound', transactionFile = soundFile, transactionVolume = soundVolume})
			end)
			Citizen.Wait(3200)
				checkVehicle = true
				statusNum = nil
		end
	end 
end



playerPed = GetPlayerPed(-1)
statusNum = nil
parkingStatus = {"~g~Valid", "~r~Expired", "~r~No Ticket"}
PlayerProps = {}
ped = PlayerPedId()


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
        Citizen.Wait(0)
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
				animateCheck()
      	Citizen.Wait(11000)
				deleteProp()
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
			TriggerServerEvent('TicketSound_SV:Printer', 'ticket', 1.0)
			animateTicket()
			Citizen.Wait(8000)
				checkVehicle = true
				statusNum = nil
				deleteProp()
		end
	end 
end

function deleteProp()
	for _, p in pairs(PlayerProps) do
		DeleteEntity(p)
	end
	PlayerProps = {}
end

function loadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
		RequestModel(GetHashKey(model))
		Wait(10)
	end
end

function addProp(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
	local x, y, z = table.unpack(GetEntityCoords(ped))

	if not HasModelLoaded(prop1) then
		loadPropDict(prop1)
	end

	prop = CreateObject(GetHashKey(prop1), x, y, z + 0.2, true, true, true)
	AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
	table.insert(PlayerProps, prop)
	SetModelAsNoLongerNeeded(prop1)
	return true
end

function animateCheck()
	local animDict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a"
	local animName = "idle_a"
	
	while not HasAnimDictLoaded(animDict) do
		RequestAnimDict(animDict)
		Wait(100)
	end

	TaskPlayAnim(ped, animDict, animName, 2.0, 2.0, 11000, 51, 0.0, false, false, false)
	SetPedKeepTask(ped, true)
	RemoveAnimDict(animDict)
	Wait(0)
	addProp("prop_cs_tablet", 28422, -0.05, 0.0, 0.0, 0.0, 0.0, 0.0)
end


function animateTicket()
	local animDict = "missheistdockssetup1clipboard@base"
	local animName = "base"

	while not HasAnimDictLoaded(animDict) do
		RequestAnimDict(animDict)
		Wait(100)
	end

	TaskPlayAnim(ped, animDict, animName, 2.0, 2.0, 8000, 51, 0.0, false, false, false)
	SetPedKeepTask(ped, true)
	RemoveAnimDict(animDict)
	Wait(0)
	addProp('prop_notepad_01', 18905, 0.1, 0.02, 0.05, 10.0, 0.0, 0.0)
	addProp('prop_pencil_01', 58866, 0.11, -0.02, 0.001, -120.0, 0.0, 0.0)
end

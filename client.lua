local c = Config

local onduty = false

local vechicleSpawned = false

local onDutyText = "Press ~r[E] for Parking Enforcement"

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
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
                Draw3DText(ds.onDuty.x, ds.onDuty.y, ds.onDuty.z, onDutyText, ds.onDuty.scale)
            end
        end
    end
)

function Draw3DText(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local coords = GetGameplayCamCoords()
    local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextoutline()
        SetTextEntry("STRING")
        SetTextCenter(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

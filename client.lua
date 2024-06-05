-- Define marker variables
local marker = nil
local waypointBlip = nil
local isMarkerActive = false

-- Function to create waypoint marker
function createWaypointMarker()
    local waypoint = GetFirstBlipInfoId(8) -- Get the waypoint blip ID
    if DoesBlipExist(waypoint) then
        local waypointCoords = GetBlipInfoIdCoord(waypoint) -- Get coordinates of the waypoint
        marker = CreateMarker(1, waypointCoords.x, waypointCoords.y, waypointCoords.z - 1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 0, 0, 255, 200, false, true, 2, nil, nil, false) -- Create marker
        waypointBlip = waypoint
        isMarkerActive = true
    end
end

-- Function to delete waypoint marker
function deleteWaypointMarker()
    if marker ~= nil then
        DeleteEntity(marker)
        marker = nil
        isMarkerActive = false
    end
end

-- Function to handle waypoint change
function onWaypointChange()
    if isMarkerActive then
        deleteWaypointMarker()
    end
    createWaypointMarker()
end

-- Event handler for waypoint change
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsWaypointActive() then
            onWaypointChange()
        end
    end
end)

-- Event handler for player entering vehicle
AddEventHandler('esx:onPlayerEnterVehicle', function(vehicle)
    if isMarkerActive then
        TriggerClientEvent('showWaypointMarker', -1) -- Show marker for all players
    end
end)

-- Event handler for player leaving vehicle
AddEventHandler('esx:onPlayerLeaveVehicle', function(vehicle)
    if isMarkerActive then
        TriggerClientEvent('hideWaypointMarker', -1) -- Hide marker for all players
    end
end)

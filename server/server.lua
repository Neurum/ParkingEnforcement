RegisterNetEvent('TicketSound_SV:Printer')
AddEventHandler('TicketSound_SV:Printer', function(clientNetId, soundFile, soundVolume)
  TriggerClientEvent('TicketSound_CL:Printer', clientNetId, soundFile, soundVolume)
end)

-- Webhook server event


RegisterNetEvent('TicketSound_SV:Printer')
AddEventHandler('TicketSound_SV:Printer', function(soundFile, soundVolume)
  TriggerClientEvent('TicketSound_CL:Printer', source, soundFile, soundVolume)
end)

-- Webhook server event


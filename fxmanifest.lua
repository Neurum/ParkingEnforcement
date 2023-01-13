fx_version 'cerulean'
games { 'gta5' }

author 'Knight'
description 'Parking Enforcement Job'
version '1.0.0'


-- What to run
client_scripts {
    'client/client.lua',
    'client/config.lua',
    'client/dutyStations.lua',
    'client/functions.lua'
}
server_scripts {
    'server/server.lua',
    
}

ui_page 'html/index.html'

files {
    'html/index.html'
    'html/sounds/ticket.ogg',
}
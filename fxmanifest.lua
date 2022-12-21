fx_version 'cerulean'
games { 'gta5' }

author 'Knight'
description 'Parking Enforcement Job'
version '1.0.0'

files {
    'sounds/receipt_print.mp3',
    'sounds/receipt_tear.mp3'
}

-- What to run
client_scripts {
    'client.lua',
    'config.lua',
    'dutyStations.lua',
    'functions.lua'
}
server_scripts {
    'server.lua',
    
}
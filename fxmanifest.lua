fx_version 'cerulean'
game 'gta5'

author 'KraytonOG'
description 'A simple resource for giving an item upon using it with progress bars'
version '1.0.6'

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qbx_core',
    'ox_inventory',
    'ox_lib'
}

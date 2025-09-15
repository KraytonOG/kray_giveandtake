fx_version 'cerulean'
game 'gta5'

author 'KraytonOG'
description 'A simple resource for giving an item upon using it'
version '1.0.1'

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qbx_core',
    'ox_inventory'
}

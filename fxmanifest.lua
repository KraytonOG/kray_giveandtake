fx_version 'cerulean'
game 'gta5'

author 'KraytonOG'
description 'A simple resource for giving an item upon using it with progress bars'
version '1.1.0'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

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

-- Optional dependencies based on your Config settings:
-- Progress Bar: ox_lib (included above) or lation_ui
-- Notifications: qbcore (built-in), ox_lib (included above), or lation_ui

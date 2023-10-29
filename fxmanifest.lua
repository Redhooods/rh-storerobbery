fx_version 'cerulean'
game 'gta5'

description 'QB-StoreRobbery'
version '1.2.0'


shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
}

server_script 'server/main.lua'


lua54 'yes'

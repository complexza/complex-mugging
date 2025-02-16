fx_version 'cerulean'
game 'gta5'
author 'complexza'
description 'NPC Mugging System'
version '1.0.0'
lua54 'yes'

client_scripts {
  'client/**',
}

server_scripts {
  'server/**',
}

shared_scripts {
  '@ox_lib/init.lua',
  'shared/*.lua'
}

files {
  'client/main.lua',
  'server/main.lua',
  'shared/config.lua'
}

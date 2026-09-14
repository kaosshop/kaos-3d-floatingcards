fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'kaos_floating_cards'
author 'Kaos'
description 'Kaos 3D Floating Cards - runtime rendered 3D cards, in-game studio, AI generation. Standalone, no database, no props.'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    'shared/util.lua',
    'shared/defaults.lua',
    'locales/locales.lua'
}

client_scripts {
    'client/framework.lua',
    'client/state.lua',
    'client/render.lua',
    'client/effects.lua',
    'client/interact.lua',
    'client/freecam.lua',
    'client/gizmo.lua',
    'client/main.lua'
}

server_scripts {
    'server/storage.lua',
    'server/permissions.lua',
    'server/ai.lua',
    'server/main.lua'
}

files {
    'html/index.html',
    'html/css/theme.css',
    'html/css/studio.css',
    'html/css/cards.css',
    'html/js/lib/icons.js',
    'html/js/lib/emoji.js',
    'html/js/lib/templates.js',
    'html/js/core/state.js',
    'html/js/core/nui.js',
    'html/js/core/ui.js',
    'html/js/core/cards.js',
    'html/js/core/world.js',
    'html/js/panels/floats.js',
    'html/js/panels/compose.js',
    'html/js/panels/style.js',
    'html/js/panels/motion.js',
    'html/js/panels/place.js',
    'html/js/panels/effects.js',
    'html/js/panels/rules.js',
    'html/js/panels/library.js',
    'html/js/panels/ai.js',
    'html/js/panels/settings.js',
    'html/js/app.js',
    'html/assets/fonts.css'
}

dependencies {
    '/server:5104'
}

Config = {}

Config.UsableItems = {
    ['weed_whitewidow_bag'] = {
        itemToRemove = 'weed_whitewidow_bag',
        countToRemove = 1,
        itemsToGive = {
            { name = 'weed_whitewidow_crop', count = 2 },
            { name = 'empty_weed_bag', count = 1 }
        },
        animDict = 'mp_arresting',
        animName = 'a_uncuff',
        animFlag = 49, -- Looping, upper body, secondary slot
        notificationSettings = {
            title = 'Item Exchange',
            icon = 'fas fa-exchange-alt',
            sound = 'success_sound.ogg'
        }
    },
    ['water_bottle'] = {
        itemToRemove = 'water_bottle',
        countToRemove = 1,
        itemsToGive = {
            { name = 'empty_bottle', count = 1 }
        },
        animDict = 'mp_player_int_uppervape',
        animName = 'mp_vape__v_in',
        animFlag = 49,
        notificationSettings = {
            title = 'Hydration',
            icon = 'fas fa-glass-whiskey',
            sound = nil
        }
    },
    ['raw_ore'] = {
        itemToRemove = 'raw_ore',
        countToRemove = 5,
        itemsToGive = {
            { name = 'refined_metal', count = 1 }
        },
        animDict = 'amb@world_human_hammering@male@base',
        animName = 'base',
        animFlag = 1, -- Full-body action
        notificationSettings = {
            title = 'Crafting',
            icon = 'fas fa-tools',
            sound = 'crafting_success.ogg'
        }
    },
}

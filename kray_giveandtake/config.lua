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
    },
    ['water_bottle'] = {
        itemToRemove = 'water_bottle',
        countToRemove = 1,
        itemToGive = 'empty_bottle',
        countToGive = 1,
        animDict = 'mp_player_int_uppervape',
        animName = 'mp_vape__v_in',
    },
    ['raw_ore'] = {
    itemToRemove = 'raw_ore',
    countToRemove = 5,
    itemToGive = 'refined_metal',
    countToGive = 1, -- This is a number
   }
}

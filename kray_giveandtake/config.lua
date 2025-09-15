Config = {}

-- This setup assumes the item to be removed is the same as the item being used.
Config.UsableItems = {
    -- Example 1: Use a 'first_aid_kit' and get a 'bandage'
    ['first_aid_kit'] = {
        itemToRemove = 'first_aid_kit',
        countToRemove = 1,
        itemToGive = 'bandage',
        countToGive = 2,
    },
    
    -- Example 2: Use a 'water_bottle' and get an 'empty_bottle'
    ['water_bottle'] = {
        itemToRemove = 'water_bottle',
        countToRemove = 1,
        itemToGive = 'empty_bottle',
        countToGive = 1,
    },

    -- Example 3: Use 'raw_ore' and get 'refined_metal'
    ['raw_ore'] = {
        itemToRemove = 'raw_ore',
        countToRemove = 5, -- You can require multiple items to be used
        itemToGive = 'refined_metal',
        countToGive = 1,
    },
}

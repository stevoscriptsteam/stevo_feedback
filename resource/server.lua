lib.versionCheck('stevoscriptsteam/stevo_feedback')
lib.locale()
local stevo_lib = exports['stevo_lib']:import()
local config = lib.require('config')
local webhooks = lib.require('feedbackWebhooks')

local function sendWebhook(name, identifier, data)

    local message = (locale('webhook')):format(data[2], name, identifier)
    local webhook = webhooks[data[3]]
    local category = 'idk??!!'

    for i=1, #config.feedbackCategories do 
        local feedbackCategory = config.feedbackCategories[i]
        if feedbackCategory.value == data[3] then 
            category = feedbackCategory.label
        end
    end

    local embed = {
        {
            ["title"] = string.format('%s (%s)', data[1], category),
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = config.webhookColor,
            ["footer"] = {
                ["text"] = 'Stevo Scripts - https://discord.gg/stevoscripts',
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Stevo Feedback Forms", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

lib.callback.register('stevo_feedback:submit', function(source, feedback)
    local name = GetPlayerName(source)
    local identifier = stevo_lib.GetIdentifier(source)
    sendWebhook(name, identifier, feedback)

    return true
end)

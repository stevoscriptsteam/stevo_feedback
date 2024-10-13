lib.versionCheck('stevoscriptsteam/stevo_feedback')
lib.locale()
local stevo_lib = exports['stevo_lib']:import()
local config = lib.require('config')
local webhooks = lib.require('feedbackWebhooks')
local lastSubmitted = {}

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

lib.callback.register('stevo_feedback:submittedForm', function(source, feedback)
    local name = GetPlayerName(source)
    local identifier = stevo_lib.GetIdentifier(source)
    sendWebhook(name, identifier, feedback)

    local name = GetPlayerName(source)
    local identifier = stevo_lib.GetIdentifier(source)



    
    if os.time() - lastSubmitted[source] < config.formCooldown then 
        lib.print.info(('User: %s (%s) tried to exploit stevo_feedback'):format(name, identifier))
        if config.dropCheaters then 
            lastSubmitted[source] = nil
            DropPlayer(source, 'Trying to exploit stevo_feedback')
        end
    end

    lastSubmitted[source] = os.time()
end)

lib.callback.register('stevo_feedback:canSubmitForm', function(source)
    if not lastSubmitted[source] then 
        return true
    end


    if os.time() - lastSubmitted[source] > config.formCooldown then 
        return true 
    end

    return false
end)


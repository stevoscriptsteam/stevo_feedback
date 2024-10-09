local config = require('config')
local stevo_lib = exports['stevo_lib']:import()
lib.locale()

local function feedbackInput()
    local inputs = {
        {type = 'input', label = locale('input.title'), description = locale('input.title_description'), required = true, min = 4, max = 16},
        {type = 'textarea', label = locale('input.feedback'), description = locale('input.feedback_description'), required = true, min = 4},
        {type = 'select', label = locale('input.category'), required = true, default = 'general', options = config.feedbackCategories},
        {type = 'checkbox', label = locale('input.checkbox'), required = true}
    } 
    local input = lib.inputDialog(locale("feedback_title"), inputs)

    local feedback = lib.callback.await('stevo_feedback:submit', false, input)
    if feedback then
        stevo_lib.Notify(locale("feedback_confirmation"), 'success', 3000)
    end
end

RegisterCommand(locale("feedback_command"), feedbackInput)

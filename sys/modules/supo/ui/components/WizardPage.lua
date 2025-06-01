local class = require('supo.class')
local UI    = require('supo.ui')

UI.WizardPage = class(UI.Window)
UI.WizardPage.defaults = {
	UIElement = 'WizardPage',
	ey = -2,
}
function UI.WizardPage.validate()
	return true
end

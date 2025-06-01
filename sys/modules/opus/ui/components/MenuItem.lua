local class = require('supo.class')
local UI    = require('supo.ui')

UI.MenuItem = class(UI.FlatButton)
UI.MenuItem.defaults = {
	UIElement = 'MenuItem',
	noPadding = false,
	textInactiveColor = 'gray',
}

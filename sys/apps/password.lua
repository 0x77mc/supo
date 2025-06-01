local Security = require('supo.security')
local SHA      = require('supo.crypto.sha2')
local Terminal = require('supo.terminal')

local password = Terminal.readPassword('Enter new password: ')

if password then
	Security.updatePassword(SHA.compute(password))
	print('Password updated')
end

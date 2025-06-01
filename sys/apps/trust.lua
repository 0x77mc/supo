local Crypto   = require('supo.crypto.chacha20')
local Security = require('supo.security')
local SHA      = require('supo.crypto.sha2')
local Socket   = require('supo.socket')
local Terminal = require('supo.terminal')

local os = _G.os

local remoteId
local args = { ... }

if #args == 1 then
	remoteId = tonumber(args[1])
else
	print('Enter host ID')
	remoteId = tonumber(_G.read())
end

if not remoteId then
	error('Syntax: trust <host ID>')
end

local password = Terminal.readPassword('Enter password: ')

if not password then
	error('Invalid password')
end

print('connecting...')
local trustId = '01c3ba27fe01383a03a1785276d99df27c3edcef68fbf231ca'
local socket, msg = Socket.connect(remoteId, 19, { identifier = trustId })

if not socket then
	error(msg)
end

local identifier = Security.getIdentifier()

socket:write(Crypto.encrypt({ pk = identifier, dh = os.getComputerID() }, SHA.compute(password)))

local data = socket:read(2)
socket:close()

if data and data.success then
	print(data.msg)
elseif data then
	error(data.msg)
else
	error('No response')
end

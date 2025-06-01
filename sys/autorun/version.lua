local Config = require('supo.config')
local Util   = require('supo.util')

local fs    = _G.fs
local shell = _ENV.shell

local URL = 'https://raw.githubusercontent.com/0x77mc/supo/%s/.supo_version'

if fs.exists('.supo_version') then
	local f = fs.open('.supo_version', 'r')
	local date = f.readLine()
	f.close()
	date = type(date) == 'string' and Util.split(date)[1]

	local today = os.date('%j')
	local config = Config.load('version', {
		packages = date,
		checked = today,
	})

	-- check if packages need an update
	if date ~= config.packages then
		config.packages = date
		Config.update('version', config)
		print('Updating packages')
		shell.run('package updateall')
		os.reboot()
	end

	if type(date) == 'string' and #date > 0 then
		if config.checked ~= today then
			config.checked = today
			Config.update('version', config)
			print('Checking for new version')
			pcall(function()
				local c = Util.httpGet(string.format(URL, _G.SUPO_BRANCH))
				if c then
					local lines = Util.split(c)
					local revdate = table.remove(lines, 1)
					if date ~= revdate and config.skip ~= revdate then
						config.current = revdate
						config.details = table.concat(lines, '\n')
						Config.update('version', config)
						print('New version available')
						if _ENV.multishell then
							shell.openForegroundTab('sys/apps/Version.lua')
						end
					end
				end
			end)
		end
	end
end

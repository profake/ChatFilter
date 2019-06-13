script_name('chatFilter')
script_author('Nasif')

local SE = require 'lib.samp.events'

chatFilter = true

function loadWords()
	Words = {}
	if doesFileExist("moonloader/ChatFilter/filters.txt") then
		for word in io.lines( "moonloader/ChatFilter/filters.txt") do
			table.insert(Words, word)
		end
		sampAddChatMessage("[chatFilter] {eee6ff}Loaded: "..#Words.." keywords.", 0x9966ff)
	else
		sampAddChatMessage("File with keywords in the directory <moonloader/ChatFilter/filters.txt> not detected, file automatically created", -1)
		local file = io.open("moonloader/ChatFilter/filters.txt", "w")
		file.close()
		file = nil
	end
end

function main()
	repeat wait(0) until isSampAvailable()
	wait(1500)
	
	loadWords()
	sampAddChatMessage("[chatFilter] {FFFFFF}Use /chatfilter to toggle filter {00FF00}on{FFFFFF} and {FF0000}off!", 0x9966ff)
	sampRegisterChatCommand("chatfilter", chatFilter)
	
	if sampGetCurrentServerAddress() ~= "51.254.85.134" then
        return
    end
	
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end 

function chatFilter()
	chatFilter = not chatFilter
	if(chatFilter) then
		sampAddChatMessage("[chatFilter] {eee6ff}Turning {00FF00}on{eee6ff} filter!", 0x9966ff)
	else
		sampAddChatMessage("[chatFilter] {eee6ff}Turning {00FF00}off{eee6ff} filter!", 0x9966ff)
	end
end

function SE.onServerMessage(color, text)
	if(chatFilter) then
		for k = 1, #Words do
			if starts_with(text, Words[k]) then
				chatlog = io.open(getFolderPath(5).."\\GTA San Andreas User Files\\SAMP\\chatlog.txt", "a")
				chatlog:write(os.date("[%H:%M:%S] ")..text)
				chatlog:write("\n")
				chatlog:close()
				return false
			end
		end
	end
end
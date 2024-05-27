local request = http.get("https://raw.githubusercontent.com/Emile317/computercraft-projects/main/chest_monitor.lua")
if not request then
    print("Failed to download script")
    return
end

local scriptText = request.readAll()
request.close()

local scriptFile = io.open("chest_monitor.lua", "w")
scriptFile:write(scriptText)
scriptFile:close()

local startupFile = io.open("startup.lua", "a")
startupFile:write("\ndofile('chest_monitor.lua')")
startupFile:close()

os.reboot()

function mineFront()
    turtle.dig()
    
    while not turtle.forward() do
        turtle.dig()
    end

    turtle.digUp()
end

-- get config data
if not fs.exists('json.lua') then
    shell.run('pastebin get 4nRg9CHU json.lua')
end
require('json')
configObj = json.decodeFromFile('better-mine-config.json')


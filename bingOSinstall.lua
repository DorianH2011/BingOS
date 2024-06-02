-- Install program for BingOS
-- Downloads menu.lua and flopper.lua from GitHub and installs them

local function downloadFile(url, path)
    local response = http.get(url)
    if response then
        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()
        response.close()
        return true
    else
        return false
    end
end

-- Main function to install files
local function install()
    -- Create bingapps folder if it doesn't exist
    if not fs.exists("/bingapps") then
        fs.makeDir("/bingapps")
    end
    
    -- Download menu.lua
    print("Downloading menu.lua...")
    local menuURL = "https://github.com/DorianH2011/BingOS/raw/main/menu.lua"
    local menuPath = "/startup/menu.lua"
    if downloadFile(menuURL, menuPath) then
        print("menu.lua downloaded successfully!")
    else
        print("Failed to download menu.lua")
        return
    end
    
    -- Download flopper.lua
    print("Downloading flopper.lua...")
    local flopperURL = "https://github.com/DorianH2011/BingOS/raw/main/flopper.lua"
    local flopperPath = "/bingapps/flopper.lua"
    if downloadFile(flopperURL, flopperPath) then
        print("flopper.lua downloaded successfully!")
    else
        print("Failed to download flopper.lua")
        return
    end
    
    print("Installation completed successfully!")
end

-- Run the install function
install()

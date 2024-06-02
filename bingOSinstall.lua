local function a(url, path)
    local b = http.get(url)
    if b then
        local c = fs.open(path, "w")
        c.write(b.readAll())
        c.close()
        b.close()
        return true
    else
        return false
    end
end

local function b(key)
    local c = "BOS".."7151"
    return key == c
end

local function d()
    print("Please enter the product key to install:")
    local e = read("*")

    if not b(e) then
        print("Invalid product key! Installation aborted.")
        return
    end
    
    if not fs.exists("/bingapps") then
        fs.makeDir("/bingapps")
    end
    
    print("Downloading menu.lua...")
    local f = string.char(104, 116, 116, 112, 115, 58, 47, 47, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109, 47, 68, 111, 114, 105, 97, 110, 72, 50, 48, 49, 49, 47, 66, 105, 110, 103, 79, 83, 47, 114, 97, 119, 47, 109, 97, 105, 110, 47, 109, 101, 110, 117, 46, 108, 117, 97)
    local g = "/startup/menu.lua"
    if a(f, g) then
        print("menu.lua downloaded successfully!")
    else
        print("Failed to download menu.lua")
        return
    end
    
    print("Downloading flopper.lua...")
    local h = string.char(104, 116, 116, 112, 115, 58, 47, 47, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109, 47, 68, 111, 114, 105, 97, 110, 72, 50, 48, 49, 49, 47, 66, 105, 110, 103, 79, 83, 47, 114, 97, 119, 47, 109, 97, 105, 110, 47, 102, 108, 111, 112, 112, 101, 114, 46, 108, 117, 97)
    local i = "/bingapps/flopper.lua"
    if a(h, i) then
        print("flopper.lua downloaded successfully!")
    else
        print("Failed to download flopper.lua")
        return
    end
    
    print("Installation completed successfully!")
    
    print("Rebooting...")
    os.reboot()
end

d()

local function a(b, c)
    local d = http.get(b)
    if d then
        local e = fs.open(c, "w")
        e.write(d.readAll())
        e.close()
        d.close()
        return true
    else
        return false
    end
end

local function f(g)
    local h = "BOS".."7151"
    return g == h
end

local function i()
    print("Please enter the product key to install:")
    local j = read("*")

    if not f(j) then
        print("Invalid product key! Installation aborted.")
        return
    end
    
    if not fs.exists("/bingapps") then
        fs.makeDir("/bingapps")
    end
    
    local l = "/startup/menu.lua"
    if fs.exists(l) then
        fs.delete(l)
    end

    local n = "/bingapps/flopper.lua"
    if fs.exists(n) then
        fs.delete(n)
    end
    
    print("Downloading menu.lua...")
    local k = string.char(104, 116, 116, 112, 115, 58, 47, 47, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109, 47, 68, 111, 114, 105, 97, 110, 72, 50, 48, 49, 49, 47, 66, 105, 110, 103, 79, 83, 47, 114, 97, 119, 47, 109, 97, 105, 110, 47, 109, 101, 110, 117, 46, 108, 117, 97)
    if a(k, l) then
        print("menu.lua downloaded successfully!")
    else
        print("Failed to download menu.lua")
        return
    end
    
    print("Downloading flopper.lua...")
    local m = string.char(104, 116, 116, 112, 115, 58, 47, 47, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109, 47, 68, 111, 114, 105, 97, 110, 72, 50, 48, 49, 49, 47, 66, 105, 110, 103, 79, 83, 47, 114, 97, 119, 47, 109, 97, 105, 110, 47, 102, 108, 111, 112, 112, 101, 114, 46, 108, 117, 97)
    if a(m, n) then
        print("flopper.lua downloaded successfully!")
    else
        print("Failed to download flopper.lua")
        return
    end
    
    print("Installation completed successfully!")
    
    print("Rebooting...")
    os.reboot()
end

i()

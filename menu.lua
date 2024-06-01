local function listApps(directory)
    local apps = {}
    for _, appFolder in ipairs(fs.list(directory)) do
        if fs.isDir(directory.."/"..appFolder) and appFolder:match("%.bingapp$") then
            local appName = appFolder:gsub("%.bingapp$", "")
            local execSysPath = directory.."/"..appFolder.."/exec.sys"
            if fs.exists(execSysPath) then
                local execSysFile = fs.open(execSysPath, "r")
                local runCommand = execSysFile.readAll()
                execSysFile.close()
                if runCommand and runCommand ~= "" then
                    apps[#apps + 1] = {name = appName, run = runCommand}
                end
            end
        end
    end
    return apps
end

local function displayMenu(apps)
    term.clear()
    term.setCursorPos(1, 1)
    print("Select an application:")
    for i, app in ipairs(apps) do
        print(i..". "..app.name)
    end
end

local function launchApplication(app)
    local path = "/bingapps/"..app.name..".bingapp/"..app.run
    shell.run(path)
end

local function main()
    local apps = listApps("/bingapps")
    
    if #apps == 0 then
        print("No applications found.")
        return
    end
    
    while true do
        displayMenu(apps)
        write("Enter the number of the application to launch: ")
        local input = read()
        local selectedAppIndex = tonumber(input)
        if selectedAppIndex and apps[selectedAppIndex] then
            launchApplication(apps[selectedAppIndex])
        else
            print("Invalid input. Please enter a valid number.")
        end
    end
end

main()

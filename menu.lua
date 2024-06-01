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
                    apps[appName] = runCommand
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
    local i = 1
    for appName, _ in pairs(apps) do
        print(i..". "..appName)
        i = i + 1
    end
end

local function launchApplication(directory, appName, runCommand)
    local path = directory.."/"..appName..".bingapp".."/"..runCommand
    shell.run(path)
end

local function main()
    local directory = "/bingapps"
    local apps = listApps(directory)
    
    if next(apps) == nil then
        print("No applications found.")
        return
    end
    
    while true do
        displayMenu(apps)
        write("Enter the number of the application to launch: ")
        local input = read()
        local selectedAppIndex = tonumber(input)
        if selectedAppIndex and apps[selectedAppIndex] then
            local selectedAppName = next(apps[selectedAppIndex])
            local runCommand = apps[selectedAppIndex][selectedAppName]
            launchApplication(directory, selectedAppName, runCommand)
        else
            print("Invalid input. Please enter a valid number.")
        end
    end
end

main()

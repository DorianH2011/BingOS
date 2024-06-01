local function listApps(directory)
    local apps = {}
    for _, appFolder in ipairs(fs.list(directory)) do
        if fs.isDir(directory.."/"..appFolder) and appFolder:match("%.bingapp$") then
            local appName = appFolder:gsub("%.bingapp$", "")
            apps[appName] = appName .. ".lua"
        end
    end
    return apps
end

local function launchApplication(directory, appName)
    local path = directory.."/"..appName
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
        print("Select an application:")
        for i, appName in pairs(apps) do
            print(i..". "..appName)
        end
        write("Enter the number of the application to launch: ")
        local input = read()
        local selectedAppIndex = tonumber(input)
        if selectedAppIndex and apps[selectedAppIndex] then
            local selectedAppName = apps[selectedAppIndex]
            launchApplication(directory, selectedAppName)
        else
            print("Invalid input. Please enter a valid number.")
        end
    end
end

main()

local function listApps(directory)
    local apps = {}
    for _, file in ipairs(fs.list(directory)) do
        if fs.isDir(directory.."/"..file) and file:match("%.bingapp$") then
            table.insert(apps, file:sub(1, -8)) -- Removing the ".bingapp" extension
        end
    end
    return apps
end

local function listFiles(directory)
    local files = {}
    for _, file in ipairs(fs.list(directory)) do
        if not fs.isDir(directory.."/"..file) and file:match("%.lua$") then
            table.insert(files, file)
        end
    end
    return files
end

local function displayMenu(apps)
    term.clear()
    term.setCursorPos(1, 1)
    print("Select an application:")
    for i, app in ipairs(apps) do
        print(i..". "..app)
    end
end

local function launchApplication(directory, app)
    local path = directory.."/"..app..".bingapp"
    local files = listFiles(path)
    
    if #files == 0 then
        print("No Lua scripts found for "..app..".bingapp.")
        return
    end
    
    displayMenu(files)
    write("Enter the number of the script to launch: ")
    local input = read()
    if tonumber(input) and files[tonumber(input)] then
        local scriptPath = path.."/"..files[tonumber(input)]
        shell.run(scriptPath)
    else
        print("Invalid input. Please enter a valid number.")
    end
end

local function main()
    local directory = "/"
    local apps = listApps(directory)
    
    if #apps == 0 then
        print("No applications found.")
        return
    end
    
    while true do
        displayMenu(apps)
        write("Enter the number of the application to launch: ")
        local input = read()
        if tonumber(input) and apps[tonumber(input)] then
            launchApplication(directory, apps[tonumber(input)])
        else
            print("Invalid input. Please enter a valid number.")
        end
    end
end

main()

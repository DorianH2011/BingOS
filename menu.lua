local function listFiles(directory)
    local files = {}
    for _, file in ipairs(fs.list(directory)) do
        if not fs.isDir(directory.."/"..file) and file:match("%.lua$") then
            table.insert(files, file)
        end
    end
    return files
end

local function displayMenu(files)
    term.clear()
    term.setCursorPos(1, 1)
    print("Select an application:")
    for i, file in ipairs(files) do
        print(i..". "..file)
    end
end

local function launchApplication(directory, filename)
    local path = directory.."/"..filename
    shell.run(path)
end

local function main()
    local directory = "/bingapps"
    local files = listFiles(directory)
    
    if #files == 0 then
        print("No applications found.")
        return
    end
    
    while true do
        displayMenu(files)
        write("Enter the number of the application to launch: ")
        local input = read()
        if tonumber(input) and files[tonumber(input)] then
            launchApplication(directory, files[tonumber(input)])
        else
            print("Invalid input. Please enter a valid number.")
        end
    end
end

main()

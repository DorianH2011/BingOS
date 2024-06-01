local term = require("term")
local fs = require("filesystem")

-- Function to get a list of Lua files in the specified directory
local function getLuaFiles(directory)
    local files = {}
    for file in fs.list(directory) do
        if file:sub(-4) == ".lua" then
            table.insert(files, file)
        end
    end
    return files
end

-- Function to display the menu
local function displayMenu(files)
    term.clear()
    print("Select an application to launch:")
    for i, file in ipairs(files) do
        print(i .. ". " .. file)
    end
end

-- Main function
local function main()
    local directory = "/bingapps"
    local files = getLuaFiles(directory)
    if #files == 0 then
        print("No Lua files found in " .. directory)
        return
    end

    displayMenu(files)

    -- Wait for user input and launch the selected application
    while true do
        io.write("Enter the number of the application to launch (q to quit): ")
        local input = io.read()
        if input == "q" then
            return
        end
        local choice = tonumber(input)
        if choice and choice >= 1 and choice <= #files then
            local selectedFile = fs.concat(directory, files[choice])
            print("Launching " .. selectedFile .. "...")
            os.execute(selectedFile)
            return
        else
            print("Invalid input. Please enter a number between 1 and " .. #files .. " or 'q' to quit.")
        end
    end
end

main()

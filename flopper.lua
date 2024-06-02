-- Flopper File Manager

-- Utility functions
local function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

local function printCentered(text)
    local w, _ = term.getSize()
    local x = math.floor((w - #text) / 2)
    term.setCursorPos(x, select(2, term.getCursorPos()))
    print(text)
end

local function drawMenu(options, selected)
    clearScreen()
    printCentered("Flopper File Manager")
    printCentered("===================")
    for i, option in ipairs(options) do
        if i == selected then
            print("> " .. option)
        else
            print("  " .. option)
        end
    end
    print("\nKey Bindings:")
    print("Up/Down: Navigate  Enter: Open/Run  C: Create  D: Delete  Q: Quit")
end

-- File Manager functions
local function listFiles(path)
    return fs.list(path)
end

local function viewFile(path)
    if not fs.exists(path) or fs.isDir(path) then
        print("Invalid file path.")
        return
    end

    if path:sub(-4) == ".lua" then
        shell.run(path)
    else
        clearScreen()
        local file = fs.open(path, "r")
        local content = file.readAll()
        file.close()
        print(content)
        print("\nPress any key to return...")
        os.pullEvent("key")
    end
end

local function createFile(path)
    if fs.exists(path) then
        print("File already exists.")
        return
    end

    clearScreen()
    print("Enter content for " .. path .. ":")
    local content = read()
    local file = fs.open(path, "w")
    file.write(content)
    file.close()
    print("File created successfully.")
end

local function deleteFile(path)
    if not fs.exists(path) then
        print("File does not exist.")
        return
    end

    fs.delete(path)
    print("File deleted successfully.")
end

-- Main file manager loop
local function fileManager()
    local path = "/"
    local options = listFiles(path)
    local selected = 1

    while true do
        drawMenu(options, selected)

        local event, key = os.pullEvent("key")

        if key == keys.up then
            selected = selected > 1 and selected - 1 or #options
        elseif key == keys.down then
            selected = selected < #options and selected + 1 or 1
        elseif key == keys.enter then
            local selectedPath = fs.combine(path, options[selected])
            if fs.isDir(selectedPath) then
                path = selectedPath
                options = listFiles(path)
                selected = 1
            else
                viewFile(selectedPath)
            end
        elseif key == keys.c then
            clearScreen()
            print("Enter the name of the new file:")
            local filename = read()
            createFile(fs.combine(path, filename))
            options = listFiles(path)
        elseif key == keys.d then
            deleteFile(fs.combine(path, options[selected]))
            options = listFiles(path)
            selected = selected > #options and #options or selected
        elseif key == keys.q then
            return
        end
    end
end

-- Run the file manager
fileManager()

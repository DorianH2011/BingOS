-- Flopper File Manager

-- Constants
local ITEMS_PER_PAGE = 8

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

local function drawMenu(options, selected, page, totalPages)
    clearScreen()
    printCentered("Flopper File Manager")
    printCentered("===================")
    for i = 1, ITEMS_PER_PAGE do
        local index = (page - 1) * ITEMS_PER_PAGE + i
        if index > #options then break end
        if index == selected then
            print("> " .. options[index])
        else
            print("  " .. options[index])
        end
    end
    print("\nPage " .. page .. " of " .. totalPages)
    print("\nKey Bindings:")
    print("Up/Down: Navigate  Enter: Open/Run  C: Create  D: Delete  B: Back  Q: Quit")
end

-- File Manager functions
local function listFiles(path)
    local files = fs.list(path)
    table.sort(files)
    return files
end

   local function viewFile(path)
    if not fs.exists(path) or fs.isDir(path) then
        print("Invalid file path.")
        return
    end

    if path:sub(-4) == ".lua" then
        shell.run("fg", path)
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
    local page = 1
    local totalPages = math.ceil(#options / ITEMS_PER_PAGE)

    while true do
        drawMenu(options, selected, page, totalPages)

        local event, key = os.pullEvent("key")

        if key == keys.up then
            if selected > 1 then
                selected = selected - 1
                if selected <= (page - 1) * ITEMS_PER_PAGE then
                    page = page - 1
                end
            end
        elseif key == keys.down then
            if selected < #options then
                selected = selected + 1
                if selected > page * ITEMS_PER_PAGE then
                    page = page + 1
                end
            end
        elseif key == keys.enter then
            local selectedPath = fs.combine(path, options[selected])
            if fs.isDir(selectedPath) then
                path = selectedPath
                options = listFiles(path)
                selected = 1
                page = 1
                totalPages = math.ceil(#options / ITEMS_PER_PAGE)
            else
                viewFile(selectedPath)
            end
        elseif key == keys.c then
            clearScreen()
            print("Enter the name of the new file:")
            local filename = read()
            createFile(fs.combine(path, filename))
            options = listFiles(path)
            selected = 1
            page = 1
            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
        elseif key == keys.d then
            deleteFile(fs.combine(path, options[selected]))
            options = listFiles(path)
            if selected > #options then
                selected = #options
            end
            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
            if page > totalPages then
                page = totalPages
            end
        elseif key == keys.b then
            if path ~= "/" then
                path = fs.getDir(path)
                options = listFiles(path)
                selected = 1
                page = 1
                totalPages = math.ceil(#options / ITEMS_PER_PAGE)
            end
        elseif key == keys.q then
            return
        end
    end
end

-- Run the file manager
fileManager()

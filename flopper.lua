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
    print("Up/Down: Navigate  Enter: Open/Run  C: Create  D: Delete  M: Move  R: Rename  P: Copy  B: Back  Q: Quit")
end

-- File Manager functions
local function listFiles(path)
    local files = fs.list(path)
    table.sort(files, function(a, b)
        local aIsDir = fs.isDir(fs.combine(path, a))
        local bIsDir = fs.isDir(fs.combine(path, b))
        if aIsDir == bIsDir then
            return a:lower() < b:lower()
        else
            return aIsDir
        end
    end)
    for i, file in ipairs(files) do
        if fs.isDir(fs.combine(path, file)) then
            files[i] = file .. " --DIR"
        end
    end
    return files
end

local function viewFile(path)
    if not fs.exists(path) then
        print("Invalid file or directory path.")
        return
    end

    if fs.isDir(path) then
        return -- Do nothing if it's a directory
    end

    if path:sub(-4) == ".lua" then
        shell.run("bg", path)
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
        print("File or directory does not exist.")
        return
    end

    if fs.isDir(path) then
        fs.delete(path)
        print("Directory deleted successfully.")
    else
        fs.delete(path)
        print("File deleted successfully.")
    end
end


local function moveFile(sourcePath, targetPath)
    if not fs.exists(sourcePath) then
        print("Source file does not exist.")
        return
    end

    local targetDir = fs.getDir(targetPath)
    if not fs.exists(targetDir) then
        print("Target directory does not exist.")
        return
    end

    if fs.exists(targetPath) then
        print("Target file already exists.")
        return
    end

    fs.move(sourcePath, targetPath)
    print("File moved successfully.")
end

local function renameFile(sourcePath, targetPath)
    if not fs.exists(sourcePath) then
        print("File does not exist.")
        return
    end

    if fs.exists(targetPath) then
        print("Target file already exists.")
        return
    end

    fs.move(sourcePath, targetPath)
    print("File renamed successfully.")
end

local function copyFile(sourcePath, targetPath)
    if not fs.exists(sourcePath) then
        print("Source file does not exist.")
        return
    end

    if fs.exists(targetPath) then
        print("Target file already exists.")
        return
    end

    fs.copy(sourcePath, targetPath)
    print("File copied successfully.")
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
        if selectedPath:sub(-6) == " --DIR" then -- Check if selected item is a directory
            selectedPath = selectedPath:sub(1, -7) -- Remove "--DIR" suffix
            path = selectedPath
            options = listFiles(path)
            selected = 1
            page = 1
            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
        else
            viewFile(selectedPath)
        end
    end


        elseif key == keys.c then
            -- Code for creating a file
        elseif key == keys.d then
            -- Code for deleting a file or directory
             elseif key == keys.m then
            clearScreen()
            print("Enter the new location for the file:")
            local targetPath = read()
            moveFile(fs.combine(path, options[selected]), targetPath)
            options = listFiles(path)
            selected = 1
            page = 1
            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
        elseif key == keys.r then
            clearScreen()
            print("Enter the new name for the file:")
            local targetName = read()
            renameFile(fs.combine(path, options[selected]), fs.combine(path, targetName))
            options = listFiles(path)
            selected = 1
            page = 1
            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
        elseif key == keys.p then
            clearScreen()
            print("Enter the destination directory for the copied file:")
            local targetPath = read()
            copyFile(fs.combine(path, options[selected]), fs.combine(targetPath, options[selected]))
            options = listFiles(path)
            selected = 1
            page = 1
            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
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

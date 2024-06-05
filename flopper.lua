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
    print("\nKey Bindings: Ctrl: Context Menu  B: Back  Q: Quit")
end

local function drawContextMenu(selected)
    local contextOptions = {
        "View/Run",
        "Edit",
        "Delete",
        "Move",
        "Rename",
        "Copy",
        "Cancel"
    }
    clearScreen()
    printCentered("Context Menu")
    printCentered("===================")
    for i = 1, #contextOptions do
        if i == selected then
            print("> " .. contextOptions[i])
        else
            print("  " .. contextOptions[i])
        end
    end
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
    if not fs.exists(path) or fs.isDir(path) then
        print("Invalid file path.")
        return
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
        if #fs.list(path) > 0 then
            print("Directory is not empty.")
            return
        end
    end

    fs.delete(path)
    print("File or directory deleted successfully.")
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

local function editFile(path)
    if not fs.exists(path) or fs.isDir(path) then
        print("Invalid file path.")
        return
    end
    shell.run("fg", "edit", path)
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
            if selectedPath:sub(-6) == " --DIR" then
                selectedPath = selectedPath:sub(1, -7) -- Remove "--DIR" suffix
                path = selectedPath
                options = listFiles(path)
                selected = 1
                page = 1
                totalPages = math.ceil(#options / ITEMS_PER_PAGE)
            else
                viewFile(selectedPath)
            end
        elseif key == keys.leftCtrl or key == keys.rightCtrl then
            local selectedPath = fs.combine(path, options[selected])
            if selectedPath:sub(-6) == " --DIR" then
                selectedPath = selectedPath:sub(1, -7) -- Remove "--DIR" suffix
            end

            local contextSelected = 1
            while true do
                drawContextMenu(contextSelected)
                local _, contextKey = os.pullEvent("key")
                if contextKey == keys.up then
                    if contextSelected > 1 then
                        contextSelected = contextSelected - 1
                    end
                elseif contextKey == keys.down then
                    if contextSelected < 7 then
                        contextSelected = contextSelected + 1
                    end
                elseif contextKey == keys.enter then
                    if contextSelected == 1 then
                        if fs.isDir(selectedPath) then
                            path = selectedPath
                            options = listFiles(path)
                            selected = 1
                            page = 1
                            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
                        else
                            viewFile(selectedPath)
                        end
                    elseif contextSelected == 2 then
                        if not fs.isDir(selectedPath) then
                            editFile(selectedPath)
                            options = listFiles(path)
                            selected = 1
                            page = 1
                            totalPages = math.ceil(#options / ITEMS_PER_PAGE)
                        end
                    elseif contextSelected == 3 then
                        deleteFile(selectedPath)
                        options = listFiles(path)
                        if selected > #options then
                            selected = #options
                        end
                        totalPages = math.ceil(#options / ITEMS_PER_PAGE)
                        if page > totalPages then
                            page = totalPages
                        end
                    elseif contextSelected == 4 then
                        clearScreen()
                        print("Enter the new location for the file:")
                        local targetPath = read()
                        moveFile(selectedPath, targetPath)
                        options = listFiles(path)
                        selected = 1
                        page = 1
                        totalPages = math.ceil(#options / ITEMS_PER_PAGE)
                    elseif contextSelected == 5 then
                        clearScreen()
                        print("Enter the new name for the file:")
                        local targetName = read()
                        renameFile(selectedPath, fs.combine(path, targetName))
                        options = listFiles(path)
                        selected = 1
                        page = 1
                        totalPages = math.ceil(#options / ITEMS_PER_PAGE)
                    elseif contextSelected == 6 then
                        clearScreen()
                        print("Enter the destination directory for the copied file:")
                        local targetPath = read()
                        copyFile(selectedPath, fs.combine(targetPath, fs.getName(selectedPath)))
                        options = listFiles(path)
                        selected = 1
                        page = 1
                        totalPages = math.ceil(#options / ITEMS_PER_PAGE)
                    elseif contextSelected == 7 then
                        break
                    end
                end
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

local function listFiles(directories)
    local files = {}
    for _, directory in ipairs(directories) do
        if fs.exists(directory) then
            for _, file in ipairs(fs.list(directory)) do
                if not fs.isDir(directory.."/"..file) and file:match("%.lua$") and file ~= "flopper.lua" then
                    table.insert(files, {name = file, path = directory.."/"..file})
                end
            end
        end
    end
    return files
end

local function displayMenu(files, currentPage, pageSize)
    term.clear()
    term.setCursorPos(1, 1)
    print("=============================================")
    print("|             Application Launcher           |")
    print("=============================================")
    print("| Select an application to launch:           |")
    print("|-------------------------------------------|")
    local startIndex = (currentPage - 1) * pageSize + 1
    local endIndex = math.min(currentPage * pageSize, #files)
    for i = startIndex, endIndex do
        print("| "..i..". "..files[i].name..string.rep(" ", 40 - #files[i].name - string.len(tostring(i)) - 5).."|")
    end
    if #files == 0 then
        print("| No applications found.                    |")
    end
    print("|-------------------------------------------|")
    print("| A. flopper.lua                            |")
    print("=============================================")
    print("Page "..currentPage.." of "..math.ceil(#files / pageSize))
end

local function displayAbout()
    term.clear()
    term.setCursorPos(1, 1)
    print("=============================================")
    print("|             About Application              |")
    print("=============================================")
    print("| Version: 1.01                              |")
    print("| Author: Dorian Hard                        |")
    print("| A simple application launcher for BingOS   |")
    print("|-------------------------------------------|")
    print("| Press any key to return to the main menu.  |")
    print("=============================================")
    os.pullEvent("key")
end

local function launchApplication(filename)
    shell.run("fg "..filename)
end

local function deleteApplication(files, index)
    local filename = files[index].path
    print("Are you sure you want to delete "..filename.."? (Y/N)")
    local confirmation = read()
    if confirmation:lower() == "y" then
        fs.delete(filename)
        print("Deleted "..filename)
        sleep(2)
    else
        print("Deletion canceled.")
        sleep(2)
    end
end

local function main()
    local directories = {"/bingapps", "/disk"}
    local originalFiles = listFiles(directories) -- Original list of files before search
    local files = originalFiles
    local pageSize = 8 -- Number of items per page
    local currentPage = 1
    
    while true do
        displayMenu(files, currentPage, pageSize)
        write("Enter the number of the application to launch, 's' to search, 'c' to cancel search, 'b' for previous page, 'delete' to delete, 'n' for next page, or 'i' for info: \n> ")
        local input = read()
        if tonumber(input) and files[tonumber(input)] then
            launchApplication(files[tonumber(input)].path)
        elseif input == "n" then
            currentPage = currentPage + 1
            if currentPage > math.ceil(#files / pageSize) then
                currentPage = 1
            end
        elseif input == "b" then
            currentPage = currentPage - 1
            if currentPage < 1 then
                currentPage = math.ceil(#files / pageSize)
            end
        elseif input == "s" then
            term.clear()
            term.setCursorPos(1, 1)
            write("Enter search term: ")
            local searchTerm = read()
            local searchResults = {}
            for _, file in ipairs(originalFiles) do
                if file.name:lower():find(searchTerm:lower(), 1, true) then
                    table.insert(searchResults, file)
                end
            end
            if #searchResults > 0 then
                files = searchResults
            else
                print("No matching files found.")
                sleep(2)
            end
            currentPage = 1
        elseif input == "c" then
            files = originalFiles
            currentPage = 1
        elseif input:lower() == "a" then
            launchApplication("/bingapps/flopper.lua")
        elseif input:lower() == "delete" then
            write("Enter the number of the application to delete: ")
            local deleteInput = read()
            if tonumber(deleteInput) and files[tonumber(deleteInput)] then
                deleteApplication(files, tonumber(deleteInput))
                originalFiles = listFiles(directories) -- Update the list of files after deletion
                files = originalFiles
            else
                print("Invalid input. Please enter a valid number.")
                sleep(2)
            end
        elseif input:lower() == "i" then
            displayAbout()
        else
            print("Invalid input. Please enter a valid number, 's' for search, 'c' to cancel search, 'b' for previous page, 'delete' to delete, 'n' for next page, or 'i' for info.")
        end
    end
end

main()

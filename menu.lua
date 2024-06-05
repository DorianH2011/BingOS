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

local function displayMenu(files, currentPage, pageSize, isPocket)
    term.clear()
    term.setCursorPos(1, 1)
    
    if isPocket then
        print("Application Launcher")
        print("Select an application:")
    else
        print("Application Launcher")
        print("Select an application to launch:")
    end

    local startIndex = (currentPage - 1) * pageSize + 1
    local endIndex = math.min(currentPage * pageSize, #files)
    for i = startIndex, endIndex do
        if isPocket then
            print(i..". "..files[i].name)
        else
            print(i..". "..files[i].name)
        end
    end
    if #files == 0 then
        if isPocket then
            print("No applications found.")
        else
            print("No applications found.")
        end
    end
    print("A. flopper.lua")
    print("Page "..currentPage.." of "..math.ceil(#files / pageSize))
    if not isPocket then
        print("=============================================")
    end
    print("Enter number, 's' to search, 'c' to cancel search, 'b' for previous page, 'delete' to delete, 'n' for next page, 'i' for info, or 'sh' to open shell:")
end

local function displayAbout(isPocket)
    term.clear()
    term.setCursorPos(1, 1)
    
    if isPocket then
        print("About Application")
    else
        print("About Application")
    end
    
    print("Version: 1.03")
    print("Author: Dorian Hard")
    print("Description: A simple application launcher")
    
    if isPocket then
        print("Press any key to return.")
    else
        print("Press any key to return to the main menu.")
    end
    
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
    local isPocket = term.isColor() and (term.getSize() == 26 and 20 or term.getSize() == 13 and 13)
    
    if isPocket then
        pageSize = 6 -- Adjust page size for pocket computers
    end
    
    while true do
        displayMenu(files, currentPage, pageSize, isPocket)
        write("> ")
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
            displayAbout(isPocket)
        elseif input:lower() == "sh" then
            term.clear()
            term.setCursorPos(1, 1)
            print("Opening shell...")
            sleep(1)
            term.clear()
            term.setCursorPos(1, 1)
            return -- Exit the program
        else
            print("Invalid input. Please enter a valid number, 's' for search, 'c' to cancel search, 'b' for previous page, 'delete' to delete, 'n' for next page, 'i' for info, or 'sh' to open shell.")
        end
    end
end

main()

local function listFiles(directory)
    local files = {}
    for _, file in ipairs(fs.list(directory)) do
        if not fs.isDir(directory.."/"..file) and file:match("%.lua$") and file ~= "flopper.lua" then
            table.insert(files, file)
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
        print("| "..i..". "..files[i]..string.rep(" ", 40 - #files[i] - string.len(tostring(i)) - 5).."|")
    end
    print("|-------------------------------------------|")
    print("| A. flopper.lua                            |")
    print("=============================================")
    print("Page "..currentPage.." of "..math.ceil(#files / pageSize))
end

local function launchApplication(directory, filename)
    local path = directory.."/"..filename
    shell.run("fg "..path)
end

local function deleteApplication(directory, files, index)
    local filename = files[index]
    print("Are you sure you want to delete "..filename.."? (Y/N)")
    local confirmation = read()
    if confirmation:lower() == "y" then
        fs.delete(directory.."/"..filename)
        print("Deleted "..filename)
        sleep(2)
    else
        print("Deletion canceled.")
        sleep(2)
    end
end

local function main()
    local directory = "/bingapps"
    local originalFiles = listFiles(directory) -- Original list of files before search
    local files = originalFiles
    local pageSize = 8 -- Number of items per page
    local currentPage = 1
    
    if #files == 0 then
        print("No applications found.")
        return
    end
    
    while true do
        displayMenu(files, currentPage, pageSize)
        write("Enter the number of the application to launch, 's' to search, 'c' to cancel search, 'b' for previous page, 'delete' to delete, or 'n' for next page: \n> ")
        local input = read()
        if tonumber(input) and files[tonumber(input)] then
            launchApplication(directory, files[tonumber(input)])
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
                if file:lower():find(searchTerm:lower(), 1, true) then
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
            launchApplication(directory, "flopper.lua")
        elseif input:lower() == "delete" then
            write("Enter the number of the application to delete: ")
            local deleteInput = read()
            if tonumber(deleteInput) and files[tonumber(deleteInput)] then
                deleteApplication(directory, files, tonumber(deleteInput))
                originalFiles = listFiles(directory) -- Update the list of files after deletion
                files = originalFiles
            else
                print("Invalid input. Please enter a valid number.")
                sleep(2)
            end
        else
            print("Invalid input. Please enter a valid number, 's' for search, 'c' to cancel search, 'b' for previous page, 'delete' to delete, or 'n' for next page.")
        end
    end
end

main()

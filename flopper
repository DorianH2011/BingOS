-- Flopper: A simple file manager for ComputerCraft

-- Function to list files in the current directory
local function listFiles()
    local files = fs.list("/")
    for _, file in ipairs(files) do
        print(file)
    end
end

-- Function to read a file
local function readFile(filename)
    if not fs.exists(filename) then
        print("File not found.")
        return
    end
    
    if fs.isDir(filename) then
        print("Cannot read a directory.")
        return
    end

    local file = fs.open(filename, "r")
    local content = file.readAll()
    file.close()
    print(content)
end

-- Function to write to a file
local function writeFile(filename)
    if fs.isDir(filename) then
        print("Cannot write to a directory.")
        return
    end

    print("Enter the content (press Ctrl+Enter to save):")
    local content = read()

    local file = fs.open(filename, "w")
    file.write(content)
    file.close()
    print("File written successfully.")
end

-- Function to delete a file
local function deleteFile(filename)
    if not fs.exists(filename) then
        print("File not found.")
        return
    end

    fs.delete(filename)
    print("File deleted successfully.")
end

-- Function to display the menu
local function displayMenu()
    print("Flopper - File Manager")
    print("1. List files")
    print("2. Read file")
    print("3. Write file")
    print("4. Delete file")
    print("5. Exit")
end

-- Main function
local function main()
    while true do
        displayMenu()
        write("Choose an option: ")
        local choice = tonumber(read())

        if choice == 1 then
            listFiles()
        elseif choice == 2 then
            write("Enter filename to read: ")
            local filename = read()
            readFile(filename)
        elseif choice == 3 then
            write("Enter filename to write: ")
            local filename = read()
            writeFile(filename)
        elseif choice == 4 then
            write("Enter filename to delete: ")
            local filename = read()
            deleteFile(filename)
        elseif choice == 5 then
            print("Exiting Flopper.")
            break
        else
            print("Invalid choice. Please try again.")
        end

        print()  -- Blank line for better readability
    end
end

-- Run the main function
main()

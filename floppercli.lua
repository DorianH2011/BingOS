-- Flopper: A simple file manager for ComputerCraft

local function printHelp()
    print("Flopper - A simple file manager")
    print("Commands:")
    print("ls                - List files in the current directory")
    print("cd <dir>          - Change directory")
    print("cat <file>        - Display the contents of a file")
    print("edit <file>       - Edit a file")
    print("rm <file>         - Delete a file")
    print("mkdir <dir>       - Create a new directory")
    print("touch <file>      - Create a new empty file")
    print("pwd               - Print working directory")
    print("help              - Show this help message")
end

local function listFiles()
    local files = fs.list(shell.dir())
    for i = 1, #files do
        print(files[i])
    end
end

local function changeDir(dir)
    if fs.isDir(dir) then
        shell.setDir(fs.combine(shell.dir(), dir))
    else
        print(dir .. " is not a directory")
    end
end

local function displayFile(file)
    if fs.exists(file) and not fs.isDir(file) then
        local f = fs.open(file, "r")
        print(f.readAll())
        f.close()
    else
        print(file .. " does not exist or is a directory")
    end
end

local function editFile(file)
    shell.run("edit", file)
end

local function deleteFile(file)
    if fs.exists(file) then
        fs.delete(file)
        print(file .. " deleted")
    else
        print(file .. " does not exist")
    end
end

local function createDir(dir)
    if not fs.exists(dir) then
        fs.makeDir(dir)
        print("Directory " .. dir .. " created")
    else
        print(dir .. " already exists")
    end
end

local function createFile(file)
    if not fs.exists(file) then
        local f = fs.open(file, "w")
        f.close()
        print("File " .. file .. " created")
    else
        print(file .. " already exists")
    end
end

local function printWorkingDir()
    print(shell.dir())
end

local args = { ... }

if #args == 0 then
    printHelp()
else
    local command = args[1]

    if command == "ls" then
        listFiles()
    elseif command == "cd" and #args == 2 then
        changeDir(args[2])
    elseif command == "cat" and #args == 2 then
        displayFile(args[2])
    elseif command == "edit" and #args == 2 then
        editFile(args[2])
    elseif command == "rm" and #args == 2 then
        deleteFile(args[2])
    elseif command == "mkdir" and #args == 2 then
        createDir(args[2])
    elseif command == "touch" and #args == 2 then
        createFile(args[2])
    elseif command == "pwd" then
        printWorkingDir()
    elseif command == "help" then
        printHelp()
    else
        print("Invalid command. Type 'flopper help' for a list of commands.")
    end
end

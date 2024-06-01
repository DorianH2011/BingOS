local termWidth, termHeight = term.getSize()
local currentDocument = ""
local currentFilename = ""

local function drawUI()
    term.clear()
    term.setCursorPos(1, 1)
    term.write("BingDoc")
    term.setCursorPos(1, termHeight)
    term.write("Press Ctrl+S to save, Ctrl+Q to quit")
end

local function loadDocument(filename)
    local path = "/documents/" .. filename
    if fs.exists(path) then
        local file = fs.open(path, "r")
        currentDocument = file.readAll()
        file.close()
    else
        currentDocument = ""
    end
end

local function saveDocument(filename, content)
    local path = "/documents/" .. filename
    local file = fs.open(path, "w")
    file.write(content)
    file.close()
end

local function editDocument()
    term.clear()
    term.setCursorPos(1, 1)
    print("Editing document: " .. currentFilename)
    print("Press Ctrl+S to save, Ctrl+Q to quit")
    print("--------------------------------------")
    print(currentDocument)
end

local function handleKeypress(key)
    if key == keys.leftCtrl then
        local _, key2 = os.pullEvent("key")
        if key2 == keys.s then
            saveDocument(currentFilename, currentDocument)
            return true
        elseif key2 == keys.q then
            return true
        end
    elseif key == keys.backspace then
        currentDocument = currentDocument:sub(1, -2)
    elseif key == keys.enter then
        currentDocument = currentDocument .. "\n"
    elseif key >= 32 and key <= 122 then
        currentDocument = currentDocument .. string.char(key)
    end
    return false
end

local function main()
    while true do
        drawUI()
        term.setCursorBlink(true)
        loadDocument(currentFilename)
        editDocument()
        term.setCursorBlink(false)
        
        while true do
            local event, param = os.pullEvent()
            if event == "char" then
                handleKeypress(param)
            elseif event == "key" then
                if handleKeypress(param) then
                    break
                end
            end
        end
    end
end

main()

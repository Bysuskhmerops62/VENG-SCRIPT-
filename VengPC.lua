if not game['Loaded'] then game['Loaded']:Wait() end; repeat wait(.06) until game:GetService('Players').LocalPlayer ~= nil

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local HttpService = game:GetService("HttpService")
local Top = ""
local VersionScript = "1.2"
local Tab2 = ""
local vcountry = ""
local emoji_unicode = ""
local LogoID = "17813607147"

local emoji = ""

local function utf8char(code)
    if code <= 0x7F then
        return string.char(code)
    elseif code <= 0x7FF then
        local b1 = 0xC0 + math.floor(code / 0x40)
        local b2 = 0x80 + (code % 0x40)
        return string.char(b1, b2)
    elseif code <= 0xFFFF then
        local b1 = 0xE0 + math.floor(code / 0x1000)
        local b2 = 0x80 + (math.floor(code / 0x40) % 0x40)
        local b3 = 0x80 + (code % 0x40)
        return string.char(b1, b2, b3)
    else -- 4-byte UTF8
        local b1 = 0xF0 + math.floor(code / 0x40000)
        local b2 = 0x80 + (math.floor(code / 0x1000) % 0x40)
        local b3 = 0x80 + (math.floor(code / 0x40) % 0x40)
        local b4 = 0x80 + (code % 0x40)
        return string.char(b1, b2, b3, b4)
    end
end

local function unicodeStringToEmoji(unicodeStr)
    local emoji = ""
    for codepoint in unicodeStr:gmatch("U%+([0-9A-Fa-f]+)") do
        local cp = tonumber(codepoint, 16)
        emoji = emoji .. utf8char(cp)
    end
    return emoji
end

-- function request HTTP  Krnl request function
local requestFunc = (http_request or request or (syn and syn.request))
if not requestFunc then
    warn(" HTTP Request Not Supported by Executor")
    return
end

local url = "https://ipwho.is/"

local success, response = pcall(function()
    local res = requestFunc({
        Url = url,
        Method = "GET"
    })
    return res.Body
end)

if success then
    local data = HttpService:JSONDecode(response)

    vcountry = data.country or "Unknown"
    emoji_unicode = data.flag and data.flag.emoji_unicode or ""

    emoji = unicodeStringToEmoji(emoji_unicode)

    print("Country: " .. vcountry)
    print("Emoji Unicode: " .. emoji_unicode)
    print("Emoji: " .. emoji)
    local emg = emoji
else
    warn("Failed to fetch")
end



local CreateInstance = function(InstanceType, Properties, Children)
    local Object = Instance.new(InstanceType)

    for Key, Value in next, Properties or {} do
        Object[Key] = Value
    end

    for _, Child in next, Children or {} do
        Child.Parent = Object
    end

    return Object
end

local DisplayPopup = function(Title, Message, UseCoroutine)
    if not getrenv then
        return warn(Message)
    end

    local ErrorModule = getrenv().require(
        game.CoreGui:WaitForChild("RobloxGui")
                    :WaitForChild("Modules")
                    :WaitForChild("ErrorPrompt")
    )

    local Prompt = ErrorModule.new("Default", { HideErrorCode = true })
    local ErrorGui = CreateInstance("ScreenGui", {
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })

    local CurrentCoroutine = UseCoroutine and coroutine.running()

    Prompt:setParent(ErrorGui)
    Prompt:setErrorTitle(Title)
    Prompt:updateButtons({{
        Text = "CANCEL",
        Callback = function()
            Prompt:_close()
            ErrorGui:Destroy()
            if CurrentCoroutine then
                coroutine.resume(CurrentCoroutine)
            end
        end,
        Primary = true
    }}, "Default")

    Prompt:_open(Message)

    if CurrentCoroutine then
        coroutine.yield()
    end
end


local LoadingGui

local ScriptUpdate = false
local ScriptPause = false
local ScriptDone = false

local KeyLogin = false

local TextLoading = "Loading"

local Numberusers = 0 
local OpneScriptuser = 0

local function music(idPut)
        local Sound = Instance.new("Sound")
        Sound.Name = "VengMusic"
        Sound.SoundId = "rbxassetid://" .. idPut
        Sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        Sound.Volume = 10
        Sound:Play()
end

local function createLoadingUI()
    if LoadingGui and LoadingGui.Parent then return end

    local camera = workspace.CurrentCamera
    local screenSize = camera and camera.ViewportSize or Vector2.new(720, 1280)
    local screenW, screenH = screenSize.X, screenSize.Y

    local guiWidth = math.clamp(screenW * 0.5, 250, 450)
    local guiHeight = math.clamp(screenH * 0.08, 60, 100)
    local fontSize = math.clamp(math.floor(screenW / 30), 18, 36)

    LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "LoadingGui"
    LoadingGui.Parent = PlayerGui
    LoadingGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", LoadingGui)
    frame.Size = UDim2.new(0, guiWidth, 0, guiHeight)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BackgroundTransparency = 0.15
    frame.ClipsDescendants = true
    frame.Visible = false
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 20)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 165, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0.5

    local loadingLabel = Instance.new("TextLabel", frame)
    loadingLabel.Size = UDim2.new(1, -20, 1, -20)
    loadingLabel.Position = UDim2.new(0, 10, 0, 10)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    loadingLabel.Font = Enum.Font.GothamBold
    loadingLabel.TextSize = fontSize
    loadingLabel.TextXAlignment = Enum.TextXAlignment.Center
    loadingLabel.TextYAlignment = Enum.TextYAlignment.Center
    loadingLabel.Text = "Loading"

    local dotsCount = 0
    local running = true

    local function animateDots()
        while running and frame.Parent do
           loadingLabel.Text = TextLoading
            wait(0.5)
        end
    end

    local function animateFrame(show)
        if show then
            frame.Visible = true
            frame.BackgroundTransparency = 1
            frame.Size = UDim2.new(0, guiWidth * 0.8, 0, guiHeight * 0.85)
            frame.Position = UDim2.new(0.5, 0, 0.5, 20)
            frame:TweenSize(UDim2.new(0, guiWidth, 0, guiHeight), "Out", "Quad", 0.5, true)
            frame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.5, true)
            for i = 1, 0, -0.1 do
                frame.BackgroundTransparency = i
                wait(0.03)
            end
            frame.BackgroundTransparency = 0.15
        else
            for i = 0.15, 1, 0.1 do
                frame.BackgroundTransparency = i
                wait(0.03)
            end
            frame:TweenSize(UDim2.new(0, guiWidth * 0.8, 0, guiHeight * 0.85), "In", "Quad", 0.5, true)
            frame:TweenPosition(UDim2.new(0.5, 0, 0.5, 20), "In", "Quad", 0.5, true)
            wait(0.5)
            frame.Visible = false
        end
    end

    animateFrame(true)
    spawn(animateDots)

    local function close()
        running = false
        animateFrame(false)
        wait(0.6)
        if LoadingGui then
            LoadingGui:Destroy()
            LoadingGui = nil
        end
    end

    return close
end

print(" Library | Load ")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

getgenv()._NotiList = getgenv()._NotiList or {}

print("Notification | Loaded")

local function showNotification(textToDisplay, stayTime)
    if type(textToDisplay) ~= "string" then
        warn("Notification error: textToDisplay must be a string")
        return
    end

    stayTime = tonumber(stayTime) or 5
    if stayTime < 0.5 then stayTime = 0.5 end

    for i = #_NotiList, 1, -1 do
        if not _NotiList[i] or not _NotiList[i].Gui or not _NotiList[i].Gui.Parent then
            table.remove(_NotiList, i)
        end
    end

    if #_NotiList >= 3 then
        local first = table.remove(_NotiList, 1)
        if first and first.Gui and first.Gui.Parent then
            first.Gui:Destroy()
        end
    end

    local success, Gui = pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NotificationGui_"..tostring(os.time())
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = PlayerGui
        return gui
    end)

    if not success then
        warn("Failed to create notification GUI: "..tostring(Gui))
        return
    end

    -- Get screen size
    local camera = workspace.CurrentCamera
    local screenSize = camera and camera.ViewportSize or Vector2.new(720, 1280)
    local screenW, screenH = screenSize.X, screenSize.Y

    -- Calculate size & position
    local notiWidth = math.clamp(screenW * 0.8, 240, 500)
    local notiHeight = math.clamp(screenH * 0.06, 50, 100)
    local fontSize = math.clamp(math.floor(screenW / 40), 14, 24)
    local verticalSpacing = notiHeight + 10

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, notiWidth, 0, notiHeight)
    Frame.Position = UDim2.new(0.5, 0, 0, (#_NotiList * verticalSpacing))
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BackgroundTransparency = 0.2
    Frame.ClipsDescendants = true
    Frame.Parent = Gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = Frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 165, 0)
    stroke.Transparency = 0.2
    stroke.Parent = Frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -50, 1, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = fontSize
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Text = ""
    textLabel.TextWrapped = true
    textLabel.Parent = Frame

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 30, 0, 30)
    cancelBtn.Position = UDim2.new(1, -35, 0, 5)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    cancelBtn.Text = "✕"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.TextSize = 16
    cancelBtn.Font = Enum.Font.Gotham
    cancelBtn.BackgroundTransparency = 0.1
    cancelBtn.Parent = Frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = cancelBtn

    local function animateText(label, text, speed)
        label.Text = ""
        for i = 1, #text do
            if not label or not label.Parent then break end
            label.Text = string.sub(text, 1, i)
            task.wait(speed)
        end
    end

    task.spawn(function()
        pcall(animateText, textLabel, textToDisplay, 0.04)
    end)

    local NotiData = {Gui = Gui, Frame = Frame}
    table.insert(_NotiList, NotiData)

    local function destroyNoti()
        if not Gui or not Gui.Parent then return end
        pcall(function()
            Gui:Destroy()
        end)

        for i, item in ipairs(_NotiList) do
            if item.Gui == Gui then
                table.remove(_NotiList, i)
                break
            end
        end

        for i, item in ipairs(_NotiList) do
            if item and item.Frame and item.Frame.Parent then
                local y = (i - 1) * verticalSpacing
                item.Frame:TweenPosition(UDim2.new(0.5, 0, 0, y), "Out", "Sine", 0.25, true)
            end
        end
    end

    local conn
    conn = cancelBtn.MouseButton1Click:Connect(function()
        conn:Disconnect()
        destroyNoti()
    end)

    task.delay(stayTime, function()
        if Gui and Gui.Parent then
            local success = pcall(function()
                Frame:TweenPosition(UDim2.new(0.5, 0, 0, Frame.Position.Y.Offset - 100), "Out", "Back", 0.4, true)
            end)
            if success then
                task.wait(0.4)
            end
            destroyNoti()
        end
    end)
end

local function MokurenX()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bysuskhmerops62/VENG-SCRIPT-/refs/heads/main/LIB.txt"))()

local screenSize = workspace.CurrentCamera.ViewportSize
local isMobile = game:GetService("UserInputService").TouchEnabled

local width = 470
local height = math.clamp(screenSize.Y * 0.6, 300, 500)

local Window = Library:Window({
    Title = "MokurenX",
    Desc = "v" .. VersionScript,
    Icon = LogoID,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, width, 0, height),
    },
    CloseUIButton = {
        Enabled = isMobile,
        Text = "MokurenX"
    }
})

function executor(scriptUrl)
    local urlLower = scriptUrl:lower()
    local typescript = "Unknown"

    -- ចូលរួមបន្ថែម website ច្រើន
    if string.find(urlLower, "github") then
        typescript = "Github"
    elseif string.find(urlLower, "pastebin") then
        typescript = "Pastebin"
    elseif string.find(urlLower, "gist") then
        typescript = "Gist"
    elseif string.find(urlLower, "hastebin") then
        typescript = "Hastebin"
    elseif string.find(urlLower, "ghostbin") then
        typescript = "Ghostbin"
    elseif string.find(urlLower, "controlc") then
        typescript = "ControlC"
    elseif string.find(urlLower, "rentry") then
        typescript = "Rentry"
    elseif string.find(urlLower, "sourcebin") then
        typescript = "SourceBin"
    elseif string.find(urlLower, "pastie") then
        typescript = "Pastie"
    elseif string.find(urlLower, "haste.host") then
        typescript = "HasteHost"
    end

    -- ចាប់ផ្ដើម Notify
    Window:Notify({
        Title = "Run Loading (" .. typescript .. ")",
        Desc = "Please Wait",
        Time = 4
    })

    local success, err = pcall(function()
        local response
        if http and http.request then
            response = http.request({
                Url = scriptUrl,
                Method = "GET",
                Headers = {["User-Agent"] = "Mozilla/5.0"}
            })
            if response and response.Body then
                loadstring(response.Body)()
            else
                error("Empty Response")
            end
        else
            local data = game:HttpGet(scriptUrl)
            if data then
                loadstring(data)()
            else
                error("HttpGet Failed")
            end
        end
    end)

    if success then
        Window:Notify({
            Title = "Run Success",
            Desc = "Script from " .. typescript .. " loaded successfully.",
            Time = 4
        })
    else
        Window:Notify({
            Title = "Run Failed",
            Desc = "Error: " .. tostring(err),
            Time = 6
        })
    end
end

local function run(RawUrl)
    executor(RawUrl)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Auto refresh when respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end)

local speed = Humanoid.WalkSpeed
local jump = Humanoid.JumpPower

-- Loop flags
getgenv().loopW = false
getgenv().loopJ = false

local player = game.Players.LocalPlayer

-- Sidebar Vertical Separator
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0) -- adjust if needed
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui") -- Or Window.Gui if accessible

wait(1)

-- Tab
local Tab = Window:Tab({Title = "Player", Icon = "user-plus"}) do
    -- Section
    Tab:Section({Title = "All UI Components"})

    Tab:Textbox({
        Title = "Input Speed",
        Desc = "",
        Placeholder = "Enter value",
        Value = "",
        ClearTextOnFocus = false,
        Callback = function(text)
            local num = tonumber(text)
        if num then
            speed = num
            Humanoid.WalkSpeed = speed
        end
        end
    })
    -- Toggle
    Tab:Toggle({
        Title = "Loop Speed",
        Desc = "",
        Value = false,
        Callback = function(v)
            getgenv().loopW = v
        end
    })
    
    Tab:Textbox({
        Title = "Input Jump",
        Desc = "",
        Placeholder = "Enter value",
        Value = "",
        ClearTextOnFocus = false,
        Callback = function(text)
            local num = tonumber(text)
        if num then
            jump = num
            Humanoid.JumpPower = jump
        end
        end
    })
    
    Tab:Toggle({
        Title = "Loop Jump",
        Desc = "",
        Value = false,
        Callback = function(v)
            getgenv().loopJ = v
        end
    })
    
    local FlyJump = false
    
    Tab:Toggle({
        Title = "Infinite Jump",
        Desc = "",
        Value = false,
        Callback = function(v)
            FlyJump = v
        end
    })
    
    game:GetService("UserInputService").JumpRequest:Connect(function()
    if FlyJump and Humanoid then
        Humanoid:ChangeState("Jumping")
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().loopW and Humanoid then
            pcall(function()
                Humanoid.WalkSpeed = speed
            end)
        end
    end
end)

-- Jump loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().loopJ and Humanoid then
            pcall(function()
                Humanoid.JumpPower = jump
            end)
        end
    end
end)
    
    local Clip = true
local Noclipping = nil

local function noclip()
    Clip = false
    task.wait(0.1)
    Noclipping = game:GetService("RunService").Stepped:Connect(function()
        if not Clip and Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function clip()
    Clip = true
    if Noclipping then
        Noclipping:Disconnect()
        Noclipping = nil
    end
end
    
    Tab:Toggle({
        Title = "NoClip",
        Desc = "",
        Value = false,
        Callback = function(v)
            if v then
            noclip()
        else
            clip()
        end
        end
    })
    

    -- Button
    Tab:Button({
        Title = "FLY GUI  ",
        Desc = "Click to perform something",
        Callback = function()
            run("https://raw.githubusercontent.com/Bysuskhmerops62/AVG/refs/heads/main/Fly%20Gui%20V3")
        end
    })
    
    Tab:Button({
        Title = "FLY GUI Vehicle",
        Desc = "Click to perform something",
        Callback = function()
            run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui")
        end
    })
    
    local TpSpeed = 1
local tpwalkConnection = nil

    -- Textbox
    Tab:Textbox({
        Title = "Input Tp walk",
        Desc = "Type something here",
        Placeholder = "Enter value",
        Value = "",
        ClearTextOnFocus = false,
        Callback = function(text)
            local num = tonumber(text)
        if num then
            TpSpeed = num
        end
        end
    })
    
    Tab:Toggle({
        Title = "Tpwalk Status",
        Desc = "",
        Value = false,
        Callback = function(state)
            local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer

        if state then
            tpwalkConnection = RunService.Heartbeat:Connect(function()
                local chr = player.Character
                local hum = chr and chr:FindFirstChildOfClass("Humanoid")
                
                if hum and hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection * TpSpeed)
                end
            end)
        else
            if tpwalkConnection then
                tpwalkConnection:Disconnect()
                tpwalkConnection = nil
            end
        end
        end
    })
    
    local GravityOriginal = workspace.Gravity
    
    Tab:Slider({
        Title = "Gravity",
        Min = 0,
        Max = 1000,
        Rounding = 0,
        Value = GravityOriginal,
        Callback = function(Value)
            if tostring(Value):lower() == "re" then
            workspace.Gravity = GravityOriginal
        else
            local num = tonumber(Value)
            if num then
                workspace.Gravity = num
            else
                warn("Invalid gravity input:", Value)
            end
        end
        end
    })
    
    local Camera = game.Workspace.CurrentCamera
local PovOriginal = Camera.FieldOfView
    
    Tab:Slider({
        Title = "Fov",
        Min = Camera.FieldOfView,
        Max = 120,
        Rounding = 0,
        Value = Camera.FieldOfView,
        Callback = function(Value)
            Camera.FieldOfView = Value
        end
    })
    
    local stateFly = false
    local FlySpeed = 25
    
    -- Slider
    Tab:Slider({
        Title = "Fly speed",
        Min = 0,
        Max = 100,
        Rounding = 0,
        Value = 25,
        Callback = function(val)
            FlySpeed = val
        end
    })
    
    Tab:Toggle({
        Title = "Fly Status",
        Desc = "",
        Value = false,
        Callback = function(v)
            stateFly = v
if stateFly == false then
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler:Destroy()
game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler:Destroy()
game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
end
end
while stateFly do
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(9e9,9e9,9e9)
game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(9e9,9e9,9e9)
game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.CFrame = Workspace.CurrentCamera.CoordinateFrame
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = Vector3.new()
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * FlySpeed)
end
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X < 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * FlySpeed)
end
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * FlySpeed)
end
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z < 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * FlySpeed)
end
elseif game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") == nil then
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")

bv.Name = "VelocityHandler"
bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
bv.MaxForce = Vector3.new(0,0,0)
bv.Velocity = Vector3.new(0,0,0)

bg.Name = "GyroHandler"
bg.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
bg.MaxTorque = Vector3.new(0,0,0)
bg.P = 1000
bg.D = 50
end
task.wait()
end
        end
    })
    
    local Players = game:GetService("Players")
local PlrNs = Players.LocalPlayer

local DefaultCameraMode = 1 -- fallback default

if PlrNs.CameraMode == Enum.CameraMode.Classic then
    DefaultCameraMode = 1
elseif PlrNs.CameraMode == Enum.CameraMode.LockFirstPerson then
    DefaultCameraMode = 2
end

    -- Dropdown
    Tab:Dropdown({
        Title = "CameraMode",
        List = {"Classic", "LockFirstPerson"},
        Value = DefaultCameraMode,
        Callback = function(Value)
            if Value == "Classic" then
        PlrNs.CameraMode = Enum.CameraMode.Classic
    elseif Value == "LockFirstPerson" then
        PlrNs.CameraMode = Enum.CameraMode.LockFirstPerson
    end
        end
    })

end

-- Line Separator
Window:Line()

wait(1)

-- Another Tab Example
local t2 = Window:Tab({Title = "Game", Icon = "gamepad-2"}) do
    t2:Section({Title = "Grow a Garden"})
    t2:Button({
        Title = "Grow a Garden",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/loader")
        end
    })
    
    t2:Section({Title = "T-Titans Battlegrounds"})
    t2:Button({
        Title = "T-Titans Battlegroundsn",
        Desc = "",
        Callback = function()
            run("https://pastefy.app/CPymuwSW/raw")
        end
    })
    
    t2:Section({Title = "Brookhaven"})
    t2:Button({
        Title = "Brookhaven",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Daivd977/Deivd999/refs/heads/main/pessal")
        end
    })
    
    t2:Section({Title = "BloxFruits"})
    t2:Button({
        Title = "BloxFruits",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")
        end
    })
    
    t2:Section({Title = "The Rake REMASTERED"})
    t2:Button({
        Title = "The Rake REMASTERED",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/ScriptsLynX/LynX/main/KeySystem/Loader.lua")
        end
    })
    
    t2:Button({
        Title = "The Rake REMASTERED 2",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Djskinybinn/The-Rake-Remastered-Script-Keyless/refs/heads/main/ObfuscatedRakeScript.lua")
        end
    })
    
    t2:Section({Title = "Don't Press The Button 4"})
    t2:Button({
        Title = "Don't Press The Button 4",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/ItsJustynX/JNJS-hub/main/Dont%20press%20the%20button%204.lua")
        end
    })
    
    t2:Section({Title = "Build a battle"})
    t2:Button({
        Title = "Build a battle 1",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/UhGbaaaa/Game-script-/main/Build%20a%20battle.txt")
        end
    })
    
    t2:Button({
        Title = "Build a battle 2",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/linhmcfake/Script/refs/heads/main/MaxNo1.lua.txt")
        end
    })
    
    t2:Section({Title = "Dead Rails"})
    t2:Button({
        Title = "Dead Rails",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader")
        end
    })
    
    
    
    
end

Window:Line()


local t1 = Window:Tab({Title = "Script", Icon = "barcode"}) do
    t1:Section({Title = "Script"})
    
    
    t1:Button({
        Title = "Rejoin Game",
        Desc = "",
        Callback = function()
            
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    })
    
    t1:Button({
        Title = "Rejoin Server",
        Desc = "",
        Callback = function()
            
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end
    })
    
    t1:Button({
        Title = "Keyboard",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/VirtualKeyboard.lua.txt")
        end
    })
    
    t1:Button({
        Title = "Gui Invisible",
        Desc = "",
        Callback = function()
            
            run("https://pastebin.com/raw/3Rnd9rHf")
        end
    })
    
    t1:Button({
        Title = "Noclip Camera",
        Desc = "",
        Callback = function()
            
            run("https://pastebin.com/raw/y8DAEgGy")
        end
    })
    
    t1:Button({
        Title = "Destroy Delay",
        Desc = "",
        Callback = function()
            
            while task.wait(0.3) do
                local hasChanged = false
                
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.HoldDuration ~= 0 then
                        v.HoldDuration = 0
                        hasChanged = true
                    end
                end
                
                if not hasChanged then
                    task.wait(1)
                end
            end
        end
    })
    
    t1:Button({
        Title = "Save Server Gui",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source")
        Ioad("6abc8c09bf8fdf096f4a1ed90ba1867b")
        end
    })
    
    t1:Button({
        Title = "Fall Gui",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source")
        Ioad("35487fdd8d70227a1537e4dfa2d21e5c")
        end
    })
    
    t1:Button({
        Title = "Free Emoji",
        Desc = "",
        Callback = function()
            run("https://gist.githubusercontent.com/RedZenXYZ/3da6af1961efa275de6c3c2a6dbace03/raw/bb027f99cec0ea48ef9c5eabfb9116ddff20633d/FE%2520Emotes%2520Gui")
            
        end
    })
    
    t1:Button({
        Title = "Free Emoji (2)",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/Emoji.txt")
        end
    })
    
    t1:Button({
        Title = "Music Player",
        Desc = "",
        Callback = function()
            
          run('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source')
        Ioad('7208e39603889391caf77f6ff7d21e01')  
        end
    })
    
    t1:Button({
        Title = "Wallhop",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/aceurss/AcxScripter/refs/heads/main/FakeWallHopScript")
        end
    })
    
    t1:Button({
        Title = "ChatInlineTranslator",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/Bysuskhmerops62/VENG-SCRIPT-/refs/heads/main/ChatInlineTranslator.lua")
        end
    })
    
    t1:Button({
        Title = "Aimbot",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile")
        end
    })
    
    t1:Button({
        Title = "Aimbot 2",
        Desc = "",
        Callback = function()
            
            run("https://pastebin.com/raw/qtZt0Nzb")
        end
    })
    
    t1:Button({
        Title = "Teleport Player",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/Infinity2346/Tect-Menu/main/Teleport%20Gui.lua")
        end
    })
    
    t1:Button({
        Title = "FE Lag Switch",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/0Ben1/fe/main/Protected%20-%202023-05-28T225112.055.lua.txt")
        end
    })
    
    t1:Button({
        Title = "Double Jump",
        Desc = "",
        Callback = function()
            
            run("https://pastebin.com/raw/yHkKe5fH")
        end
    })
    
    t1:Button({
        Title = "Calculator",
        Desc = "",
        Callback = function()
            
            run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/Calculator.txt")
        end
    })
    
    t1:Toggle({
        Title = "Part Invisible / Show",
        Desc = "",
        Value = false,
        Callback = function(state)
            if state then
            -- Make all BaseParts fully visible (Transparency = 0)
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if not descendant:FindFirstChild("OriginalTransparency") then
                        local originalTransparency = Instance.new("NumberValue")
                        originalTransparency.Name = "OriginalTransparency"
                        originalTransparency.Value = descendant.Transparency
                        originalTransparency.Parent = descendant
                    end
                    descendant.Transparency = 0
                end
            end
        else
            -- Restore original transparency values
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local originalTransparency = descendant:FindFirstChild("OriginalTransparency")
                    if originalTransparency then
                        descendant.Transparency = originalTransparency.Value
                    end
                end
            end
        end
        end
    })
    
    local pp = false
local RunService = game:GetService("RunService")
-- 🔧 Variable Setup
local Lighting = game:GetService("Lighting")

-- 💾 Save Original Lighting Settings
local BrightnessOld = Lighting.Brightness
local ClockTimeOld = Lighting.ClockTime
local FogEndOld = Lighting.FogEnd
local GlobalShadowsOld = Lighting.GlobalShadows
local OutdoorAmbientOld = Lighting.OutdoorAmbient

-- ⚙️ Function to Apply or Reset Lighting
local function updateLighting()
    if pp then
        -- Enable Full Bright
        pcall(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end)
    else
        -- Reset to Original
        pcall(function()
            Lighting.Brightness = BrightnessOld
            Lighting.ClockTime = ClockTimeOld
            Lighting.FogEnd = FogEndOld
            Lighting.GlobalShadows = GlobalShadowsOld
            Lighting.OutdoorAmbient = OutdoorAmbientOld
        end)
    end
end
    
    t1:Toggle({
        Title = "Full Brightness",
        Desc = "",
        Value = false,
        Callback = function(v)
            pp = v
        updateLighting()
        end
    })
    
    local Player = game.Players.LocalPlayer

local toggleRemoveFogEnd = game.Lighting.FogEnd
local toggleRemoveFogStart = game.Lighting.FogStart
local toggleRemoveFogAmbient = game.Lighting.Ambient
local toggleRemoveFogOutDoors = game.Lighting.OutdoorAmbient

local function ScriptRemoveFog()
    game.Lighting.FogEnd = math.huge
    game.Lighting.FogStart = 0
    game.Lighting.Ambient = Color3.fromRGB(167, 167, 167)
    game.Lighting.OutdoorAmbient = Color3.fromRGB(167, 167, 167)
end

local function ScriptRemoveFogReast()
    game.Lighting.FogEnd = toggleRemoveFogEnd
    game.Lighting.FogStart = toggleRemoveFogStart
    game.Lighting.Ambient = toggleRemoveFogAmbient
    game.Lighting.OutdoorAmbient = toggleRemoveFogOutDoors
end
    
    t1:Toggle({
        Title = "Remove Fog",
        Desc = "",
        Value = false,
        Callback = function(v)
            if v then
            ScriptRemoveFog()
        else
            ScriptRemoveFogReast()
        end
        end
    })
    

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local RunService = game:GetService("RunService")

-- បង្កើតប៊ូតុង
t1:Button({
    Title = "Anti Sit",
    Desc = "Disable seating so that you can't sit down.",
    Callback = function()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if humanoid and humanoid.Sit then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                humanoid.Sit = false
            end
        end)

        -- បើអ្នកចង់បិទអោយសកម្មភាព Anti Sit ឈប់
        -- អ្នកអាច uncomment ខាងក្រោម
        -- wait(10)
        -- connection:Disconnect()
    end
})
    
    t1:Button({
        Title = "Anti Kick",
        Desc = "",
        Callback = function()
            
           local old
 old = hookmetamethod(
 game,
 "__namecall",
 function(self, ...)
  local method = tostring(getnamecallmethod())
  if string.lower(method) == "kick" then
     return 
  end
  return old(self, ...)
 end) 
        end
    })
    
    t1:Button({
        Title = "Anti Fling",
        Desc = "",
        Callback = function()
            
          local function NoCollision(plr)
            if AntiFling and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end

        -- Apply to existing players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                RunService.Stepped:Connect(function()
                    NoCollision(player)
                end)
            end
        end

        -- Apply to new players
        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                RunService.Stepped:Connect(function()
                    NoCollision(player)
                end)
            end
        end)  
        end
    })
    
    t1:Section({Title = "Script Hub "})
    
    t1:Button({
        Title = "Swamp Monster Hub",
        Desc = "",
        Callback = function()
            run("https://pastefy.app/2tC7nRAK/raw")
            
        end
    })
    
    t1:Button({
        Title = "n00zkidd gui v3",
        Desc = "",
        Callback = function()
            run("https://rawscripts.net/raw/Universal-Script-n00zkidd-gui-v3-40368")
            
        end
    })
    
    
        t1:Button({
        Title = "explorer",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
            
        end
    })
    
    
        t1:Button({
        Title = "Infinite Yield",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
            
        end
    })
    
    
        t1:Button({
        Title = "GhostPlayer",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub")
            
        end
    })
    
    
    
    Window:Line()
    
    wait(1)
    
end

local t2 = Window:Tab({Title = "Hitbox and Troll", Icon = "dumbbell"}) do
    t2:Section({Title = "Hitbox "})
    
local rainbowHue = 0

-- HSV → RGB
local function HSVToRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    elseif i == 5 then
        r, g, b = v, p, q
    end
    return Color3.new(r, g, b)
end

-- UI Variable


-- Settings
local HitboxSize = 10
local HitboxTransparency = 0.8
local TeamCheck = false
local HitboxStatus = false
local ToolsHitboxSize = 10
local TypeHitbox = "Player"

-- Roblox Service
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- Connection Variables
local rainbowConnection = nil
local toolConnection = nil
local HitboxConnection = nil

-- Apply Hitbox to Tools
local function applyHitbox(tool)
    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
        local handle = tool.Handle
        handle.Massless = true
        handle.Transparency = 1
        handle.Size = Vector3.new(ToolsHitboxSize, ToolsHitboxSize, ToolsHitboxSize)

        local selectionBox = Instance.new("SelectionBox", handle)
        selectionBox.Adornee = handle

        rainbowConnection = RunService.RenderStepped:Connect(function()
            local hue = (tick() % 5) / 5
            selectionBox.Color3 = HSVToRGB(hue, 1, 1)
        end)
    end
end

-- Dropdown for Player / Tools
t2:Dropdown({
    Title = "Choose Hitbox",
    List = {"Player", "Tools"},
    Value = "Player",
    Callback = function(choice)
        TypeHitbox = choice
    end
})

-- Textbox for Size
t2:Textbox({
    Title = "Input Hitbox Size",
    Placeholder = "Enter value",
    ClearTextOnFocus = false,
    Callback = function(text)
        local numValue = tonumber(text)
        if not numValue or numValue > 100 or numValue < 5 then
            HitboxSize = 10
            ToolsHitboxSize = 10
        else
            HitboxSize = numValue
            ToolsHitboxSize = numValue
        end
    end
})

-- Textbox for Transparency
t2:Textbox({
    Title = "Hitbox Transparency",
    Placeholder = "Enter value (0-1)",
    ClearTextOnFocus = false,
    Callback = function(value)
        local numValue = tonumber(value)
        if not numValue or numValue > 1 or numValue < 0 then
            HitboxTransparency = 0.8
        else
            HitboxTransparency = numValue
        end
    end
})

-- Toggle Team Check
t2:Toggle({
    Title = "Team Check",
    Value = false,
    Callback = function(v)
        TeamCheck = v
    end
})

-- Toggle Status
t2:Toggle({
    Title = "Status",
    Value = false,
    Callback = function(state)

        if TypeHitbox == "Tools" then
            if state then
                -- loop ពិនិត្យ tool
                task.spawn(function()
                    while state do
                        for _, tool in ipairs(Player.Character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                                applyHitbox(tool)
                            end
                        end
                        task.wait(0.5)
                    end
                end)

                -- tool added event
                toolConnection = Player.Character.ChildAdded:Connect(function(child)
                    if state and child:IsA("Tool") and child:FindFirstChild("Handle") then
                        applyHitbox(child)
                    end
                end)
            else
                -- turn off
                if rainbowConnection then
                    rainbowConnection:Disconnect()
                    rainbowConnection = nil
                end
                if toolConnection then
                    toolConnection:Disconnect()
                    toolConnection = nil
                end

                for _, tool in ipairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        for _, obj in ipairs(tool.Handle:GetChildren()) do
                            if obj:IsA("SelectionBox") then
                                obj:Destroy()
                            end
                        end
                        tool.Handle.Transparency = 0
                    end
                end
            end

        else
            -- fallback
            HitboxStatus = state

            if HitboxConnection then
                HitboxConnection:Disconnect()
                HitboxConnection = nil
            end

            if state then
                HitboxConnection = RunService.RenderStepped:Connect(function()
                    local rainbowHue = (tick() % 5) / 5
                    local rainbowColor = HSVToRGB(rainbowHue, 1, 1)
                    for _, v in ipairs(game.Players:GetPlayers()) do
                        if v ~= Player then
                            local sameTeam = (v.Team == Player.Team)
                            if (TeamCheck and not sameTeam) or (not TeamCheck) then
                                pcall(function()
                                    local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                                        hrp.Transparency = HitboxTransparency
                                        hrp.Color = rainbowColor
                                        hrp.Material = Enum.Material.Neon
                                        hrp.CanCollide = false
                                    end
                                end)
                            end
                        end
                    end
                end)
            else
                -- Reset
                for _, v in ipairs(game.Players:GetPlayers()) do
                    if v ~= Player then
                        pcall(function()
                            local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.Size = Vector3.new(2, 2, 1)
                                hrp.Transparency = 1
                                hrp.Color = Color3.new(0.5, 0.5, 0.5)
                                hrp.Material = Enum.Material.Plastic
                                hrp.CanCollide = false
                            end
                        end)
                    end
                end
            end
        end

    end
})

t2:Section({Title = "Troll "})

t2:Button({
        Title = "saMtiek2",
        Desc = "",
        Callback = function()
            run("https://pastebin.com/raw/saMtiek2")
        end
    })
    
    t2:Button({
        Title = "TrollGui",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Bysuskhmerops62/AVG/refs/heads/main/Fe%20Troll%20Fling")
        end
    })
    
    t2:Button({
        Title = "Auto Fling Player",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Auto%20Fling%20Player")
        end
    })
    
    t2:Button({
        Title = "Touch Fling GUi",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI")
        end
    })
    
    t2:Button({
        Title = "SUB (work R6)",
        Desc = "",
        Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("Spider Script")
        end
    })
    
end

Window:Line()

local t3 = Window:Tab({Title = "Other", Icon = "x"}) do
    t3:Section({Title = "Part Script"})
    
    local gotopartDelay = 0.1
local espTransparency = 0.3  
local speaker = game.Players.LocalPlayer
local espParts = {}
local isEspEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)

-- Get Root Part
local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Add ESP Billboard
function AddESP(part)
    if not (PartName and part:IsA("BasePart") and part.Name:lower() == PartName:lower()) then return end
    if part:FindFirstChild(PartName.."_TextESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = PartName.."_TextESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0  -- UI មិនប្រើពន្លឺ
    billboard.Parent = part

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = part.Name
    textLabel.TextColor3 = espColor or Color3.fromRGB(0, 255, 0)
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
end

-- Variables
local PartName = ""
local LoopGoto = false
local LoopBring = false

wait(1)
    
    t3:Textbox({
        Title = "Part Name",
        Desc = "",
        Placeholder = "Enter value",
        Value = "",
        ClearTextOnFocus = false,
        Callback = function(Value)
            PartName = Value
        getgenv().PartName = Value
        end
    })
    
    t3:Toggle({
        Title = "Part ESP",
        Desc = "",
        Value = false,
        Callback = function(state)
            isEspEnabled = state
        if state then
            if PartName and not table.find(espParts, PartName) then  
                table.insert(espParts, PartName)  
                for _, v in pairs(workspace:GetDescendants()) do  
                    AddESP(v)
                end  
            end  
        else
            espParts = {}  
            for _, part in pairs(workspace:GetDescendants()) do  
                if part:IsA("BasePart") then  
                    local adornment = part:FindFirstChild(PartName.."_TextESP")  
                    if adornment then  
                        adornment:Destroy()  
                    end  
                end  
            end  
        end
        end
    })
    
    t3:Button({
        Title = "Teleport",
        Desc = "",
        Callback = function()
            for _, v in pairs(workspace:GetDescendants()) do
            if getgenv().PartName and v.Name:lower() == getgenv().PartName:lower() and v:IsA("BasePart") then
                local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass('Humanoid')
                if humanoid and humanoid.SeatPart then
                    humanoid.Sit = false
                    wait(0.1)
                end
                wait(gotopartDelay or 0)
                local root = getRoot(speaker.Character)
                if root then
                    root.CFrame = v.CFrame
                end
            end
        end
        end
    })
    
    t3:Toggle({
        Title = "Loop Teleport",
        Desc = "",
        Value = false,
        Callback = function(v)
            LoopGoto = v
        end
    })
    
    t3:Button({
        Title = "Bring",
        Desc = "",
        Callback = function()
            for _, v in pairs(workspace:GetDescendants()) do
            if getgenv().PartName and v.Name:lower() == getgenv().PartName:lower() and v:IsA("BasePart") then
                local root = getRoot(speaker.Character)
                if root then
                    v.CFrame = root.CFrame
                end
            end
        end
        end
    })
    
    t3:Toggle({
        Title = "Loop Bring",
        Desc = "",
        Value = false,
        Callback = function(v)
            LoopBring = state
        end
    })
    
    local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRoot = character:WaitForChild("HumanoidRootPart")
    
    t3:Button({
        Title = "Touch",
        Desc = "Be careful. Not support krnl or More",
        Callback = function()
            firetouchinterest(humanoidRoot, getgenv().PartName, 1)
        end
    })
    
    t3:Section({Title = "Support Script"})
    
    t3:Button({
        Title = "Part Gui",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source")
        Ioad("583e3bd54554f2bfdcd007a49fa6b035")
        end
    })
    
    t3:Button({
        Title = "Part Name",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/partname.lua.txt")
        end
    })
    
    t3:Button({
        Title = "position finder gui",
        Desc = "",
        Callback = function()
            run("https://pastebin.com/raw/BjViRedU")
        end
    })
    
    t3:Button({
        Title = "turtle spy",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/source.lua.txt")
        end
    })
    
    t3:Button({
        Title = "SimpleSpy",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/UhGbaaaa/Android-Value/main/SimpleSpyMobile.txt")
        end
    })
    
    t3:Button({
        Title = "Gui Make",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Bysuskhmerops62/Key-System-/refs/heads/main/Gui%20Maker.txt")
        end
    })
    
    t3:Section({Title = "Tools"})
    
    t3:Button({
        Title = "Telekinesis",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/qwerty11.lua.txt")
        end
    })
    
    t3:Button({
        Title = "F3X",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/F3X.LUA.txt")
        end
    })
    
    t3:Button({
        Title = "Click Tp Normal",
        Desc = "",
        Callback = function()
            mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click Teleport"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
        end
    })
    
    t3:Section({Title = "Executor"})
    
    t3:Button({
        Title = "Arceus x",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Giangplay/Script/main/Arceus_X_V3.lua")
        end
    })
    
    t3:Button({
        Title = "Codex",
        Desc = "",
        Callback = function()
            run("https://raw.githubusercontent.com/Giangplay/Script/main/Codex.lua")
        end
    })
    
 end
 
 Window:Line()
 
 local t4 = Window:Tab({Title = "Ranking", Icon = "table-2"}) do
    t4:Section({Title = "Top Player"})
    
    local ToPlayer = t4:Code({
        Title = "Top Player (You = " .. OpneScriptuser .. ")",
        Code = Tab2
    })
    
    
    t4:Section({Title = "Top Country"})
    
    local TopCaountry = t4:Code({
        Title = "Top Country (Player All = " .. Numberusers .. ")",
        Code = Top
    })
    
end

Window:Line()

local ad = Window:Tab({Title = "Info", Icon = "server-crash"}) do

  ad:Section({Title = "Info"})
  
  local ChosseCopy = "Name"

ad:Dropdown({
    Title = "Choose For To Copy",
    List = {"Name", "Id", "GameName", "GameId", "GameJobId"},
    Value = "Name",
    Callback = function(choice)
        ChosseCopy = choice
    end
})

ad:Button({
    Title = "Copying",
    Desc = "Click to Copy",
    Callback = function()
        local toCopy
        if ChosseCopy == "Name" then
            toCopy = game.Players.LocalPlayer.Name
        elseif ChosseCopy == "Id" then
            toCopy = tostring(game.Players.LocalPlayer.UserId)
        elseif ChosseCopy == "GameName" then
            toCopy = game.Name
        elseif ChosseCopy == "GameId" then
            toCopy = tostring(game.PlaceId)
        elseif ChosseCopy == "GameJobId" then
            toCopy = game.JobId
        else
            toCopy = "Unknown"
        end

        setclipboard(toCopy)

        Window:Notify({
            Title = "Copied",
            Desc = ChosseCopy.." copied to clipboard!",
            Time = 3
        })
    end
})

local player = game.Players.LocalPlayer

local accountAgeDays = player.AccountAge

-- base date 2000/01/01
local baseDate = os.time({year=2000, month=1, day=1})
local plusAge = baseDate + accountAgeDays * 86400 -- 86400 = sec/day

local finalCreated = os.date("%Y/%m/%d", plusAge)

local infoText =
"Account Name: " .. player.Name .. "\n" ..
"Account Display: " .. player.DisplayName .. "\n" ..
"Account Age: " .. accountAgeDays ..
"Game Name: " .. game.Name .. "\n" ..
"Game Id: " .. tostring(game.PlaceId) .. "\n" ..
"Game JobId: " .. game.JobId

local InfoAll = ad:Code({
    Title = "Info",
    Code = infoText
})
  
end

Window:Line()

local t5 = Window:Tab({Title = "Settings", Icon = "settings"}) do
   t5:Section({Title = "Settings"})
   
   t5:Toggle({
        Title = "Key Auto Save",
        Desc = "It will arrive soon.",
        Value = true,
        Callback = function(v)
            
        end
    })
    
    t5:Toggle({
        Title = "Share You IP",
        Desc = "It will arrive soon.",
        Value = false,
        Callback = function(v)
            
        end
    })
    
    t5:Toggle({
        Title = "Don't Share My Profile",
        Desc = "It will arrive soon.",
        Value = true,
        Callback = function(v)
            
        end
    })
    
    t5:Toggle({
        Title = "FPS MAX",
        Desc = "It will arrive soon.",
        Value = true,
        Callback = function(v)
            
        end
    })
end

Window:Notify({
    Title = "Veng",
    Desc = "All components loaded successfully! Credits leak: @bysuskhmer",
    Time = 4
})

end

local function Keysystem()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.Name
local PlayerId = tostring(LocalPlayer.UserId)
local PlayerIP = tostring(game:HttpGet("https://api.ipify.org")) -- យក IP Public

local HWID = PlayerName

local KeyAutoDone = false

local ServiceName = "Veng-Script"
local Identifier = "synapse_v82k_script_roblox"
local DiscordURL = "https://discord.gg/BpEvHfCg"
local VanguardToken = "vsXv5lpCt0OL0398ZY8bqpzrSeqr8cRn"

local function GetKeyLink(identifier, hwid)
    return "https://pandadevelopment.net/getkey?service=" .. identifier .. "&hwid=" .. hwid
end

local function ValidateKey(key)
    local url = "https://pandadevelopment.net/v2_validation" ..
        "?key=" .. tostring(key) ..
        "&service=" .. Identifier ..
        "&hwid=" .. tostring(HWID)

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        return false, "Request failed: " .. tostring(response)
    end

    local decodeSuccess, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not decodeSuccess then
        return false, "JSON decode failed: " .. tostring(data)
    end

    if data["V2_Authentication"] == "success" then
        return true, "Key validated successfully"
    else
        return false, data["reason"] or "Unknown reason"
    end
end

local function SaveKeyToFile(key)
    if writefile then
        writefile("VengSaveKey.txt", key)
    end
end

local function LoadKeyFromFile()
    if isfile and readfile then
        if isfile("VengSaveKey.txt") then
            local key = readfile("VengSaveKey.txt")
            return key
        else
            return nil
        end
    else
        return nil
    end
end

local function DeleteSavedKey()
    if delfile and isfile and isfile("VengSaveKey.txt") then
        delfile("VengSaveKey.txt")
    end
end

local AutoKey = LoadKeyFromFile()
if AutoKey then
    local valid, msg = ValidateKey(AutoKey)
    if valid then
        task.spawn(function()
            MokurenX()
        end)
        if gui then gui:Destroy() end
        return
    else
        warn("[❌] Auto login failed:", msg)
        DeleteSavedKey()
    end
end

wait(2)

if KeyAutoDone == false then
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "KeyUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 400, 0, 350)
    frame.Position = UDim2.new(0.5, -200, 0.5, -175)
    frame.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Active = true
    frame.Draggable = true

    local uicorner = Instance.new("UICorner", frame)
    uicorner.CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", frame)
    title.Text = "Welcome back!"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -20, 0, 35)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local subtitle = Instance.new("TextLabel", frame)
    subtitle.Text = "Access Data through completing the key system, doesn’t take long!"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subtitle.BackgroundTransparency = 1
    subtitle.Size = UDim2.new(1, -20, 0, 30)
    subtitle.Position = UDim2.new(0, 10, 0, 45)
    subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox", frame)
    input.PlaceholderText = "Enter key"
    input.Text = ""
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.TextColor3 = Color3.fromRGB(0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    input.Size = UDim2.new(1, -40, 0, 36)
    input.Position = UDim2.new(0, 20, 0, 90)
    input.ClearTextOnFocus = false
    local cornerInput = Instance.new("UICorner", input)
    cornerInput.CornerRadius = UDim.new(0, 6)

    local function createButton(text, posY, bgColor)
        local btn = Instance.new("TextButton", frame)
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = bgColor
        btn.Size = UDim2.new(1, -40, 0, 36)
        btn.Position = UDim2.new(0, 20, 0, posY)
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        return btn
    end

    local btnContinue = createButton("Continue", 140, Color3.fromRGB(0, 170, 255))
    local btnReceive = createButton("Receive Key", 190, Color3.fromRGB(52, 152, 219))

    local lblChecking = Instance.new("TextLabel", frame)
    lblChecking.Text = "Checking key..."
    lblChecking.Font = Enum.Font.Gotham
    lblChecking.TextSize = 14
    lblChecking.TextColor3 = Color3.fromRGB(200, 200, 200)
    lblChecking.BackgroundTransparency = 1
    lblChecking.Size = UDim2.new(1, -40, 0, 30)
    lblChecking.Position = UDim2.new(0, 20, 0, 240)
    lblChecking.TextXAlignment = Enum.TextXAlignment.Left

    local btnDiscord = createButton("Discord", 280, Color3.fromRGB(114, 137, 218))

    btnReceive.MouseButton1Click:Connect(function()
        local url = GetKeyLink(Identifier, HWID)
        if setclipboard then
            setclipboard(url)
            DisplayPopup("Successful", "🔗 Key link copied to clipboard! : " .. url, true)
        else
            DisplayPopup("Faill", "🔗 Clipboard not supported. Check console.", true)
        end
        print("Open this URL to get your key: " .. url)
    end)
    
    btnDiscord.MouseButton1Click:Connect(function()
        setclipboard("")
        DisplayPopup("Copy Successful", "The Link : https://discord.gg/4pS3ty2mbe", true)
    end)

    btnContinue.MouseButton1Click:Connect(function()
        local key = input.Text
        if key == "" then
            lblChecking.Text = "Please enter a key"
            return
        end
        lblChecking.Text = "Validating..."
        local valid, msg = ValidateKey(key)
        lblChecking.Text = (valid and "✓" or "×") .. msg

        if valid then
            SaveKeyToFile(key)
            wait(1)
            gui:Destroy()
            wait(2)
            MokurenX()
        end
    end)
end
end

local function Lobby()
local Sound = Instance.new("Sound")
Sound.Name = "VengMusic"
Sound.SoundId = "rbxassetid://147722098" -- Marshmello - Alone (replace if needed)
Sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") -- Local use only
Sound.Volume = 5
Sound:Play()

-- Optional:

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local playerGui = Player:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("VENGLoadingGui")
if oldGui then oldGui:Destroy() end

local n2 = Instance.new("ScreenGui")
n2.Name = "VENGLoadingGui"
n2.ResetOnSpawn = false
n2.Parent = playerGui
n2.DisplayOrder = 999999

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.Position = UDim2.new(0, 0, 0, 0)
bgFrame.AnchorPoint = Vector2.new(0, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgFrame.BackgroundTransparency = 1
bgFrame.BorderSizePixel = 0 -- បំបាត់ស៊ុម
bgFrame.ZIndex = 1
bgFrame.Parent = n2

local gradient = Instance.new("UIGradient", bgFrame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10,10,10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,40))
}

local bigImage = Instance.new("ImageLabel")
bigImage.Size = UDim2.new(0, 100, 0, 100)
bigImage.Position = UDim2.new(0.5, 0, 0.4, 0)
bigImage.AnchorPoint = Vector2.new(0.5, 0.5)
bigImage.BackgroundTransparency = 1
bigImage.Image = "rbxassetid://134115596657469"
bigImage.Parent = bgFrame
bigImage.ImageTransparency = 1



local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0.4,0,0.1,0)
textLabel.Position = UDim2.new(0.5,0,0.7,0)
textLabel.AnchorPoint = Vector2.new(0.5,0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "VENG POWER"
textLabel.TextColor3 = Color3.new(1,1,1)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextScaled = true
textLabel.TextStrokeTransparency = 0.7
textLabel.TextTransparency = 1
textLabel.Parent = bgFrame

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(0.6, 0, 0.07, 0)
subtitleLabel.Position = UDim2.new(0.5, 0, 0.81, 0)
subtitleLabel.AnchorPoint = Vector2.new(0.5, 0)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "The screw may break if not used. Delta"
subtitleLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
subtitleLabel.Font = Enum.Font.Code
subtitleLabel.TextScaled = true
subtitleLabel.TextStrokeTransparency = 0.8
subtitleLabel.TextTransparency = 1
subtitleLabel.Parent = bgFrame

-- Tween slide-in for bigImage + fade-in texts
local slideTween = TweenService:Create(bigImage, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.45, 0),
    ImageTransparency = 0
})

local textFadeTween = TweenService:Create(textLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
    TextTransparency = 0
})

local subtitleFadeTween = TweenService:Create(subtitleLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
    TextTransparency = 0
})

-- Function to explode text into letters flying out with fade and scale
local function explodeText(textObj)
    local text = textObj.Text
    local parent = textObj.Parent
    local position = textObj.Position
    local size = textObj.Size
    local font = textObj.Font
    local textColor = textObj.TextColor3

    textObj.Visible = false

    local letters = {}

    local totalLength = #text
    local spacing = size.X.Offset / totalLength

    for i = 1, totalLength do
        local letter = Instance.new("TextLabel")
        letter.BackgroundTransparency = 1
        letter.Font = font
        letter.TextColor3 = textColor
        letter.Text = string.sub(text, i, i)
        letter.TextScaled = true
        letter.Size = UDim2.new(0, spacing, size.Y.Scale, size.Y.Offset)
        letter.Position = UDim2.new(position.X.Scale, position.X.Offset + spacing*(i-1), position.Y.Scale, position.Y.Offset)
        letter.AnchorPoint = Vector2.new(0, 0)
        letter.Parent = parent
        letter.ZIndex = textObj.ZIndex + 1
        table.insert(letters, letter)
    end

    -- Animate letters flying out with fade and scale
    for i, letter in ipairs(letters) do
        local angle = math.rad((360 / #letters) * i)
        local distance = 150

        local targetPos = UDim2.new(
            position.X.Scale + math.cos(angle) * (distance / workspace.CurrentCamera.ViewportSize.X),
            position.X.Offset + math.cos(angle) * distance,
            position.Y.Scale + math.sin(angle) * (distance / workspace.CurrentCamera.ViewportSize.Y),
            position.Y.Offset + math.sin(angle) * distance
        )

        local tween = TweenService:Create(letter, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = targetPos,
            TextTransparency = 1,
            TextStrokeTransparency = 1,
            TextSize = 0
        })
        tween:Play()
        tween.Completed:Connect(function()
            letter:Destroy()
        end)
    end
end

-- Explosion particle effect from bigImage center
local function CreateExplosionParticles()
    local particles = {}
    for i = 1, 12 do
        local part = Instance.new("ImageLabel")
        part.Size = UDim2.new(0, 50, 0, 50)
        part.Position = bigImage.Position
        part.AnchorPoint = Vector2.new(0.5, 0.5)
        part.BackgroundTransparency = 1
        part.Image = bigImage.Image
        part.Parent = bgFrame
        part.ImageTransparency = 0
        table.insert(particles, part)
    end

    for i, particle in ipairs(particles) do
        local angle = (360 / #particles) * i
        local radians = math.rad(angle)
        local distance = 200

        local targetPos = UDim2.new(
            0.5 + math.cos(radians) * (distance / workspace.CurrentCamera.ViewportSize.X),
            0,
            0.45 + math.sin(radians) * (distance / workspace.CurrentCamera.ViewportSize.Y),
            0
        )

        local tweenPos = TweenService:Create(particle, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Position = targetPos,
            ImageTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0)
        })

        tweenPos:Play()

        tweenPos.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

slideTween.Completed:Connect(function()
    CreateExplosionParticles()
end)

slideTween:Play()
textFadeTween:Play()
subtitleFadeTween:Play()

local HttpService = game:GetService("HttpService")  
local Players = game:GetService("Players")  
local LocalPlayer = Players.LocalPlayer  

-- Firebase Database Secret (auth token) សូមបញ្ចូលនៅទីនេះ  
local firebaseSecret = "C0i5c0EoSGrkY9zWtkQL2nyUwLGazH5MKKA1elyr"  

textLabel.Text = "Add Code"

-- បន្ថែម ?auth=secret នៅក្នុង URL ទៅ Firebase  
local firebaseURL_allUsers = "https://veng-hub-default-rtdb.firebaseio.com/users.json?auth=" .. firebaseSecret  
local firebaseURL_user = "https://veng-hub-default-rtdb.firebaseio.com/users/" .. LocalPlayer.Name .. ".json?auth=" .. firebaseSecret  

local requestFunc = (http_request or request or syn and syn.request)  
if not requestFunc then  
    warn("❌ Delta does not support http_request")  
    return  
end  

textLabel.Text = "Pls wait for Firebase Auth"

local function firebasestartAuth()  
    -- 1. GET all users  
    local getResponse = requestFunc({  
        Url = firebaseURL_allUsers,  
        Method = "GET"  
    })  

    if not getResponse.Success then  
        warn("❌ Error fetching users:", getResponse.StatusMessage)  
        return  
    end  

    -- 2. Handle "null" (empty Firebase DB)  
    local allUsers = nil  
    if getResponse.Body == "null" then  
        allUsers = {}  
    else  
        allUsers = HttpService:JSONDecode(getResponse.Body)  
    end  

    -- 3. Check if user exists  
    if allUsers[LocalPlayer.Name] then  
        print("✅ User already logged in:", LocalPlayer.Name)  
        return  
    end  
    
    local request = (http_request or request or syn and syn.request)
local HttpService = game:GetService("HttpService")

local function CheckExecutor()
    if pcall(function() return syn end) then return "Synapse X" end
    if pcall(function() return KRNL_LOADED or krnl end) then return "Krnl" end
    if pcall(function() return is_sirhurt_closure end) then return "Script-Ware" end
    if pcall(function() return electron end) then return "Electron" end
    if pcall(function() return fluxus end) then return "Fluxus" end
    if pcall(function() return getrenv and getrenv().Delta end) then return "Delta" end
    if pcall(function() return getexecutorname end) then return getexecutorname() end
    return "Unknown"
end

    local data = {
    name = LocalPlayer.Name,
    time = os.time(),
    Banner = false,
    Type = emg, -- ← ឆែកប្រទេសអូតូ
    LoginTimer = os.date("%Y-%m-%d %H:%M:%S"),
    VersionVeng = VersionSceipt,
    VIP = false,
    executor = CheckExecutor(),
    ScriptOpenCount = 0,
    country = vcountry,
    flag_emoji = emoji,
    Loginscript = os.date("%Y-%m-%d %I:%M:%S %p")
}

    local jsonData = HttpService:JSONEncode(data)  

    -- 5. PATCH new user data  
    local patchResponse = requestFunc({  
        Url = firebaseURL_user,  
        Method = "PATCH",  
        Headers = {  
            ["Content-Type"] = "application/json"  
        },  
        Body = jsonData  
    })  

    if patchResponse.Success then  
        print("✅ Logged new user to Firebase:", LocalPlayer.Name)  
    else  
        warn("❌ Failed to login user:", patchResponse.StatusMessage)  
    end  
end  

textLabel.Text = "Pls wait for Firebase Count User"

local function FirebaseAuthcount()  
    if not requestFunc then  
        warn("❌ Executor does not support http_request.")  
        return  
    end  

    local response = requestFunc({  
        Url = firebaseURL_allUsers,  
        Method = "GET"  
    })  

    if response.Success then  
        local data = HttpService:JSONDecode(response.Body)  

        local count = 0  
        for _, _ in pairs(data) do  
            count += 1  
        end  

        print("📊 Veng Total Player = ", count)  
        Numberusers = count  
    else  
        warn("❌ Firebase request failed:", response.StatusMessage)  
    end  
end  

firebasestartAuth()  

wait(0.5)  

FirebaseAuthcount()  

textLabel.Text = "Pls wait for Firebase Login Auth"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local firebaseSecret = "C0i5c0EoSGrkY9zWtkQL2nyUwLGazH5MKKA1elyr"
local firebaseURL = "https://veng-hub-default-rtdb.firebaseio.com/users/" .. LocalPlayer.Name .. ".json?auth=" .. firebaseSecret

local requestFunc = (http_request or request or syn and syn.request)
if not requestFunc then warn("❌ HTTP Request Not Supported!") return end

local function CheckExecutor()
    if pcall(function() return getrenv and getrenv().Delta end) then return "Delta" end
    if pcall(function() return syn end) then return "Synapse X" end
    if pcall(function() return KRNL_LOADED or krnl end) then return "Krnl" end
    if pcall(function() return is_sirhurt_closure end) then return "Script-Ware" end
    if pcall(function() return fluxus end) then return "Fluxus" end
    if pcall(function() return getexecutorname end) then return getexecutorname() end
    return "Unknown"
end

local function measurePing()
    local t = tick()
    RunService.Heartbeat:Wait()
    return tostring(math.floor((tick() - t) * 1000)) .. " ms"
end

local function getUserData()
    local res = requestFunc({
        Url = firebaseURL,
        Method = "GET"
    })
    if not res.Success or res.Body == "null" then return nil end
    return HttpService:JSONDecode(res.Body)
end

local function UpdateToFirebase()
    local data = getUserData()
    local count = 1
    if data and data["ScriptOpenCount"] then
        count = data["ScriptOpenCount"] + 1
        OpneScriptuser = data["ScriptOpenCount"] + 1
    end

    local update = {}
    update["ScriptOpenCount"] = count
    update["LoginTimer"] = os.date("%Y-%m-%d %I:%M:%S %p")
    update["executor"] = identifyexecutor and identifyexecutor() or "Unknown"
    update["Type"] = emg
    update["Ping"] = measurePing()
    update["AccountID"] = LocalPlayer.UserId
    update["AccountDisplayName"] = LocalPlayer.DisplayName
    update["AccountAge"] = LocalPlayer.AccountAge
    update["IsPremium"] = (LocalPlayer.MembershipType == Enum.MembershipType.Premium)
    update["FriendCount"] = #LocalPlayer:GetFriendsOnline()
    update["Description"] = (LocalPlayer:FindFirstChild("Description") and LocalPlayer.Description) or "No Desc"
    update["GameVersion"] = game.GameId
    update["GamePlaceId"] = game.PlaceId
    update["Device"] = "PC"

    local json = HttpService:JSONEncode(update)
    local res = requestFunc({
        Url = firebaseURL,
        Method = "PATCH",
        Headers = {["Content-Type"] = "application/json"},
        Body = json
    })

    if res.Success then
        print("✅ Firebase Updated for:", LocalPlayer.Name)
    else
        warn("❌ Firebase Error:", res.StatusMessage)
    end
end

UpdateToFirebase()

local controlURL = "https://veng-hub-default-rtdb.firebaseio.com/VENG.json?auth=" .. firebaseSecret  

textLabel.Text = "Pls wait for Firebase System"

local function CheckFirebaseStatus()  
    local response = requestFunc({  
        Url = controlURL,  
        Method = "GET"  
    })  

    if not response.Success then  
        warn("❌ Failed to check VENG status:", response.StatusMessage)  
        return  
    end  

    local data = HttpService:JSONDecode(response.Body)  

    -- Check Pause  
    if data.Pause == true then  
        warn("🛑 Veng Script Disabled (Paused by owner)")  
        ScriptPause = true
        return  
    end  

    -- Check Update  
    if data.Update == true then  
        warn("🕒 Veng Script is being updated...")  
        ScriptUpdate = true
        return  
    end  
    
    if data.notification == true then
        print(data.notificationtitle)
        showNotification(data.notificationtitle, 10)
    end

    print("✅ Veng Script check passed. Continuing...")  
end  

-- Run check  
CheckFirebaseStatus()

textLabel.Text = "Pls wait for Firebase Download Data"

local HttpService = game:GetService("HttpService")
local request = request or http_request or syn and syn.request

--  Firebase Secret + URL
local firebase_secret = "C0i5c0EoSGrkY9zWtkQL2nyUwLGazH5MKKA1elyr" --   secret 
local url = "https://veng-hub-default-rtdb.firebaseio.com/users.json?auth=" .. firebase_secret

--  Step 1: GET All Users from Firebase
local res = request({
    Url = url,
    Method = "GET",
    Headers = {
        ["Content-Type"] = "application/json"
    }
})

--  Step 2: Validate & Decode JSON
if not res or not res.Body or res.StatusCode ~= 200 then
    error(" Failed to get data from Firebase! Status: " .. tostring(res.StatusCode))
end

local users = {}
local success, err = pcall(function()
    users = HttpService:JSONDecode(res.Body)
end)

if not success or typeof(users) ~= "table" or next(users) == nil then
    error(" Cannot proceed. No users found")
end

--  Step 3: Count players by country
local countryCount = {}

for userId, info in pairs(users) do
    local country = info.country or "Unknown"
    local emoji = info.flag_emoji or "🏳️"

    -- filter out Unknown
    if country ~= "Unknown" then
        if not countryCount[country] then
            countryCount[country] = { count = 0, emoji = emoji }
        end
        countryCount[country].count += 1
    end
end

--  Step 4: Sort by highest player count
local sortedCountries = {}

for country, data in pairs(countryCount) do
    table.insert(sortedCountries, {
        country = country,
        emoji = data.emoji,
        count = data.count
    })
end

table.sort(sortedCountries, function(a, b)
    return a.count > b.count
end)

--  Step 5: Show Top 5 Countries
local HttpService = game:GetService("HttpService")

-- Firebase Config
local secret = "C0i5c0EoSGrkY9zWtkQL2nyUwLGazH5MKKA1elyr"
local firebaseURL = "https://veng-hub-default-rtdb.firebaseio.com/"
local usersPath = "users.json?auth=" .. secret

-- Use exploit-supported request function
local requestFunc = (http_request or request or (syn and syn.request))
if not requestFunc then
	warn("❌ Executor does not support HTTP requests.")
	return
end

-- Fetch all users
local function fetchUsers()
	local fullURL = firebaseURL .. usersPath
	local success, response = pcall(function()
		local res = requestFunc({
			Url = fullURL,
			Method = "GET"
		})
		return res.Body
	end)

	if not success then
		warn("❌ Failed to fetch users from Firebase")
		return nil
	end

	local decoded = HttpService:JSONDecode(response)
	if typeof(decoded) ~= "table" then
		warn("❌ Invalid Firebase data")
		return nil
	end

	return decoded
end

-- Build leaderboard
local function buildOpenScriptLeaderboard(users)
	local leaderboard = {}
	for username, data in pairs(users) do
		local count = tonumber(data.ScriptOpenCount or 0)
		table.insert(leaderboard, {
			name = username,
			count = count
		})
	end

	table.sort(leaderboard, function(a, b)
		return a.count > b.count
	end)

	return leaderboard
end

-- Store Top 10 in Tab2 string
local function displayTopOpenScript(leaderboard)
	local results = {}
	for b = 1, math.min(10, #leaderboard) do
		local entry = leaderboard[b]
		table.insert(results, b .. ". " .. entry.name .. " — " .. entry.count .. " times")
	end

	Tab2 = ""
	for _, line in ipairs(results) do
		Tab2 = Tab2 .. line .. "\n"
	end

	return Tab2
end

-- Main Run
local users = fetchUsers()
if users then
	local leaderboard = buildOpenScriptLeaderboard(users)
	Tab2 = displayTopOpenScript(leaderboard)


else
	warn("⚠️ No users found in Firebase")
end

for i = 1, math.min(1000, #sortedCountries) do
    local entry = sortedCountries[i]
    Top = Top .. string.format("%d. %s %s - %d players\n", i, entry.emoji, entry.country, entry.count)
end

task.delay(2, function()
    -- កែ TextLabel ជា "Done Firebase"
    textLabel.Text = "Done Firebase"
    wait(0.3)

    -- ប្រើលក្ខខណ្ឌ បើ script ត្រូវបាន pause
    if ScriptPause == true or ScriptUpdate == true then
        DisplayPopup("Script Update Or Pause", "⚠️ The script is temporarily paused for troubleshooting or repair.", true)
    else
        textLabel.Text = "Load Script Please Wait"
        wait(0.3)
        local Sound = Instance.new("Sound")
        Sound.Name = "VengMusic"
        Sound.SoundId = "rbxassetid://147722098" -- You can replace this ID
        Sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        Sound.Volume = 5
        Sound:Play()
        n2:Destroy()
        Keysystem()
    end
end)
end

local function status()

--// Services
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "DownloadWarning"
ScreenGui.DisplayOrder = 999999

--// Background blur
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 10

--// Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 460, 0, 250)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true

local corner = Instance.new("UICorner", Frame)
corner.CornerRadius = UDim.new(0, 16)

-- gradient
local gradient = Instance.new("UIGradient", Frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60,60,60))
}
gradient.Rotation = 90

-- animate
TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()

--// Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Text = "⚠️ WARNING"
Title.TextColor3 = Color3.fromRGB(255, 90, 90)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1

--// Message
local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Size = UDim2.new(1, -40, 0, 130)
TextLabel.Position = UDim2.new(0, 20, 0, 50)
TextLabel.TextWrapped = true
TextLabel.TextScaled = true
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.Gotham
TextLabel.Text = "Script needs to be downloaded. Ip or The country you are going to Firebase, So, if you don't agree, don't run this script."
TextLabel.BackgroundTransparency = 1

-- animate text color
local textTween = TweenService:Create(TextLabel, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
    TextColor3 = Color3.fromRGB(255, 150, 150)
})
textTween:Play()

--// Buttons
local Cancel = Instance.new("TextButton", Frame)
Cancel.Size = UDim2.new(0.4, 0, 0, 45)
Cancel.Position = UDim2.new(0.05, 0, 1, -55)
Cancel.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
Cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
Cancel.Font = Enum.Font.GothamBold
Cancel.Text = "CANCEL"
Cancel.AutoButtonColor = false

local cornerCancel = Instance.new("UICorner", Cancel)
cornerCancel.CornerRadius = UDim.new(0, 12)

local Run = Instance.new("TextButton", Frame)
Run.Size = UDim2.new(0.4, 0, 0, 45)
Run.Position = UDim2.new(0.55, 0, 1, -55)
Run.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
Run.TextColor3 = Color3.fromRGB(255, 255, 255)
Run.Font = Enum.Font.GothamBold
Run.Text = "RUN"
Run.AutoButtonColor = false

local cornerRun = Instance.new("UICorner", Run)
cornerRun.CornerRadius = UDim.new(0, 12)

-- button shadow
local strokeCancel = Instance.new("UIStroke", Cancel)
strokeCancel.Color = Color3.fromRGB(0,0,0)
strokeCancel.Thickness = 2
strokeCancel.Transparency = 0.4

local strokeRun = Instance.new("UIStroke", Run)
strokeRun.Color = Color3.fromRGB(0,0,0)
strokeRun.Thickness = 2
strokeRun.Transparency = 0.4

-- tooltips
local CancelTip = Instance.new("TextLabel", Cancel)
CancelTip.Size = UDim2.new(1,0,0,14)
CancelTip.Position = UDim2.new(0,0,-0.4,0)
CancelTip.Text = "Click to cancel this script"
CancelTip.TextColor3 = Color3.fromRGB(255,255,255)
CancelTip.TextScaled = true
CancelTip.Font = Enum.Font.Gotham
CancelTip.BackgroundTransparency = 1
CancelTip.Visible = false

local RunTip = Instance.new("TextLabel", Run)
RunTip.Size = UDim2.new(1,0,0,14)
RunTip.Position = UDim2.new(0,0,-0.4,0)
RunTip.Text = "Click to run this script"
RunTip.TextColor3 = Color3.fromRGB(255,255,255)
RunTip.TextScaled = true
RunTip.Font = Enum.Font.Gotham
RunTip.BackgroundTransparency = 1
RunTip.Visible = false

-- show tooltip
Cancel.MouseEnter:Connect(function()
    CancelTip.Visible = true
end)
Cancel.MouseLeave:Connect(function()
    CancelTip.Visible = false
end)
Run.MouseEnter:Connect(function()
    RunTip.Visible = true
end)
Run.MouseLeave:Connect(function()
    RunTip.Visible = false
end)

-- button hover + click
local function setupButton(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = btn.BackgroundColor3:Lerp(Color3.fromRGB(255,255,255), 0.2),
            TextColor3 = Color3.fromRGB(0,0,0)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = btn.BackgroundColor3,
            TextColor3 = Color3.fromRGB(255,255,255)
        }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(btn, TweenInfo.new(0.1), {
            Size = btn.Size + UDim2.new(0,10,0,5)
        })
        clickTween:Play()
        clickTween.Completed:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {
                Size = btn.Size
            }):Play()
        end)
    end)
end
setupButton(Cancel)
setupButton(Run)

-- button actions
Cancel.MouseButton1Click:Connect(function()
    TweenService:Create(Frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    wait(0.4)
    ScreenGui:Destroy()
    blur:Destroy()
end)

Run.MouseButton1Click:Connect(function()
    print("Run Script")
    TweenService:Create(Frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    wait(0.4)
    ScreenGui:Destroy()
    blur:Destroy()
    Lobby()
end)

end

status()
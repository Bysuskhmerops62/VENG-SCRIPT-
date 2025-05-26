local Library = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local tweeninfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local mouse = game.Players.LocalPlayer:GetMouse()
local focusing = false

-- Theme settings
local Theme = {
    Dark = {
        Main = Color3.fromRGB(30, 30, 30),
        TopBar = Color3.fromRGB(20, 20, 20),
        Content = Color3.fromRGB(40, 40, 40),
        Navigation = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(10, 10, 10), -- Black text
        Accent = Color3.fromRGB(0, 120, 215),
        Button = Color3.fromRGB(50, 50, 50),
        ButtonHover = Color3.fromRGB(70, 70, 70),
        ToggleOff = Color3.fromRGB(60, 60, 60),
        ToggleOn = Color3.fromRGB(0, 180, 80),
        Slider = Color3.fromRGB(60, 60, 60),
        SliderBar = Color3.fromRGB(0, 120, 215),
        Warning = Color3.fromRGB(214, 178, 14),
        Info = Color3.fromRGB(12, 170, 218),
        Stroke = Color3.fromRGB(80, 80, 80),
        Section = Color3.fromRGB(25, 25, 25)
    }
}

local CurrentTheme = Theme.Dark
local Utility = {}
local Objects = {}

-- Animation function with easing
function Library:Animate(object, properties, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.InOut
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = tween:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Library:DraggingEnabled(frame, parent)
    parent = parent or frame

    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position

            Library:Animate(frame, {BackgroundColor3 = CurrentTheme.Accent}, 0.1)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    Library:Animate(frame, {BackgroundColor3 = CurrentTheme.TopBar}, 0.2)
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

function Library:tween(object, goal, callback)
    local tween = tween:Create(object, tweeninfo2, goal)
    tween.Completed:Connect(callback or function() end)
    tween:Play()
end

local LibName = "UI_"..tostring(math.random(1, 100))..tostring(math.random(1,50))..tostring(math.random(1, 100))

function Library:ToggleUI()
    if game.CoreGui[LibName].Enabled then
        Library:Animate(game.CoreGui[LibName], {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        wait(0.2)
        game.CoreGui[LibName].Enabled = false
    else
        game.CoreGui[LibName].Enabled = true
        Library:Animate(game.CoreGui[LibName], {Size = UDim2.new(0, 400, 0, 228)}, 0.2)
    end
end

function Library:DestroyUI()
    if game:GetService("CoreGui"):FindFirstChild(LibName) then
        Library:Animate(game.CoreGui[LibName], {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        wait(0.2)
        game:GetService("CoreGui"):FindFirstChild(LibName):Destroy()
    end
end

function Library:Create(TitleText)
    TitleText = TitleText or "Untitled"

    local UILibrary = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Extension = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local UIPadding = Instance.new("UIPadding")
    local Close = Instance.new("ImageButton")
    local Line = Instance.new("Frame")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow = Instance.new("ImageLabel")
    local Navigation = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local Hide = Instance.new("Frame")
    local Hide2 = Instance.new("Frame")
    local ButtonHolder = Instance.new("Frame")
    local UIPadding_2 = Instance.new("UIPadding")
    local UIListLayout = Instance.new("UIListLayout")
    local Line_2 = Instance.new("Frame")
    local ContentContainer = Instance.new("Frame")
    local Fade = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local TabsFolder = Instance.new("Folder")

    Library:DraggingEnabled(TopBar, Main)

    UILibrary.Name = LibName
    UILibrary.Parent = game:GetService("CoreGui")
    UILibrary.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = UILibrary
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = CurrentTheme.Main
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 400, 0, 228)
    Main.ZIndex = 10

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.ZIndex = 11

    UICorner_2.CornerRadius = UDim.new(0, 6)
    UICorner_2.Parent = TopBar

    Extension.Name = "Extension"
    Extension.Parent = TopBar
    Extension.AnchorPoint = Vector2.new(0, 1)
    Extension.BackgroundColor3 = CurrentTheme.TopBar
    Extension.BorderSizePixel = 0
    Extension.Position = UDim2.new(0, 0, 1, 0)
    Extension.Size = UDim2.new(1, 0, 0.5, 0)
    Extension.ZIndex = 11

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Font = Enum.Font.Gotham
    Title.Text = TitleText
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 14.000
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 12

    UIPadding.Parent = Title
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 1)

    Close.Name = "Close"
    Close.Parent = TopBar
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 1.000
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 14, 0, 14)
    Close.Image = "rbxassetid://10884453403"
    Close.ImageColor3 = CurrentTheme.Text
    Close.ZIndex = 12
    
    Close.MouseButton1Click:Connect(function()
        Library:Animate(Close, {ImageTransparency = 1}, 0.1)
        wait()
        Library:Animate(Main, {
            Size = UDim2.new(0,0,0,0),
            Position = UDim2.new(0, Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2), 0, Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2))
        }, 0.1)
        ContentContainer.Visible = false
        Navigation.Visible = false
        DropShadowHolder.Visible = false
        TopBar.Visible = false
        wait(1.5)
        Library:DestroyUI()
    end)

    -- Add hover animation for close button
    Close.MouseEnter:Connect(function()
        Library:Animate(Close, {Rotation = 15}, 0.1)
    end)
    Close.MouseLeave:Connect(function()
        Library:Animate(Close, {Rotation = 0}, 0.1)
    end)

    Line.Name = "Line"
    Line.Parent = TopBar
    Line.AnchorPoint = Vector2.new(0, 1)
    Line.BackgroundColor3 = CurrentTheme.Stroke
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 0, 1, 0)
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.ZIndex = 11

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = Main
    DropShadowHolder.BackgroundTransparency = 1.000
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder.ZIndex = 0

    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1.000
    DropShadow.BorderSizePixel = 0
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 44, 1, 44)
    DropShadow.ZIndex = 0
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.500
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    Navigation.Name = "Navigation"
    Navigation.Parent = Main
    Navigation.BackgroundColor3 = CurrentTheme.Navigation
    Navigation.BorderSizePixel = 0
    Navigation.Position = UDim2.new(0, 0, 0, 30)
    Navigation.Size = UDim2.new(0, 120, 1, -30)
    Navigation.ZIndex = 10

    UICorner_3.CornerRadius = UDim.new(0, 6)
    UICorner_3.Parent = Navigation

    Hide.Name = "Hide"
    Hide.Parent = Navigation
    Hide.BackgroundColor3 = CurrentTheme.Navigation
    Hide.BorderSizePixel = 0
    Hide.Size = UDim2.new(1, 0, 0, 20)
    Hide.ZIndex = 10

    Hide2.Name = "Hide2"
    Hide2.Parent = Navigation
    Hide2.AnchorPoint = Vector2.new(1, 0)
    Hide2.BackgroundColor3 = CurrentTheme.Navigation
    Hide2.BorderSizePixel = 0
    Hide2.Position = UDim2.new(1, 0, 0, 0)
    Hide2.Size = UDim2.new(0, 20, 1, 0)
    Hide2.ZIndex = 10

    ButtonHolder.Name = "ButtonHolder"
    ButtonHolder.Parent = Navigation
    ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonHolder.BackgroundTransparency = 1.000
    ButtonHolder.Size = UDim2.new(1, 0, 1, 0)
    ButtonHolder.ZIndex = 10

    UIPadding_2.Parent = ButtonHolder
    UIPadding_2.PaddingBottom = UDim.new(0, 8)
    UIPadding_2.PaddingTop = UDim.new(0, 8)

    UIListLayout.Parent = ButtonHolder
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 1)

    Line_2.Name = "Line"
    Line_2.Parent = Navigation
    Line_2.BackgroundColor3 = CurrentTheme.Stroke
    Line_2.BorderSizePixel = 0
    Line_2.Position = UDim2.new(1, 0, 0, 0)
    Line_2.Size = UDim2.new(0, 1, 1, 0)
    Line_2.ZIndex = 10

    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.AnchorPoint = Vector2.new(1, 0)
    ContentContainer.BackgroundColor3 = CurrentTheme.Content
    ContentContainer.BackgroundTransparency = 1.000
    ContentContainer.Position = UDim2.new(1, -6, 0, 36)
    ContentContainer.Size = UDim2.new(1, -133, 1, -42)
    ContentContainer.ZIndex = 10

    Fade.Name = "Fade"
    Fade.Parent = ContentContainer
    Fade.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fade.BorderSizePixel = 0
    Fade.Size = UDim2.new(1, 0, 0, 30)
    Fade.Visible = false
    Fade.ZIndex = 10

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 40)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40)))}
    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.34, 0.24), NumberSequenceKeypoint.new(1.00, 1.00)}
    UIGradient.Parent = Fade

    TabsFolder.Name = "TabsFolder"
    TabsFolder.Parent = ContentContainer
    TabsFolder.ZIndex = 10

    local Tabs = {}
    
    local first = true

    function Tabs:Tab(TabText, TabIcon)
        TabText = TabText or "Untitled"
        TabIcon = TabIcon or ""

        local Active = Instance.new("TextButton")
        local UIPadding_3 = Instance.new("UIPadding")
        local Icon = Instance.new("ImageLabel")
        local NewTab = Instance.new("ScrollingFrame")
        local UIPadding_5 = Instance.new("UIPadding")
        local UIListLayout_2 = Instance.new("UIListLayout")

        Active.Name = TabText.."_TabButton"
        Active.Parent = ButtonHolder
        Active.BackgroundColor3 = CurrentTheme.Navigation
        Active.BackgroundTransparency = 1
        Active.BorderSizePixel = 0
        Active.Size = UDim2.new(1, 0, 0, 28)
        Active.Font = Enum.Font.Ubuntu
        Active.Text = TabText
        Active.TextColor3 = CurrentTheme.Text
        Active.TextSize = 12.000
        Active.TextXAlignment = Enum.TextXAlignment.Left
        Active.ZIndex = 11

        UIPadding_3.Parent = Active
        UIPadding_3.PaddingLeft = UDim.new(0, 28)

        Icon.Name = "Icon"
        Icon.Parent = Active
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon.BackgroundTransparency = 1.000
        Icon.Position = UDim2.new(0, -24, 0.5, 0)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Image = TabIcon
        Icon.ImageColor3 = CurrentTheme.Text
        Icon.ZIndex = 11

        NewTab.Name = "NewTab"
        NewTab.Parent = TabsFolder
        NewTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NewTab.BackgroundTransparency = 1.000
        NewTab.BorderSizePixel = 0
        NewTab.Selectable = false
        NewTab.Size = UDim2.new(1, 0, 1, 0)
        NewTab.AutomaticCanvasSize = "Y"
        NewTab.CanvasSize = UDim2.new(0, 0, 0, 0)
        NewTab.ScrollBarThickness = 0
        NewTab.Visible = false
        NewTab.ZIndex = 10

        UIPadding_5.Parent = NewTab
        UIPadding_5.PaddingBottom = UDim.new(0, 1)
        UIPadding_5.PaddingLeft = UDim.new(0, 1)
        UIPadding_5.PaddingRight = UDim.new(0, 1)
        UIPadding_5.PaddingTop = UDim.new(0, 1)

        UIListLayout_2.Parent = NewTab
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 6)
        
        if first then
            first = false
            NewTab.Visible = true
            Active.BackgroundTransparency = 0.9
            Active.BackgroundColor3 = CurrentTheme.Accent
            Active.TextColor3 = CurrentTheme.Text
        else
            NewTab.Visible = false
            Active.BackgroundTransparency = 1
            Active.TextColor3 = CurrentTheme.Text
        end

      Active.MouseButton1Click:Connect(function()
            for i,v in next, TabsFolder:GetChildren() do
                v.Visible = false
            end
            NewTab.Visible = true

            for i,v in next, ButtonHolder:GetChildren() do
                if v:IsA("TextButton") then
                    Library:Animate(v, {
                        BackgroundTransparency = 1,
                        BackgroundColor3 = CurrentTheme.Navigation
                    }, 0.2)
                    Library:Animate(v, {
                        TextColor3 = CurrentTheme.Text
                    }, 0.2)
                    if v:FindFirstChild("Icon") then
                        Library:Animate(v.Icon, {
                            ImageColor3 = CurrentTheme.Text
                        }, 0.2)
                    end
                end
            end
            
            Library:Animate(Active, {
                BackgroundTransparency = 0.9,
                BackgroundColor3 = CurrentTheme.Accent
            }, 0.2)
            Library:Animate(Active, {
                TextColor3 = CurrentTheme.Text
            }, 0.2)
            Library:Animate(Icon, {
                ImageColor3 = CurrentTheme.Text
            }, 0.2)
        end)
        
        -- Add hover animation for tabs
        Active.MouseEnter:Connect(function()
            if Active.BackgroundTransparency == 1 then
                Library:Animate(Active, {
                    BackgroundTransparency = 0.95,
                    BackgroundColor3 = CurrentTheme.ButtonHover
                }, 0.1)
            end
        end)
        
        Active.MouseLeave:Connect(function()
            if Active.BackgroundTransparency ~= 0.9 then
                Library:Animate(Active, {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = CurrentTheme.Navigation
                }, 0.1)
            end
        end)
        
        local Elements = {}
        
        function Elements:Section(title)
            title = title or "Section"

            local Section = Instance.new("Frame")
            local Title_idk = Instance.new("TextLabel")
            local Thing = Instance.new("TextLabel")
            local UIPadding_idk = Instance.new("UIPadding")
            local Thing2 = Instance.new("TextLabel")
            local UIPadding_idkk = Instance.new("UIPadding")
            local UIPadding_idkkk = Instance.new("UIPadding")

            Section.Name = "Section"
            Section.Parent = NewTab
            Section.BackgroundColor3 = CurrentTheme.Section
            Section.BackgroundTransparency = 1.000
            Section.Position = UDim2.new(0, 0, 0.430411309, 0)
            Section.Size = UDim2.new(1, 0, -0.0561393984, 32)
            Section.ZIndex = 10

            Title_idk.Name = "Title"
            Title_idk.Parent = Section
            Title_idk.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_idk.BackgroundTransparency = 1.000
            Title_idk.Position = UDim2.new(0.35253039, 0, -0.303296119, 0)
            Title_idk.Size = UDim2.new(0.339169234, -20, 1, 0)
            Title_idk.Font = Enum.Font.Ubuntu
            Title_idk.Text = title
            Title_idk.TextColor3 = CurrentTheme.Text
            Title_idk.TextSize = 14.000
            Title_idk.ZIndex = 10

            Thing.Name = "Thing"
            Thing.Parent = Section
            Thing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Thing.BackgroundTransparency = 1.000
            Thing.Position = UDim2.new(0.637247145, 0, -0.303296119, 0)
            Thing.Size = UDim2.new(0.307416946, -20, 1, 0)
            Thing.Font = Enum.Font.Ubuntu
            Thing.Text = "_____"
            Thing.TextColor3 = CurrentTheme.Text
            Thing.TextSize = 14.000
            Thing.ZIndex = 10

            UIPadding_idk.Parent = Thing
            UIPadding_idk.PaddingBottom = UDim.new(0, 10)

            Thing2.Name = "Thing2"
            Thing2.Parent = Section
            Thing2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Thing2.BackgroundTransparency = 1.000
            Thing2.Position = UDim2.new(0.0976673365, 0, -0.303296119, 0)
            Thing2.Size = UDim2.new(0.335968375, -20, 1, 0)
            Thing2.Font = Enum.Font.Ubuntu
            Thing2.Text = "_____"
            Thing2.TextColor3 = CurrentTheme.Text
            Thing2.TextSize = 14.000
            Thing2.ZIndex = 10

            UIPadding_idkk.Parent = Thing2
            UIPadding_idkk.PaddingBottom = UDim.new(0, 10)

            UIPadding_idkkk.Parent = Section
            UIPadding_idkkk.PaddingBottom = UDim.new(0, 6)
            UIPadding_idkkk.PaddingLeft = UDim.new(0, 6)
            UIPadding_idkkk.PaddingRight = UDim.new(0, 6)
            UIPadding_idkkk.PaddingTop = UDim.new(0, 6)
            
            -- Animation when section is added
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, 0, 0, 0)
            Library:Animate(Section, {
                BackgroundTransparency = 0,
                Size = UDim2.new(1, 0, -0.0561393984, 32)
            }, 0.2)
        end
  
  function Elements:Button(ButtonName, callback)
            ButtonName = ButtonName or "Button"
            callback = callback or function() end

            local Button = Instance.new("TextButton")
            local UICorner_4 = Instance.new("UICorner")
            local Title_2 = Instance.new("TextLabel")
            local UIPadding_5 = Instance.new("UIPadding")
            local Sample = Instance.new("ImageLabel")
            local Icon_2 = Instance.new("ImageLabel")
            local UIStroke = Instance.new("UIStroke")

            local modules = {}
            table.insert(modules, ButtonName)

            Button.Name = "Button"
            Button.Parent = NewTab
            Button.BackgroundColor3 = CurrentTheme.Button
            Button.ClipsDescendants = true
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.SourceSans
            Button.Text = ""
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14.000
            Button.ZIndex = 10
            Objects[Button] = "BackgroundColor3"

            UICorner_4.CornerRadius = UDim.new(0, 4)
            UICorner_4.Parent = Button

            Title_2.Name = "Title"
            Title_2.Parent = Button
            Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_2.BackgroundTransparency = 1.000
            Title_2.Size = UDim2.new(1, -20, 1, 0)
            Title_2.Font = Enum.Font.Ubuntu
            Title_2.Text = ButtonName
            Title_2.TextColor3 = CurrentTheme.Text
            Title_2.TextSize = 14.000
            Title_2.TextXAlignment = Enum.TextXAlignment.Left
            Title_2.ZIndex = 10

            UIPadding_5.Parent = Button
            UIPadding_5.PaddingBottom = UDim.new(0, 6)
            UIPadding_5.PaddingLeft = UDim.new(0, 6)
            UIPadding_5.PaddingRight = UDim.new(0, 6)
            UIPadding_5.PaddingTop = UDim.new(0, 6)

            Sample.Name = "Sample"
            Sample.Parent = Button
            Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sample.BackgroundTransparency = 1.000
            Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
            Sample.ImageColor3 = Color3.fromRGB(0, 0, 0)
            Objects[Sample] = "ImageColor3"
            Sample.ImageTransparency = 0.600
            Sample.ZIndex = 10

            Icon_2.Name = "Icon"
            Icon_2.Parent = Button
            Icon_2.AnchorPoint = Vector2.new(1, 0)
            Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_2.BackgroundTransparency = 1.000
            Icon_2.Position = UDim2.new(1, 0, 0, 0)
            Icon_2.Size = UDim2.new(0, 20, 0, 20)
            Icon_2.Image = "rbxassetid://10888474558"
            Icon_2.ImageColor3 = CurrentTheme.Text
            Icon_2.ZIndex = 10

            UIStroke.Name = "UIStroke"
            UIStroke.Parent = Button
            UIStroke.ApplyStrokeMode = "Border"
            UIStroke.Color = CurrentTheme.Stroke
            UIStroke.LineJoinMode = "Round"
            UIStroke.Thickness = 1
            UIStroke.Transparency = 0
            UIStroke.ZIndex = 10

            local ms = game.Players.LocalPlayer:GetMouse()

            local btn  = Button
            local sample  = Sample

            btn.MouseButton1Click:Connect(function()
                if not focusing then
                    callback()
                    local c = sample:Clone()
                    c.Parent = btn
                    local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                    c.Position = UDim2.new(0, x, 0, y)
                    local len, size = 0.35, nil
                    if btn.AbsoluteSize.X >= btn.AbsoluteSize.Y then
                        size = (btn.AbsoluteSize.X * 1.5)
                    else
                        size = (btn.AbsoluteSize.Y * 1.5)
                    end
                    c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                    for i = 1, 10 do
                        c.ImageTransparency = c.ImageTransparency + 0.05
                        wait(len / 12)
                    end
                    c:Destroy()
                end
            end)
            local hovering = false
            btn.MouseEnter:Connect(function()
                if not focusing then
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.ButtonHover
                    }, 0.1)
                    Library:Animate(UIStroke, {
                        Color = CurrentTheme.Accent
                    }, 0.1)
                    hovering = true
                end
            end)
            btn.MouseLeave:Connect(function()
                if not focusing then 
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.Button
                    }, 0.1)
                    Library:Animate(UIStroke, {
                        Color = CurrentTheme.Stroke
                    }, 0.1)
                    hovering = false
                end
            end)
            
            -- Animation when button is added
            Button.Size = UDim2.new(1, 0, 0, 0)
            Button.BackgroundTransparency = 1
            Library:Animate(Button, {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 0
            }, 0.2)
        end
        
        function Elements:TextBox(TextBoxTitle, callback)
            TextBoxTitle = TextBoxTitle or "TextBox"
            callback = callback or function() end
            
            local TextBox = Instance.new("TextButton")
            local UICorner_34 = Instance.new("UICorner")
            local Title_12 = Instance.new("TextLabel")
            local UIPadding_20 = Instance.new("UIPadding")
            local UIStroke_9 = Instance.new("UIStroke")
            local TextBox_2 = Instance.new("TextBox")
            local UICorner_35 = Instance.new("UICorner")
            local UIStroke_10 = Instance.new("UIStroke")
            
            TextBox.Name = "TextBox"
            TextBox.Parent = NewTab
            TextBox.BackgroundColor3 = CurrentTheme.Button
            TextBox.ClipsDescendants = true
            TextBox.Size = UDim2.new(1, 0, 0, 32)
            TextBox.AutoButtonColor  = false
            TextBox.Font = Enum.Font.SourceSans
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextBox.TextSize = 14.000
            TextBox.ZIndex = 10
            
            UICorner_34.CornerRadius = UDim.new(0, 4)
            UICorner_34.Parent = TextBox

            Title_12.Name = "Title"
            Title_12.Parent = TextBox
            Title_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_12.BackgroundTransparency = 1.000
            Title_12.Size = UDim2.new(0.750988126, -20, 1, 0)
            Title_12.Font = Enum.Font.Ubuntu
            Title_12.Text = TextBoxTitle
            Title_12.TextColor3 = CurrentTheme.Text
            Title_12.TextSize = 14.000
            Title_12.TextXAlignment = Enum.TextXAlignment.Left
            Title_12.ZIndex = 10

            UIPadding_20.Parent = TextBox
            UIPadding_20.PaddingBottom = UDim.new(0, 6)
            UIPadding_20.PaddingLeft = UDim.new(0, 6)
            UIPadding_20.PaddingRight = UDim.new(0, 6)
            UIPadding_20.PaddingTop = UDim.new(0, 6)
            
            UIStroke_9.Name = "UIStroke"
            UIStroke_9.Parent = TextBox
            UIStroke_9.ApplyStrokeMode = "Border"
            UIStroke_9.Color = CurrentTheme.Stroke
            UIStroke_9.LineJoinMode = "Round"
            UIStroke_9.Thickness = 1
            UIStroke_9.Transparency = 0
            UIStroke_9.ZIndex = 10

            TextBox_2.Parent = TextBox
            TextBox_2.BackgroundColor3 = CurrentTheme.Content
            TextBox_2.BorderSizePixel = 0
            TextBox_2.ClipsDescendants = true
            TextBox_2.Position = UDim2.new(0.691699624, 0, 0, 0)
            TextBox_2.Size = UDim2.new(0, 75, 0, 20)
            TextBox_2.ZIndex = 99
            TextBox_2.ClearTextOnFocus = false
            TextBox_2.Font = Enum.Font.Ubuntu
            TextBox_2.PlaceholderText = "Type here!"
            TextBox_2.Text = ""
            TextBox_2.TextColor3 = CurrentTheme.Text
            TextBox_2.TextSize = 12.000

            UICorner_35.Parent = TextBox_2
            
            UIStroke_10.Name = "UIStroke"
            UIStroke_10.Parent = TextBox_2
            UIStroke_10.ApplyStrokeMode = "Border"
            UIStroke_10.Color = CurrentTheme.Stroke
            UIStroke_10.LineJoinMode = "Round"
            UIStroke_10.Thickness = 1
            UIStroke_10.Transparency = 0
            UIStroke_10.ZIndex = 99
            
            local btn = TextBox
            
            local hovering = false
            btn.MouseEnter:Connect(function()
                if not focusing then
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.ButtonHover
                    }, 0.1)
                    Library:Animate(UIStroke_9, {
                        Color = CurrentTheme.Accent
                    }, 0.1)
                    hovering = true
                end 
            end)
            btn.MouseLeave:Connect(function()
                if not focusing then
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.Button
                    }, 0.1)
                    Library:Animate(UIStroke_9, {
                        Color = CurrentTheme.Stroke
                    }, 0.1)
                    hovering = false
                end
            end)
            
            TextBox_2.FocusLost:Connect(function(EnterPressed)
                if not EnterPressed then 
                    return
                else
                    callback(TextBox_2.Text)
                    wait(0.18)
                    TextBox.Text = ""  
                end
            end)
            
            -- Animation when textbox is added
            TextBox.Size = UDim2.new(1, 0, 0, 0)
            TextBox.BackgroundTransparency = 1
            Library:Animate(TextBox, {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 0
            }, 0.2)
        end

        function Elements:Toggle(ToggleName, callback)
            ToggleName = ToggleName or "Toggle"
            callback = callback or function() end

            local Toggle = Instance.new("TextButton")
            local UICorner_8 = Instance.new("UICorner")
            local Title_6 = Instance.new("TextLabel")
            local UIPadding_13 = Instance.new("UIPadding")
            local CheckmarkHolder = Instance.new("Frame")
            local UICorner_9 = Instance.new("UICorner")
            local UIStroke_2 = Instance.new("UIStroke")
            local Sample = Instance.new("ImageLabel")
            local UIStroke_3 = Instance.new("UIStroke")

            Toggle.Name = "Toggle"
            Toggle.Parent = NewTab
            Toggle.BackgroundColor3 = CurrentTheme.Button
            Toggle.ClipsDescendants = true
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000
            Toggle.ZIndex = 10

            UICorner_8.CornerRadius = UDim.new(0, 4)
            UICorner_8.Parent = Toggle

            Title_6.Name = "Title"
            Title_6.Parent = Toggle
            Title_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_6.BackgroundTransparency = 1.000
            Title_6.Size = UDim2.new(1, -26, 1, 0)
            Title_6.Font = Enum.Font.Ubuntu
            Title_6.Text = ToggleName
            Title_6.TextColor3 = CurrentTheme.Text
            Title_6.TextSize = 14.000
            Title_6.TextXAlignment = Enum.TextXAlignment.Left
            Title_6.ZIndex = 10

            UIPadding_13.Parent = Toggle
            UIPadding_13.PaddingBottom = UDim.new(0, 6)
            UIPadding_13.PaddingLeft = UDim.new(0, 6)
            UIPadding_13.PaddingRight = UDim.new(0, 6)
            UIPadding_13.PaddingTop = UDim.new(0, 6)

            UIStroke_2.Name = "UIStroke"
            UIStroke_2.Parent = Toggle
            UIStroke_2.ApplyStrokeMode = "Border"
            UIStroke_2.Color = CurrentTheme.Stroke
            UIStroke_2.LineJoinMode = "Round"
            UIStroke_2.Thickness = 1
            UIStroke_2.Transparency = 0
            UIStroke_2.ZIndex = 10

            Sample.Name = "Sample"
            Sample.Parent = Toggle
            Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sample.BackgroundTransparency = 1.000
            Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
            Sample.ImageColor3 = Color3.fromRGB(0, 0, 0)
            Sample.ImageTransparency = 0.600
            Sample.ZIndex = 10

            CheckmarkHolder.Name = "CheckmarkHolder"
            CheckmarkHolder.Parent = Toggle
            CheckmarkHolder.AnchorPoint = Vector2.new(1, 0.5)
            CheckmarkHolder.BackgroundColor3 = CurrentTheme.ToggleOff
            CheckmarkHolder.Position = UDim2.new(1, -3, 0.5, 0)
            CheckmarkHolder.Size = UDim2.new(0, 16, 0, 16)
            CheckmarkHolder.ZIndex = 10

            UICorner_9.CornerRadius = UDim.new(0, 2)
            UICorner_9.Parent = CheckmarkHolder

            UIStroke_3.Name = "UIStroke"
            UIStroke_3.Parent = CheckmarkHolder
            UIStroke_3.ApplyStrokeMode = "Border"
            UIStroke_3.Color = CurrentTheme.Stroke
            UIStroke_3.LineJoinMode = "Round"
            UIStroke_3.Thickness = 1
            UIStroke_3.Transparency = 0
            UIStroke_3.ZIndex = 10

            local ms = game.Players.LocalPlayer:GetMouse()

            local btn  = Toggle
            local sample  = Sample
            local focusing = false

            local toggled = false
            Toggle.MouseButton1Click:Connect(function()
                if not focusing then
                    if toggled == false then
                        Library:Animate(CheckmarkHolder, {
                            BackgroundColor3 = CurrentTheme.ToggleOn
                        }, 0.15)
                        Library:Animate(UIStroke_3, {
                            Color = CurrentTheme.Accent
                        }, 0.15)
                        local c = sample:Clone()
                        c.Parent = btn
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local len, size = 0.35, nil
                        if btn.AbsoluteSize.X >= btn.AbsoluteSize.Y then
                            size = (btn.AbsoluteSize.X * 1.5)
                        else
                            size = (btn.AbsoluteSize.Y * 1.5)
                        end
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    else
                    
                    Library:Animate(CheckmarkHolder, {
                            BackgroundColor3 = CurrentTheme.ToggleOff
                        }, 0.15)
                        Library:Animate(UIStroke_3, {
                            Color = CurrentTheme.Stroke
                        }, 0.15)
                        local c = sample:Clone()
                        c.Parent = btn
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local len, size = 0.35, nil
                        if btn.AbsoluteSize.X >= btn.AbsoluteSize.Y then
                            size = (btn.AbsoluteSize.X * 1.5)
                        else
                            size = (btn.AbsoluteSize.Y * 1.5)
                        end
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    end
                    toggled = not toggled
                    pcall(callback, toggled)
                end
            end)
            local hovering = false
            btn.MouseEnter:Connect(function()
                if not focusing then
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.ButtonHover
                    }, 0.1)
                    Library:Animate(UIStroke_2, {
                        Color = CurrentTheme.Accent
                    }, 0.1)
                    hovering = true
                end 
            end)
            btn.MouseLeave:Connect(function()
                if not focusing then
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.Button
                    }, 0.1)
                    Library:Animate(UIStroke_2, {
                        Color = CurrentTheme.Stroke
                    }, 0.1)
                    hovering = false
                end
            end)
            
            -- Animation when toggle is added
            Toggle.Size = UDim2.new(1, 0, 0, 0)
            Toggle.BackgroundTransparency = 1
            Library:Animate(Toggle, {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 0
            }, 0.2)
        end

        function Elements:Slider(SliderTitle, minvalue, maxvalue, callback)
            SliderTitle = SliderTitle or "Slider"
            minvalue = minvalue or 0
            maxvalue = maxvalue or 100
            callback = callback or function() end
            local Value;
            local moveconnection;
            local releaseconnection;

            local Slider = Instance.new("Frame")
            local UICorner_12 = Instance.new("UICorner")
            local UIStroke_4 = Instance.new("UIStroke")
            local Title_8 = Instance.new("TextLabel")
            local UIPadding_15 = Instance.new("UIPadding")
            local Valuee = Instance.new("TextLabel")
            local SliderButton = Instance.new("TextButton")
            local UIStroke_5 = Instance.new("UIStroke")
            local SliderInner = Instance.new("Frame")
            local UICorner_13 = Instance.new("UICorner")
            local UICorner_14 = Instance.new("UICorner")

            Slider.Name = "Slider"
            Slider.Parent = NewTab
            Slider.BackgroundColor3 = CurrentTheme.Button
            Slider.Size = UDim2.new(1, 0, 0, 38)
            Slider.ZIndex = 10

            UICorner_12.CornerRadius = UDim.new(0, 4)
            UICorner_12.Parent = Slider

            UIStroke_4.Name = "UIStroke"
            UIStroke_4.Parent = Slider
            UIStroke_4.ApplyStrokeMode = "Border"
            UIStroke_4.Color = CurrentTheme.Stroke
            UIStroke_4.LineJoinMode = "Round"
            UIStroke_4.Thickness = 1
            UIStroke_4.Transparency = 0
            UIStroke_4.ZIndex = 10

            Title_8.Name = "Title"
            Title_8.Parent = Slider
            Title_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_8.BackgroundTransparency = 1.000
            Title_8.Size = UDim2.new(1, -24, 1, -10)
            Title_8.Font = Enum.Font.Ubuntu
            Title_8.Text = SliderTitle
            Title_8.TextColor3 = CurrentTheme.Text
            Title_8.TextSize = 14.000
            Title_8.TextXAlignment = Enum.TextXAlignment.Left
            Title_8.ZIndex = 10

            UIPadding_15.Parent = Slider
            UIPadding_15.PaddingBottom = UDim.new(0, 6)
            UIPadding_15.PaddingLeft = UDim.new(0, 6)
            UIPadding_15.PaddingRight = UDim.new(0, 6)
            UIPadding_15.PaddingTop = UDim.new(0, 6)

            Valuee.Name = "Value"
            Valuee.Parent = Slider
            Valuee.AnchorPoint = Vector2.new(1, 0)
            Valuee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Valuee.BackgroundTransparency = 1.000
            Valuee.Position = UDim2.new(1, 0, 0, 0)
            Valuee.Size = UDim2.new(0, 24, 1, -10)
            Valuee.Font = Enum.Font.Ubuntu
            Valuee.Text = minvalue
            Valuee.TextColor3 = CurrentTheme.Text
            Valuee.TextSize = 14.000
            Valuee.TextXAlignment = Enum.TextXAlignment.Right
            Valuee.ZIndex = 10

            SliderButton.Name = "SliderButton"
            SliderButton.Parent = Slider
            SliderButton.BackgroundColor3 = CurrentTheme.Slider
            SliderButton.BackgroundTransparency = 1
            SliderButton.Position = UDim2.new(0, 0, 0.846153855, 0)
            SliderButton.Size = UDim2.new(0, 253, 0, 4)
            SliderButton.Font = Enum.Font.SourceSans
            SliderButton.Text = ""
            SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            SliderButton.TextSize = 14.000
            SliderButton.ZIndex = 10

            UIStroke_5.Name = "UIStroke"
            UIStroke_5.Parent = SliderButton
            UIStroke_5.ApplyStrokeMode = "Border"
            UIStroke_5.Color = CurrentTheme.Stroke
            UIStroke_5.LineJoinMode = "Round"
            UIStroke_5.Thickness = 1
            UIStroke_5.Transparency = 0
            UIStroke_5.ZIndex = 10

            SliderInner.Name = "SliderInner"
            SliderInner.Parent = SliderButton
            SliderInner.BackgroundColor3 = CurrentTheme.SliderBar
            SliderInner.Size = UDim2.new(0, 0, 0, 4)
            SliderInner.ZIndex = 10

            UICorner_13.CornerRadius = UDim.new(0, 4)
            UICorner_13.Parent = SliderInner

            UICorner_14.CornerRadius = UDim.new(0, 4)
            UICorner_14.Parent = SliderButton

            SliderButton.MouseButton1Down:Connect(function()
                if not focusing then
                    Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 255) * SliderInner.AbsoluteSize.X) + tonumber(minvalue)) or 0
                    pcall(function()
                        callback(Value)
                    end)
                    SliderInner.Size = UDim2.new(0, math.clamp(mouse.X - SliderInner.AbsolutePosition.X, 0, 255), 0, 4.5)
                    moveconnection = mouse.Move:Connect(function()
                        Valuee.Text = Value
                        Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 255) * SliderInner.AbsoluteSize.X) + tonumber(minvalue))
                        pcall(function()
                            callback(Value)
                        end)
                        SliderInner.Size = UDim2.new(0, math.clamp(mouse.X - SliderInner.AbsolutePosition.X, 0, 255), 0, 4.5)
                    end)
                    releaseconnection = input.InputEnded:Connect(function(Mouse)
                        if Mouse.UserInputType == Enum.UserInputType.MouseButton1 or Mouse.UserInputType == Enum.UserInputType.Touch then
                            Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 255) * SliderInner.AbsoluteSize.X) + tonumber(minvalue))
                            pcall(function()
                                callback(Value)
                            end)
                            SliderInner.Size = UDim2.new(0, math.clamp(mouse.X - SliderInner.AbsolutePosition.X, 0, 255), 0, 4.5)
                            moveconnection:Disconnect()
                            releaseconnection:Disconnect()
                        end
                    end)
                end
            end)
            
            -- Animation when slider is added
            Slider.Size = UDim2.new(1, 0, 0, 0)
            Slider.BackgroundTransparency = 1
            Library:Animate(Slider, {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundTransparency = 0
            }, 0.2)
        end
        
        function Elements:Keybind(KeybindTitle, first, callback)
            KeybindTitle = KeybindTitle or "Untitled"
            callback = callback or function() end
            
            local oldKey = first.Name
            local Keybind = Instance.new("TextButton")
            local UICorner_36 = Instance.new("UICorner")
            local Title_14 = Instance.new("TextLabel")
            local UIPadding_24 = Instance.new("UIPadding")
            local Sample = Instance.new("ImageLabel")
            local Box = Instance.new("Frame")
            local UICorner_37 = Instance.new("UICorner")
            local KeybindC = Instance.new("TextLabel")
            local UIPadding_25 = Instance.new("UIPadding")
            local UIStroke_Idk791 = Instance.new("UIStroke")
            local UIStroke_qqqaa = Instance.new("UIStroke")
            
            local ms = game.Players.LocalPlayer:GetMouse()
            local uis = game:GetService("UserInputService")
            
            local sample = Sample
            local btn = Keybind
            
            Keybind.Name = "Keybind"
            Keybind.Parent = NewTab
            Keybind.BackgroundColor3 = CurrentTheme.Button
            Keybind.ClipsDescendants = true
            Keybind.Size = UDim2.new(1, 0, 0, 32)
            Keybind.AutoButtonColor = false
            Keybind.Font = Enum.Font.SourceSans
            Keybind.Text = ""
            Keybind.TextColor3 = Color3.fromRGB(0, 0, 0)
            Keybind.TextSize = 14.000
            Keybind.ZIndex = 10
            Keybind.MouseButton1Click:connect(function() 
                if not focusing then
                    KeybindC.Text = ". . ."
                    local a, b = game:GetService('UserInputService').InputBegan:wait();
                    if a.KeyCode.Name ~= "Unknown" then
                        KeybindC.Text = a.KeyCode.Name
                        oldKey = a.KeyCode.Name;
                    end
                    local c = sample:Clone()
                    c.Parent = btn
                    local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                    c.Position = UDim2.new(0, x, 0, y)
                    local len, size = 0.35, nil
                    if btn.AbsoluteSize.X >= btn.AbsoluteSize.Y then
                        size = (btn.AbsoluteSize.X * 1.5)
                    else
                        size = (btn.AbsoluteSize.Y * 1.5)
                    end
                    c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                    for i = 1, 10 do
                        c.ImageTransparency = c.ImageTransparency + 0.05
                        wait(len / 12)
                    end
                    c:Destroy()
                end
            end)

            game:GetService("UserInputService").InputBegan:connect(function(current, ok) 
                if not ok then 
                    if current.KeyCode.Name == oldKey then 
                        callback()
                    end
                end
            end)
            local hovering = false
            btn.MouseEnter:Connect(function()
                if not focusing then
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.ButtonHover
                    }, 0.1)
                    Library:Animate(UIStroke_Idk791, {
                        Color = CurrentTheme.Accent
                    }, 0.1)
                    hovering = true
                end 
            end)
            btn.MouseLeave:Connect(function()
                if not focusing then
                    Library:Animate(btn, {
                        BackgroundColor3 = CurrentTheme.Button
                    }, 0.1)
                    Library:Animate(UIStroke_Idk791, {
                        Color = CurrentTheme.Stroke
                    }, 0.1)
                    hovering = false
                end
            end)

            UICorner_36.CornerRadius = UDim.new(0, 4)
            UICorner_36.Parent = Keybind

            Title_14.Name = "Title"
            Title_14.Parent = Keybind
            Title_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_14.BackgroundTransparency = 1.000
            Title_14.Size = UDim2.new(1, -20, 1, 0)
            Title_14.Font = Enum.Font.Ubuntu
            Title_14.Text = KeybindTitle
            Title_14.TextColor3 = CurrentTheme.Text
            Title_14.TextSize = 14.000
            Title_14.TextXAlignment = Enum.TextXAlignment.Left
            Title_14.ZIndex = 10

            UIPadding_24.Parent = Keybind
            UIPadding_24.PaddingBottom = UDim.new(0, 6)
            UIPadding_24.PaddingLeft = UDim.new(0, 6)
            UIPadding_24.PaddingRight = UDim.new(0, 6)
            UIPadding_24.PaddingTop = UDim.new(0, 6)
            
            UIStroke_Idk791.Name = "UIStroke"
            UIStroke_Idk791.Parent = Keybind
            UIStroke_Idk791.ApplyStrokeMode = "Border"
            UIStroke_Idk791.Color = CurrentTheme.Stroke
            UIStroke_Idk791.LineJoinMode = "Round"
            UIStroke_Idk791.Thickness = 1
            UIStroke_Idk791.Transparency = 0
            UIStroke_Idk791.ZIndex = 10

            Sample.Name = "Sample"
            Sample.Parent = Keybind
            Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sample.BackgroundTransparency = 1.000
            Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
            Sample.ImageColor3 = Color3.fromRGB(0, 0, 0)
            Sample.ImageTransparency = 0.600
            Sample.ZIndex = 10

            Box.Name = "Box"
            Box.Parent = Keybind
            Box.BackgroundColor3 = CurrentTheme.Content
            Box.BackgroundTransparency = 0.900
            Box.BorderColor3 = CurrentTheme.Stroke
            Box.Position = UDim2.new(0.897233188, 0, 0, 0)
            Box.Size = UDim2.new(0, 22, 0, 20)
            Box.ZIndex = 10

            UICorner_37.CornerRadius = UDim.new(0, 4)
            UICorner_37.Parent = Box
            
            UIStroke_qqqaa.Name = "UIStroke"
            UIStroke_qqqaa.Parent = Box
            UIStroke_qqqaa.ApplyStrokeMode = "Border"
            UIStroke_qqqaa.Color = CurrentTheme.Stroke
            UIStroke_qqqaa.LineJoinMode = "Round"
            UIStroke_qqqaa.Thickness = 1
            UIStroke_qqqaa.Transparency = 0
            UIStroke_qqqaa.ZIndex = 10

            KeybindC.Name = "KeybindC"
            KeybindC.Parent = Keybind
            KeybindC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            KeybindC.BackgroundTransparency = 1.000
            KeybindC.Position = UDim2.new(0.897233188, 0, 0, 0)
            KeybindC.Size = UDim2.new(0, 26, 0, 20)
            KeybindC.Font = Enum.Font.SourceSans
            KeybindC.Text = oldKey
            KeybindC.TextColor3 = CurrentTheme.Text
            KeybindC.TextSize = 14.000
            KeybindC.ZIndex = 10

            UIPadding_25.Parent = KeybindC
            UIPadding_25.PaddingRight = UDim.new(0, 4)
            
            -- Animation when keybind is added
            Keybind.Size = UDim2.new(1, 0, 0, 0)
            Keybind.BackgroundTransparency = 1
            Library:Animate(Keybind, {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 0
            }, 0.2)
        end

        function Elements:WarningLabel(WarningText)
            WarningText = WarningText or "This is a warning"

            local WarningLabell = {}
            
            local Warning = Instance.new("Frame")
            local UIPadding_7 = Instance.new("UIPadding")
            local Title_3 = Instance.new("TextLabel")
            local Icon_4 = Instance.new("ImageLabel")
            local UIPadding_8 = Instance.new("UIPadding")
            local UICorner_5 = Instance.new("UICorner")
            local UIStroke_6 = Instance.new("UIStroke")

            Warning.Name = "Warning"
            Warning.Parent = NewTab
            Warning.BackgroundColor3 = CurrentTheme.Warning
            Warning.Size = UDim2.new(1, 0, 0, 26)
            Warning.ZIndex = 10

            UIPadding_7.Parent = Warning
            UIPadding_7.PaddingBottom = UDim.new(0, 6)
            UIPadding_7.PaddingLeft = UDim.new(0, 6)
            UIPadding_7.PaddingRight = UDim.new(0, 6)
            UIPadding_7.PaddingTop = UDim.new(0, 6)

            Title_3.Name = "Title"
            Title_3.Parent = Warning
            Title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_3.BackgroundTransparency = 1.000
            Title_3.Size = UDim2.new(1, 0, 1, 0)
            Title_3.Font = Enum.Font.Ubuntu
            Title_3.Text = WarningText
            Title_3.TextColor3 = CurrentTheme.Text
            Title_3.TextSize = 14.000
            Title_3.TextWrapped = true
            Title_3.TextXAlignment = Enum.TextXAlignment.Left
            Title_3.TextYAlignment = Enum.TextYAlignment.Top
            Title_3.ZIndex = 10

            Icon_4.Name = "Icon"
            Icon_4.Parent = Title_3
            Icon_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_4.BackgroundTransparency = 1.000
            Icon_4.Position = UDim2.new(0, -20, 0, 0)
            Icon_4.Size = UDim2.new(0, 14, 0, 14)
            Icon_4.Image = "rbxassetid://10889384842"
            Icon_4.ImageColor3 = CurrentTheme.Warning
            Icon_4.ZIndex = 10

            UIPadding_8.Parent = Title_3
            UIPadding_8.PaddingLeft = UDim.new(0, 20)

            UICorner_5.CornerRadius = UDim.new(0, 4)
            UICorner_5.Parent = Warning

            UIStroke_6.Name = "UIStroke"
            UIStroke_6.Parent = Warning
            UIStroke_6.ApplyStrokeMode = "Border"
            UIStroke_6.Color = CurrentTheme.Warning
            UIStroke_6.LineJoinMode = "Round"
            UIStroke_6.Thickness = 1
            UIStroke_6.Transparency = 0
            UIStroke_6.ZIndex = 10

            function WarningLabell:SetText(WarningLabelSetText)
                WarningText = WarningLabelSetText
                WarningLabell:_update()
            end

            function WarningLabell:_update()
                Title_3.Text = WarningText

                Title_3.Size = UDim2.new(Title_3.Size.X.Scale, Title_3.Size.X.Offset, 0, math.huge)
                Title_3.Size = UDim2.new(Title_3.Size.X.Scale, Title_3.Size.X.Offset, 0, Title_3.TextBounds.Y)
                Library:tween(Warning, {Size = UDim2.new(Warning.Size.X.Scale, Warning.Size.X.Offset, 0, Title_3.TextBounds.Y + 12)})
            end

            WarningLabell:_update()
            
            -- Animation when warning is added
            Warning.Size = UDim2.new(1, 0, 0, 0)
            Warning.BackgroundTransparency = 1
            Library:Animate(Warning, {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 0
            }, 0.2)
            return WarningLabell
        end

        function Elements:InfoLabel(InfoText)
            InfoText = InfoText or "This is a info"

            local InfoLabell = {}

            local Info = Instance.new("Frame")
            local UIPadding_9 = Instance.new("UIPadding")
            local Title_4 = Instance.new("TextLabel")
            local Icon_5 = Instance.new("ImageLabel")
            local UIPadding_10 = Instance.new("UIPadding")
            local UICorner_6 = Instance.new("UICorner")
            local UIStroke_7 = Instance.new("UIStroke")

            Info.Name = "Info"
            Info.Parent = NewTab
            Info.BackgroundColor3 = CurrentTheme.Info
            Info.Size = UDim2.new(1, 0, 0, 26)
            Info.ZIndex = 10

            UIPadding_9.Parent = Info
            UIPadding_9.PaddingBottom = UDim.new(0, 6)
            UIPadding_9.PaddingLeft = UDim.new(0, 6)
            UIPadding_9.PaddingRight = UDim.new(0, 6)
            UIPadding_9.PaddingTop = UDim.new(0, 6)

            Title_4.Name = "Title"
            Title_4.Parent = Info
            Title_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_4.BackgroundTransparency = 1.000
            Title_4.Size = UDim2.new(1, 0, 1, 0)
            Title_4.Font = Enum.Font.Ubuntu
            Title_4.Text = InfoText
            Title_4.TextWrapped = true
            Title_4.TextColor3 = CurrentTheme.Text
            Title_4.TextSize = 14.000
            Title_4.TextXAlignment = Enum.TextXAlignment.Left
            Title_4.TextYAlignment = Enum.TextYAlignment.Top
            Title_4.ZIndex = 10

            Icon_5.Name = "Icon"
            Icon_5.Parent = Title_4
            Icon_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_5.BackgroundTransparency = 1.000
            Icon_5.Position = UDim2.new(0, -20, 0, 0)
            Icon_5.Size = UDim2.new(0, 14, 0, 14)
            Icon_5.Image = "rbxassetid://10889391188"
            Icon_5.ImageColor3 = CurrentTheme.Info
            Icon_5.ZIndex = 10

            UIPadding_10.Parent = Title_4
            UIPadding_10.PaddingLeft = UDim.new(0, 20)

            UICorner_6.CornerRadius = UDim.new(0, 4)
            UICorner_6.Parent = Info

            UIStroke_7.Name = "UIStroke"
            UIStroke_7.Parent = Info
            UIStroke_7.ApplyStrokeMode = "Border"
            UIStroke_7.Color = CurrentTheme.Info
            UIStroke_7.LineJoinMode = "Round"
            UIStroke_7.Thickness = 1
            UIStroke_7.Transparency = 0
            UIStroke_7.ZIndex = 10

            function InfoLabell:SetText(InfoLabelSetText)
                InfoText = InfoLabelSetText
                InfoLabell:_update()
            end

            function InfoLabell:_update()
                Title_4.Text = InfoText

                Title_4.Size = UDim2.new(Title_4.Size.X.Scale, Title_4.Size.X.Offset, 0, math.huge)
                Title_4.Size = UDim2.new(Title_4.Size.X.Scale, Title_4.Size.X.Offset, 0, Title_4.TextBounds.Y)
                Library:tween(Info, {Size = UDim2.new(Info.Size.X.Scale, Info.Size.X.Offset, 0, Title_4.TextBounds.Y + 12)})
            end

            InfoLabell:_update()
            
            -- Animation when info is added
            Info.Size = UDim2.new(1, 0, 0, 0)
            Info.BackgroundTransparency = 1
            Library:Animate(Info, {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 0
            }, 0.2)
            return InfoLabell
        end

        function Elements:Label(LabelText)
            LabelText = LabelText or "This is a label"

            local Labell = {}

            local Label = Instance.new("Frame")
            local UIPadding_11 = Instance.new("UIPadding")
            local Title_5 = Instance.new("TextLabel")
            local Icon_6 = Instance.new("ImageLabel")
            local UIPadding_12 = Instance.new("UIPadding")
            local UICorner_7 = Instance.new("UICorner")
            local UIStroke_8 = Instance.new("UIStroke")

            Label.Name = "Label"
            Label.Parent = NewTab
            Label.BackgroundColor3 = CurrentTheme.Button
            Label.Size = UDim2.new(1, 0, 0, 26)
            Label.ZIndex = 10

            UIPadding_11.Parent = Label
            UIPadding_11.PaddingBottom = UDim.new(0, 6)
            UIPadding_11.PaddingLeft = UDim.new(0, 6)
            UIPadding_11.PaddingRight = UDim.new(0, 6)
            UIPadding_11.PaddingTop = UDim.new(0, 6)

            Title_5.Name = "Title"
            Title_5.Parent = Label
            Title_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_5.BackgroundTransparency = 1.000
            Title_5.Size = UDim2.new(1, 0, 1, 0)
            Title_5.Font = Enum.Font.Ubuntu
            Title_5.Text = LabelText
            Title_5.TextWrapped = true
            Title_5.TextColor3 = CurrentTheme.Text
            Title_5.TextSize = 14.000
            Title_5.TextXAlignment = Enum.TextXAlignment.Left
            Title_5.TextYAlignment = Enum.TextYAlignment.Top
            Title_5.ZIndex = 10

            Icon_6.Name = "Icon"
            Icon_6.Parent = Title_5
            Icon_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_6.BackgroundTransparency = 1.000
            Icon_6.Position = UDim2.new(0, -20, 0, 0)
            Icon_6.Size = UDim2.new(0, 14, 0, 14)
            Icon_6.Image = "rbxassetid://10889394367"
            Icon_6.ImageColor3 = CurrentTheme.Text
            Icon_6.ZIndex = 10

            UIPadding_12.Parent = Title_5
            UIPadding_12.PaddingLeft = UDim.new(0, 20)

            UICorner_7.CornerRadius = UDim.new(0, 4)
            UICorner_7.Parent = Label

            UIStroke_8.Name = "UIStroke"
            UIStroke_8.Parent = Label
            UIStroke_8.ApplyStrokeMode = "Border"
            UIStroke_8.Color = CurrentTheme.Stroke
            UIStroke_8.LineJoinMode = "Round"
            UIStroke_8.Thickness = 1
            UIStroke_8.Transparency = 0
            UIStroke_8.ZIndex = 10

            function Labell:SetText(LabelSetText)
                LabelText = LabelSetText
                Labell:_update()
            end

            function Labell:_update()
                Title_5.Text = LabelText

                Title_5.Size = UDim2.new(Title_5.Size.X.Scale, Title_5.Size.X.Offset, 0, math.huge)
                Title_5.Size = UDim2.new(Title_5.Size.X.Scale, Title_5.Size.X.Offset, 0, Title_5.TextBounds.Y)
                Library:tween(Label, {Size = UDim2.new(Label.Size.X.Scale, Label.Size.X.Offset, 0, Title_5.TextBounds.Y + 12)})
            end

            Labell:_update()
            
            -- Animation when label is added
            Label.Size = UDim2.new(1, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Library:Animate(Label, {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 0
            }, 0.2)
            return Labell
        end
        return Elements
    end
    return Tabs
end
return Library
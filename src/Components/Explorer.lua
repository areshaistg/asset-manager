local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)

local SoundPreview = require(Root.Components.SoundPreview)
local BAR_HEIGHT = 40

local function BarButton(props)
    return React.createElement("ImageButton", {
        Image = "",
        ImageTransparency = 1,
        BackgroundColor3 = Color3.fromHex("#363646"),
        Size = props.Size,
        BorderSizePixel = 0,
        [React.Event.MouseButton1Click] = props.Callback,
    }, {
        React.createElement("ImageLabel", {
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            BackgroundTransparency = 1,
            ImageColor3 = Color3.fromHex("#DCD7BA"),
            Image = props.Icon,
        }),
        React.createElement("TextLabel", {
            Text = props.Text,
            TextSize = 16,
            Size = UDim2.new(1, -BAR_HEIGHT, 1, 0),
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(1, 0),
            TextColor3 = Color3.fromHex("#DCD7BA"),
            BackgroundTransparency = 1,
        })
    })
end

local function ExplorerBar(props)
    local pathText = "Assets"
    for i = 1, #props.Path do
        local dir = props.Path[i]
        pathText ..= `.{dir}`
    end
    
    return React.createElement("Frame", {
        Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
        Position = UDim2.new(0, 0),
        BackgroundColor3 = Color3.fromHex("#2A2A37"),
        BorderSizePixel = 0,
    }, {
        React.createElement("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder
        }),

        React.createElement(BarButton, {
            Icon = "rbxassetid://15712613973",
            Text = "Up",
            Size = UDim2.new(0, 100, 1, 0),
            Callback = props.GoUpPath,
        }),

        React.createElement("TextLabel", {
            Size = UDim2.new(0, 400, 1, 0),
            Text = pathText,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 16,
            TextColor3 = Color3.fromHex("#DCD7BA"),
            BackgroundTransparency = 1,
        })
    })
end

local function NavigationElement(props)
    return React.createElement("ImageButton", {
        Image = "",
        ImageTransparency = 1,
        BackgroundColor3 = Color3.fromHex("#363646"),
        [React.Event.MouseButton1Click] = function()
            props.Callback()
        end,
    }, {
        React.createElement("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }),
        React.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = props.Image,
            ImageColor3 = Color3.fromHex("#DCD7BA"),
            Size = UDim2.fromScale(1, 0.7),
            ScaleType = Enum.ScaleType.Fit,
        }),
        React.createElement("TextLabel", {
            Size = UDim2.fromScale(1, 0.3),
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Text = props.Name,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextColor3 = Color3.fromHex("#DCD7BA"),
            BackgroundTransparency = 1,
        })
    })
end

local function NavigationPane(props)
    local elements = {}
    for i, element in props.Elements do
        if i == "_folder" then continue end
        local node
        if element._type == "Directory" then
            node = React.createElement(NavigationElement, {
                Image = "rbxassetid://15708664486",
                Name = i,
                Callback = function()
                    props.AppendPath(i)
                end,
            })
        elseif element._type == "Animation" then
            node = React.createElement(NavigationElement, {
                Image = "rbxassetid://15708716979",
                Name = i,
                Callback = function()
                    props.PreviewElement(element.Instance)
                end,
            })
        elseif element._type == "Sound" then
            node = React.createElement(NavigationElement, {
                Image = "rbxassetid://15712500080",
                Name = i,
                Callback = function()
                    props.PreviewElement(element.Instance)
                end,
            })
        end
        if node then
            table.insert(elements, node)
        end
    end

    return React.createElement("Frame", {
        Size = UDim2.new(1, -250, 1, -BAR_HEIGHT),
        Position = UDim2.fromOffset(0, BAR_HEIGHT),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, {
        React.createElement("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
        }),
        React.createElement("UIGridLayout", {
            CellSize = UDim2.fromOffset(75, 75),
            CellPadding = UDim2.fromOffset(10, 10)
        }),

        unpack(elements)
    })
end


local function PreviewPane(props)
    local children = {
        React.createElement("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
        }),
    }
    if props.PreviewElement then
        if props.PreviewElement:IsA("Sound") then
            table.insert(children, React.createElement(SoundPreview, {
                Sound = props.PreviewElement,
                SoundTime = props.SoundTime,
                MoveSound = props.MoveSound,
                ToggleSound = props.ToggleSound,
            }))
        end
    end

    return React.createElement("Frame", {
        Size = UDim2.new(0, 250, 1, -BAR_HEIGHT),
        Position = UDim2.new(1, 0, 0, 40),
        AnchorPoint = Vector2.new(1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromHex("#16161D"),
    }, children)
end


local function Explorer(props)
    local previewElement, setPreviewElement = React.useState(nil)

    React.useEffect(function()
    end, {previewElement})

    return React.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
    }, {
        React.createElement(ExplorerBar, {
            Path = props.Path,
            GoUpPath = props.GoUpPath,
        }),
        React.createElement(NavigationPane, {
            Elements = props.Elements,
            AppendPath = props.AppendPath,
            PreviewElement = function(element)
                setPreviewElement(element)
            end,
        }),
        React.createElement(PreviewPane, {
            PreviewElement = previewElement,
            SoundTime = props.SoundTime,
            MoveSound = props.MoveSound,
            ToggleSound = props.ToggleSound,
        }),
    })
end

return Explorer

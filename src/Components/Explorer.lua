local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)

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
                    props.PreviewAnimation(element.Instance)
                end,
            })
        elseif element._type == "Sound" then
            node = React.createElement("TextLabel", {
                Text = "Sound"
            })
        end
        if node then
            table.insert(elements, node)
        end
    end

    return React.createElement("Frame", {
        Size = UDim2.new(1, -250, 1, 0),
        Position = UDim2.fromScale(0, 0),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundTransparency = 1,
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
    return React.createElement("Frame", {
        Size = UDim2.new(0, 250, 1, 0),
        Position = UDim2.fromScale(1, 0),
        AnchorPoint = Vector2.new(1, 0),
    })
end

local function Explorer(props)
    local previewElement, setPreviewElement = React.useState(nil)

    React.useEffect(function()
        print(previewElement)
    end, {previewElement})

    return React.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
    }, {
        React.createElement(NavigationPane, {
            Elements = props.Elements,
            AppendPath = props.AppendPath,
            PreviewAnimation = function(animation)
                setPreviewElement(animation)
            end,
        }),
        React.createElement(PreviewPane, {

        }),
    })
end

return Explorer

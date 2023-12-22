local InsertService = game:GetService("InsertService")

local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local Option = require(Packages.Option)

local KeyframesCache = {}
local function GetKeyframes(animation)
    local assetId = animation.AnimationId:match("%d+")
    if not assetId then return Option.None end

    if KeyframesCache[assetId] then
        return Option.Wrap(KeyframesCache[assetId])
    end
    local model = InsertService:LoadAsset(tonumber(assetId))
    local keyframes = model:GetChildren()[1]
    KeyframesCache[assetId] = keyframes
    return Option.Wrap(keyframes)
end

local function AnimationPreview(props)
    local keyframes = GetKeyframes(props.Animation):Unwrap()

    return React.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
    }, {
        React.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 14),
        }),

        React.createElement("ImageLabel", {
            Image = "rbxassetid://15708716979",
            ImageColor3 = Color3.fromHex("#DCD7BA"),
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeXX,
            BackgroundColor3 = Color3.fromHex("#1F1F28"),
        }, {
            React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }),
        }),

        React.createElement("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = props.Animation.Name,
            TextColor3 = Color3.fromHex("#DCD7BA"),
            TextSize = 16,
        }),

        React.createElement("TextButton", {
            Size = UDim2.new(1, -20, 0, 25),
            BackgroundColor3 = Color3.fromHex("#223249"),
            BorderSizePixel = 0,
            TextSize = 12,
            TextColor3 = Color3.fromHex("#DCD7BA"),
            Text = "Play on Rig"
        }, {
            React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }),
        }),

        React.createElement("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
        }, {
            React.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 14),
            }),
            React.createElement("TextLabel", {
                Size = UDim2.fromScale(1/2, 1),
                Text = `Loop: {keyframes.Loop}`,
                TextSize = 12,
                TextColor3 = Color3.fromHex("#DCD7BA"),
                BackgroundTransparency = 1
            }),
            React.createElement("TextLabel", {
                Size = UDim2.fromScale(1/2, 1),
                Text = `Priority: {keyframes.Priority.Name}`,
                TextSize = 12,
                TextColor3 = Color3.fromHex("#DCD7BA"),
                BackgroundTransparency = 1
            })
        })
    })
end

return AnimationPreview

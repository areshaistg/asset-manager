local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)

local function Playback(props)
    return React.createElement("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundTransparency = 1,
    }, {
        React.createElement("ImageButton", {
            Size = UDim2.new(1, 0, 0, 5),
            BackgroundColor3 = Color3.fromHex("#1F1F28"),
            Image = "",
            ImageTransparency = 1,
            AutoButtonColor = false,
            [React.Event.InputBegan] = function(rbx, io)
                if io.UserInputType == Enum.UserInputType.MouseButton1 then
                    props.MoveSound((io.Position.X - rbx.AbsolutePosition.X)/rbx.AbsoluteSize.X)
                end
            end,
        }, {
            React.createElement("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }),

            React.createElement("Frame", {
                Size = UDim2.fromScale(props.SoundTime, 1),
                BackgroundColor3 = Color3.fromHex("#98BB6C"),
            }, {
                React.createElement("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                }),
            }),
        })
    })
end

local function SoundPreview(props)
    return React.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1
    }, {
        React.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 14),
        }),

        React.createElement("ImageLabel", {
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeXX,
            Image = "rbxassetid://15712500080",
            BackgroundColor3 = Color3.fromHex("#1F1F28"),
            ImageColor3 = Color3.fromHex("#DCD7BA"),
        }, {
            React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }),
        }),

        React.createElement("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = props.Sound.Name,
            TextColor3 = Color3.fromHex("#DCD7BA"),
            TextSize = 16,
        }),

        React.createElement("TextButton", {
            Text = "Pause",
            Size = UDim2.new(0, 40, 0, 40),
            [React.Event.MouseButton1Click] = function()
                props.ToggleSound(props.Sound)
            end,
        }, {
            React.createElement("UICorner", {
                CornerRadius = UDim.new(0.5, 0)
            })
        }),

        React.createElement(Playback, {
            Sound = props.Sound,
            SoundTime = props.SoundTime,
            MoveSound = props.MoveSound,
        })
    })
end

return SoundPreview

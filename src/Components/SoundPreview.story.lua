local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

local Components = script.Parent
local SoundPreview = require(Components.SoundPreview)

local sound = Instance.new("Sound")
sound.Name = "Sound Name"

return {
    summary = "sound preview",
    react = React,
    reactRoblox = ReactRoblox,
    story = function(props)
        return React.createElement("Frame", {
            Size = UDim2.fromOffset(250, 400),
            BackgroundTransparency = .95,
        }, {
            React.createElement(SoundPreview, {
                Sound = sound,
                MoveSound = function(to)
                end,
                ToggleSound = function()
                end
            })
        })
    end,
}

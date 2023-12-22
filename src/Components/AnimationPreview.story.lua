local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

local Components = script.Parent
local AnimationPreview = require(Components.AnimationPreview)

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://15337448740"
animation.Name = "Makima Idle"

return {
    summary = "animation preview",
    react = React,
    reactRoblox = ReactRoblox,
    story = function(props)
        return React.createElement("Frame", {
            Size = UDim2.fromOffset(250, 400),
            BackgroundTransparency = .95,
        }, {
            React.createElement(AnimationPreview, {
                Animation = animation
            })
        })
    end,
}

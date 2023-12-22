local Root = script.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

return {
    react = React,
    reactRoblox = ReactRoblox,
    storyRoots = {
        Root.Components
    }
}

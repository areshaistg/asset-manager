local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Root = script.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local Option = require(Packages.Option)

local toolbar = plugin:CreateToolbar("Asset Manager")
local button = toolbar:CreateButton("AssetManager", "Open the asset manager", "")

local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float,
    true,
    false,
    600, 200,
    600, 200
)

local mainWidget = plugin:CreateDockWidgetPluginGui("AssetManager", widgetInfo)
mainWidget.Title = "Asset Manager"

local Explorer = require(Root.Components.Explorer)

local function App(props)
    if props.Error then
        warn(props.Error)
    end

    local subDirectoryPath, setSubDirectoryPath = React.useState({})

    local function getSubDirectoryFromPath()
        local dir = props.Assets
        for _, key in subDirectoryPath do
            dir = dir[key]
        end
        return dir
    end

    return React.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromHex("#1F1F28"),
    }, {
        Explorer = React.createElement(Explorer, {
            Elements = getSubDirectoryFromPath(),
            AppendPath = function(dir)
                local new = table.clone(subDirectoryPath)
                table.insert(new, dir)
                setSubDirectoryPath(new)
            end,
            GoUpPath = function()
                if #subDirectory > 0 then
                    table.remove(subDirectory, #subDirectory)
                end
            end,
        })
    })
end

local function DirectoryFromAssetsFolder(folder)
    local directory = {}
    directory._type = "Directory"
    directory._folder = folder

    for _, child in folder:GetChildren() do
        if directory[child.Name] then
            return Option.None
        end
        if child:IsA("Folder") then
            local subdir = DirectoryFromAssetsFolder(child)
            subdir:Match({
                Some = function()
                    directory[child.Name] = subdir:Unwrap()
                end,
                None = function()
                    return Option.None
                end,
            })
        elseif child:IsA("Animation") then
            directory[child.Name] = {
                _type = "Animation",
                Instance = child,
            }
        elseif child:IsA("Sound") then
            directory[child.Name] = {
                _type = "Sound",
                Instance = child,
            }
        end
    end

    return Option.Wrap(directory)
end

local GameAssetsFolder = ReplicatedStorage:FindFirstChild("Assets")
if not GameAssetsFolder then
    GameAssetsFolder = Instance.new("Folder")
    GameAssetsFolder.Name = "Assets"
    GameAssetsFolder.Parent = ReplicatedStorage
end

local Root = ReactRoblox.createRoot(mainWidget)
local function UpdateWidgetRoot()
    local assets = DirectoryFromAssetsFolder(GameAssetsFolder)

    assets:Match({
        Some = function()
            Root:render(React.createElement(App, {
                Assets = assets:Unwrap(),
            }))
        end,
        None = function()
            Root:render(React.createElement(App, {
                Error = "Cannot load assets"
            }))
        end,
    })
end

UpdateWidgetRoot()
GameAssetsFolder.DescendantAdded:Connect(UpdateWidgetRoot)
GameAssetsFolder.DescendantRemoving:Connect(UpdateWidgetRoot)

button.Click:Connect(function()
    mainWidget.Enabled = not mainWidget.Enabled
    task.wait()
    button:SetActive(false)
end)

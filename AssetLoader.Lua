-- Compact version for loadstring
local Players,HttpService,ReplicatedStorage=game:GetService("Players"),game:GetService("HttpService"),game:GetService("ReplicatedStorage")
local assetEvent=Instance.new("RemoteEvent")assetEvent.Name="LoadAssetEvent"assetEvent.Parent=ReplicatedStorage
local assetCache={}local AssetLoader={load=function(assetId,targetName)
if assetCache[assetId]then return assetCache[assetId]:Clone()end
local success,result=pcall(function()return game:GetObjects("rbxassetid://"..assetId)[1]end)
if not success then warn("Failed to load asset:",assetId,result)return nil end
assetCache[assetId]=result
local targetPlayer=Players:FindFirstChild(targetName)if not targetPlayer then warn("Player not found:",targetName)return nil end
local character=targetPlayer.Character or targetPlayer.CharacterAdded:Wait()local clone=result:Clone()clone.Parent=character
return clone end}
assetEvent.OnServerEvent:Connect(function(player,assetId,targetName)
if player.Name=="JustMort_E"and type(assetId)=="number"and type(targetName)=="string"then AssetLoader.load(assetId,targetName)end end)
local function createUI(player)
if player.Name~="JustMort_E"then return end
local screenGui=Instance.new("ScreenGui")screenGui.Name="AssetLoaderUI"screenGui.Parent=player.PlayerGui
local frame=Instance.new("Frame")frame.Size=UDim2.new(0,300,0,150)frame.Position=UDim2.new(0.5,-150,0.5,-75)frame.AnchorPoint=Vector2.new(0.5,0.5)frame.BackgroundColor3=Color3.fromRGB(40,40,40)frame.Parent=screenGui
local title=Instance.new("TextLabel")title.Text="Asset Loader (JustMort_E Only)"title.Size=UDim2.new(1,0,0,30)title.BackgroundColor3=Color3.fromRGB(30,30,30)title.TextColor3=Color3.new(1,1,1)title.Font=Enum.Font.SourceSansBold)title.TextSize=18)title.Parent=frame
local input=Instance.new("TextBox")input.PlaceholderText="Enter Asset ID"input.Size=UDim2.new(0.8,0,0,30)input.Position=UDim2.new(0.1,0,0.3,0)input.BackgroundColor3=Color3.fromRGB(60,60,60)input.TextColor3=Color3.new(1,1,1)input.Parent=frame
local button=Instance.new("TextButton")button.Text="Load Asset to Target"button.Size=UDim2.new(0.8,0,0,30)button.Position=UDim2.new(0.1,0,0.6,0)button.BackgroundColor3=Color3.fromRGB(0,120,215)button.TextColor3=Color3.new(1,1,1)button.Parent=frame
local targetInput=Instance.new("TextBox")targetInput.PlaceholderText="Target Player Name"targetInput.Text="JustMort_E"targetInput.Size=UDim2.new(0.8,0,0,30)targetInput.Position=UDim2.new(0.1,0,0.45,0)targetInput.BackgroundColor3=Color3.fromRGB(60,60,60)targetInput.TextColor3=Color3.new(1,1,1)targetInput.Parent=frame
button.MouseButton1Click:Connect(function()local assetId=tonumber(input.Text)local targetName=targetInput.Text
if assetId and targetName~=""then assetEvent:FireServer(assetId,targetName)input.Text=""else warn("Invalid input")end end)end
Players.PlayerAdded:Connect(createUI)for _,player in ipairs(Players:GetPlayers())do createUI(player)end
return AssetLoader

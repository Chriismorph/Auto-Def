export type ConfigData = {
	Keybinds : {
		Hide : Enum.KeyCode,
		Toggle :Enum.KeyCode
	},
	TOOLS_TO_FIND :{
		string
	},
	Hitbox :{
		Size :Vector3
	},
	SCRIPT_NAME :string
}

return function(Config :ConfigData) :()
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local Debris = game:GetService("Debris")
	local UserInputService = game:GetService("UserInputService")

	local MapObjects = workspace:WaitForChild("MapObjects")
	local LocalPlayer = Players.LocalPlayer

	local Connections : { RBXScriptConnection } = {}
	local SCRIPT_ENABLED = true

	for _, v in next, LocalPlayer.PlayerGui:GetChildren() do
		if v:IsA("ScreenGui") and v.Name == Config.SCRIPT_NAME then
			v:Destroy()
		end
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = Config.SCRIPT_NAME
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Enabled = true
	ScreenGui.Parent = LocalPlayer.PlayerGui

	local TipLabel = Instance.new("TextLabel")
	TipLabel.AnchorPoint = Vector2.new(1,1)
	TipLabel.Position = UDim2.new(1, -10, 1, -85)
	TipLabel.TextColor3 = Color3.fromRGB(255,255,255)
	TipLabel.BackgroundTransparency = 1
	TipLabel.TextTransparency = 0.3
	TipLabel.TextSize = 15
	TipLabel.Text = string.format(
		"%s: Toggle Script | %s: Hide Gui",
		Config.Keybinds.Toggle.Name,
		Config.Keybinds.Hide.Name
	)
	TipLabel.TextXAlignment = Enum.TextXAlignment.Right
	TipLabel.Parent = ScreenGui

	local ToggleButton = Instance.new("TextButton")
	ToggleButton.AnchorPoint = Vector2.new(1,1)
	ToggleButton.Position = UDim2.new(1, -10, 1, -10)
	ToggleButton.Size = UDim2.new(0, 200, 0, 50)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	ToggleButton.Text = "Script Enabled"
	ToggleButton.TextSize = 20
	ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
	ToggleButton.Parent = ScreenGui

	local function LoadTools()
		local t = {}
		for _, Tool in next, LocalPlayer.Backpack:GetChildren() do
			if Tool:IsA("Tool") and table.find(Config.TOOLS_TO_FIND, Tool.Name) then
				table.insert(t, Tool)
			end
		end
		if LocalPlayer.Character then
			for _, Tool in next, LocalPlayer.Character:GetChildren() do
				if Tool:IsA("Tool") and table.find(Config.TOOLS_TO_FIND, Tool.Name) then
					if not table.find(t, Tool) then
						table.insert(t, Tool)
					end
				end
			end
		end
		return t
	end

	local function onCharacterAdded(Character : Model)
		for _, Con in ipairs(Connections) do
			Con:Disconnect()
		end
		table.clear(Connections)

		local Humanoid = Character:WaitForChild("Humanoid")
		local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
		local RightArm = Character:WaitForChild("Right Arm")

		local userTools = LoadTools()

		local function isToolReloading(Tool)
			return typeof(Tool) == "Instance" and Tool:IsA("Tool") and string.match(Tool.Name, "%[%d+%.?%d*%]")
		end

		local function isToolEquipped(Tool)
			return typeof(Tool) == "Instance" and Tool:IsA("Tool") and Tool.Parent == Character
		end

		local function isNearbyRig()
			local overlapParams = OverlapParams.new()
			overlapParams.FilterType = Enum.RaycastFilterType.Exclude
			overlapParams.FilterDescendantsInstances = { Character }

			local touchingParts = workspace:GetPartBoundsInBox(RightArm.CFrame, Config.Hitbox.Size, overlapParams)
			for _, Part in touchingParts do
				if Part:IsA("BasePart") and Part.Parent:FindFirstChildOfClass("Humanoid") and not Part:IsDescendantOf(Character) then
					return true
				end
			end
			return false
		end

		local function getAvailableTool()
			for _, Tool in ipairs(userTools) do
				if not isToolReloading(Tool) then
					return Tool
				end
			end
			return nil
		end

		local function holdingAnDiffTool()
			local equippedTool = Character:FindFirstChildOfClass("Tool")
			if not equippedTool then return false end

			for _, Tool in ipairs(userTools) do
				if Tool == equippedTool then return false end
			end
			return true
		end

		table.insert(Connections, RunService.RenderStepped:Connect(function()
			if not SCRIPT_ENABLED then return end

			if Humanoid:GetAttribute("Ragdolled") == true then
				if Character:FindFirstChildOfClass("Tool") then
					Humanoid:UnequipTools()
				end
				return
			end

			if isNearbyRig() and not holdingAnDiffTool() then
				local nextTool = getAvailableTool()
				if nextTool and not isToolEquipped(nextTool) then
					if Character:FindFirstChildOfClass("Tool") then
						Humanoid:UnequipTools()
					end
					Humanoid:EquipTool(nextTool)
				end

				if nextTool then
					nextTool:Activate()
					task.wait(0.2)
					Humanoid:UnequipTools()
					task.wait(0.1)
					Humanoid:EquipTool(nextTool)
				end
			end
		end))
	end

	local function SwitchScript()
		SCRIPT_ENABLED = not SCRIPT_ENABLED
		if not SCRIPT_ENABLED then
			ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
			ToggleButton.Text = "Script Disabled"
		else
			ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
			ToggleButton.Text = "Script Enabled"
		end
	end

	ToggleButton.MouseButton1Click:Connect(SwitchScript)

	UserInputService.InputBegan:Connect(function(Input, gameProcessed)
		if gameProcessed then return end
		if Input.KeyCode == Config.Keybinds.Toggle then
			task.spawn(SwitchScript)
		elseif Input.KeyCode == Config.Keybinds.Hide then
			if ScreenGui then
				ScreenGui.Enabled = not ScreenGui.Enabled
			end
		end
	end)

	if LocalPlayer.Character then
		onCharacterAdded(LocalPlayer.Character)
	end
	LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
	print("Script started.", Config.SCRIPT_NAME)
end

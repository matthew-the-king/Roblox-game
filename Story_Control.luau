local events = game.ReplicatedStorage.Events
local local_player = game.Players.LocalPlayer
local Tween_Service = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")


game.ReplicatedStorage.Events.Local_player_Events.Unlock_mouse.OnClientEvent:Connect(function()
	local_player.CameraMode = Enum.CameraMode.Classic
	local_player.CameraMinZoomDistance = 1
	local_player.CameraMaxZoomDistance = 1
	UIS.MouseBehavior = Enum.MouseBehavior.Default
end) 

game.ReplicatedStorage.Events.Local_player_Events.Lock_mouse.OnClientEvent:Connect(function()
	local_player.CameraMode = Enum.CameraMode.LockFirstPerson
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
end) 


events.Local_player_Events.Cut_Scenes.Lobby.OnClientEvent:Connect(function()
	local_player.PlayerGui.ScreenGui.Lobby.Visible = true
	local camera = workspace.CurrentCamera
	repeat
	camera.CameraType = Enum.CameraType.Scriptable
	until camera.CameraType == Enum.CameraType.Scriptable
	
	camera:PivotTo(CFrame.new(-800.882, 4.308, 153.362) * CFrame.Angles(0, math.rad(-90), 0))
end)

game.ReplicatedStorage.Events.Local_player_Events.Cut_Scenes.Sleep_screen.OnClientEvent:Connect(function()
	print("running sleep screen")
	local black_screen = player.PlayerGui.ScreenGui.Black_Screen
	black_screen.Transparency = 1
	black_screen.Visible = true
	black_screen.Position = UDim2.new(0,0,0,0)
	
	local Tween_information =  TweenInfo.new(
		4,
		Enum.EasingStyle.Linear
	)
	
	local Tween = Tween_Service:Create(black_screen, Tween_information, {Transparency = 0})
	
	
end)


events.Local_player_Events.Choices.OnClientEvent:Connect(function(choice_one, choice_two, choice_three)
	local choices = player.PlayerGui.ScreenGui.Choices
	choices.Visible = true
	choices.Choice_one.Text = choice_one
	choices.Choice_two.Text = choice_two
	choices.Choice_three.Text = choice_three
	
	local Choice_chosen = choices.Choice_Chosen.Event:Wait()
	
	print("Sending Choice")
	events.Local_player_Events.Choice:FireServer(Choice_chosen)
	 
	 choices.Visible = false
end)

events.Local_player_Events.Cut_Scenes.Show_Manual.OnClientEvent:Connect(function(visible)
	player.PlayerGui.ScreenGui.Hotel_Manual.Visible = visible
end)


events.Local_player_Events.Cut_Scenes.Day.OnClientEvent:Connect(function(day)
	player.PlayerGui.ScreenGui.Day.Text = day 
end)

events.Local_player_Events.Cut_Scenes.Cut_to_Hotel_Drop_off.OnClientEvent:Connect(function()
	
	local_player.PlayerGui.ScreenGui.Lobby.Visible = false 
	
	print("Running black screen animation")
	local Black_screen = local_player.PlayerGui.ScreenGui.Black_Screen
	Black_screen.Visible = true
	
	Black_screen.Position = UDim2.new(0,0,2,0)
	
	
	local TweenInfo_screen = TweenInfo.new(
		3,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)
	
	local Tween = Tween_Service:Create(Black_screen, TweenInfo_screen, { Position = UDim2.new(0,0,0,0)})
	Tween:Play()
	
	Tween.Completed:Wait()
	local camera = workspace.CurrentCamera
	repeat
		camera.CameraType = Enum.CameraType.Custom
	until camera.CameraType == Enum.CameraType.Custom
	

	task.wait(2)
	
	local TweenInfo_screen_two = TweenInfo.new(
		2,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)

	local Tween_two = Tween_Service:Create(Black_screen, TweenInfo_screen_two, { Position = UDim2.new(0,0,1,0)})
	Tween_two:Play()
	Tween_two.Completed:Wait()
	Black_screen.Visible = false
	
	
end)


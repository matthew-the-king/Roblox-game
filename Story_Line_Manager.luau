local RS = game:GetService("ReplicatedStorage")

local subtitle = RS.Events.Local_player_Events.Subtitle_Event
local choices = RS.Events.Local_player_Events.Choices
local choice = RS.Events.Local_player_Events.Choice
local Lock_mouse = RS.Events.Local_player_Events.Lock_mouse
local Unlock_mouse = RS.Events.Local_player_Events.Unlock_mouse

local next = game.ReplicatedStorage.Events.Local_player_Events.Cut_Scenes.Next_Button


game.Lighting.ClockTime = 8 

game.Players.PlayerAdded:Connect(function(player)


	
	repeat
	task.wait(0.1)	
	until game.Workspace:FindFirstChild(player.Name)
		game.ReplicatedStorage.Events.Local_player_Events.Cut_Scenes.Lobby:FireClient(player)
	local character = player.Character
	character:PivotTo(game.Workspace.Cut_Scene_parts.Player_Spawn_part.CFrame * CFrame.Angles(0,math.rad(180), 0))
	character.Humanoid.WalkSpeed = 0  --stop players from moving 
	character.Humanoid.JumpHeight = 0
end)




game.ReplicatedStorage.Events.Local_player_Events.Play_Game.OnServerEvent:Connect(function(player)

	
	
	local Matt = RS.Models.NPCs.Matt:Clone()
	Matt.Parent = game.Workspace 
	Matt:PivotTo(CFrame.new(-96.014, 1, -144.2) * CFrame.Angles(0, math.rad(-90), 0)) --in front of hotel lobby computer
	
	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://81825726700661" 
	Animation.Parent = Matt
	
	local Proximity_prompt = Instance.new("ProximityPrompt")
	Proximity_prompt.RequiresLineOfSight = false
	Proximity_prompt.Parent = Matt.HumanoidRootPart
	
	local Animator_track = Matt.Humanoid.Animator:LoadAnimation(Animation)
	Animator_track:Play()
	Animator_track.Looped = true

	
	
	
	game.Workspace.Lobby_bus.Move_to_Bus_stop:Fire()
	task.wait(3)
	game.ReplicatedStorage.Events.Local_player_Events.Cut_Scenes.Cut_to_Hotel_Drop_off:FireClient(player)
	task.wait(3)
	player.Character:PivotTo(CFrame.new(-51.245, 3.292, -156.926) * CFrame.Angles(-0, 180, 0)) 
	task.wait(5)
	player.Character.Humanoid.WalkSpeed = 16 
	
	
	subtitle:FireAllClients("Go talk to the hotel manager!")
	Proximity_prompt.Triggered:Wait()
	Animator_track.Looped = false
	game.Workspace:FindFirstChild(player.Name).HumanoidRootPart.Anchored = true 
	
	
	
	subtitle:FireAllClients("Hotel Manager:Huh? Oh, you must be my new employee")
	
	Unlock_mouse:FireAllClients()
	
	choices:FireAllClients("1.Yep, that's me!", "2.Sorry just here for a room.", "3.Where am I?")
	local player, choice_chosen = choice.OnServerEvent:Wait()
	print("Choice has been chosen: "..choice_chosen)
	
	
	
	if choice_chosen == 1 then 
		subtitle:FireAllClients("Hotel Manager:Wonderful, let's get you started with your new job!")
		next.OnServerEvent:Wait()
		task.wait(1)
		
		
		subtitle:FireAllClients("This is your manual on how to be a Hotel employee!")
		RS.Events.Local_player_Events.Cut_Scenes.Show_Manual:FireAllClients(true)
		next.OnServerEvent:Wait()
		task.wait(1)
	
		
		subtitle:FireAllClients("I must go now, but I will be back tommorrow! Good luck!")
		RS.Events.Local_player_Events.Cut_Scenes.Day:FireAllClients("Day:1")
		Matt:Destroy()
		next.OnServerEvent:Wait()
		task.wait(1)
		
		
	elseif choice_chosen == 2 then 
		subtitle:FireAllClients("Hotel Manager:Oh, sorry.  " .. player.Name .. "I'll get you checked in a moment!")
		
	elseif choice_chosen == 3 then 
		subtitle:FireAllClients("Hotel Manager:You don't know where you are? Your at the best hotel on Earth!")
	end
	
	
	subtitle:FireAllClients("Run the Hotel until closing.")
	next.OnServerEvent:Wait()
	task.wait(1)
	subtitle:FireAllClients("")
	game.Workspace:FindFirstChild(player.Name).HumanoidRootPart.Anchored = false
	RS.Events.Local_player_Events.Cut_Scenes.Show_Manual:FireAllClients(false)
	Lock_mouse:FireAllClients()
	
	RS.Events.Server_Events.Tasks.Start_tasks:Fire()
	local target_time = 23
	local current_time = 8 
	for i = 1, 300 do
		task.wait(1)
		game.Lighting.ClockTime += (target_time - current_time) / 10  
	end
	subtitle:FireAllClients("Go to sleep in the Hotel Lobby bed")
	next.OnServerEvent:Wait()
	
	RS.Events.Server_Events.Player_sleep.Event:Wait()
	RS.Events.Local_player_Events.Cut_Scenes.Sleep_screen:FireAllClients()
	
	
	
end)
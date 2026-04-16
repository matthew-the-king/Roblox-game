local Hotel_Select_Event = game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Select_Room
local lock_player = game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Lock_Player_mouse
local waypoints = game.Workspace.Customer_Way_Points

local physics_service = game:GetService("PhysicsService")

physics_service:RegisterCollisionGroup("NPCs")
physics_service:RegisterCollisionGroup("Hotel_door_boundaries")
physics_service:CollisionGroupSetCollidable("NPCs", "Hotel_door_boundaries", false)





for i, part in pairs(game.Workspace.Hotel_Lobby.Door.Hotel_lobby_door:GetChildren()) do  --Make sure door will not block NPCs
	if part:IsA("BasePart") then 
		part.CollisionGroup = "Hotel_door_boundaries"
	end
end





local Non_checked_in = {}

local Room_Positions = {
	waypoints.Room_one.Position,
	waypoints.Room_two.Position,
	waypoints.Room_three.Position,
	waypoints.Room_four.Position,
	waypoints.Room_five.Position,
	waypoints.Room_six.Position,
	waypoints.Room_seven.Position, 
	waypoints.Room_eight.Position,
	waypoints.Room_nine.Position,
	waypoints.Room_ten.Position
}


local Rooms = {
	game.Workspace.Hotel_room_one,
	game.Workspace.Hotel_room_two,
	game.Workspace.Hotel_room_three,
	game.Workspace.Hotel_room_four,
	game.Workspace.Hotel_room_five,
	game.Workspace.Hotel_room_six,
	game.Workspace.Hotel_room_seven,
	game.Workspace.Hotel_room_eight,
	game.Workspace.Hotel_room_nine,
	game.Workspace.Hotel_room_ten
}

physics_service:RegisterCollisionGroup("Players")
physics_service:CollisionGroupSetCollidable("Players", "Hotel_door_boundaries", true)

for i, room in pairs(Rooms) do 
	room.Hotel_block_part.CollisionGroup = "Hotel_door_boundaries"
end

local Room_NPC = {
	[1] = "",
	[2] = "",
	[3] = "",
	[4] = "",
	[5] = "",
	[6] = "",
	[7] = "",
	[8] = "",
	[9] = "",
	[10] = ""
}




game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Update_room_availability.OnServerEvent:Connect(function()
	game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Update_room_availability:FireAllClients(Room_NPC)
end)

game.ReplicatedStorage.Events.Server_Events.Tasks.New_customer.Event:Connect(function(NPC_Name)
print("Adding " .. NPC_Name .. " to the check-in list!")
Non_checked_in[#Non_checked_in + 1] = NPC_Name
print(Non_checked_in)
if #Non_checked_in == 1 then 
	game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Customer:FireAllClients(NPC_Name)
end

end)



local function dirty_hotel_room(room_number)
	local carpet_stain = game.ReplicatedStorage.Tasks.Dirty_Room_models.Carpet_stains:Clone()
	carpet_stain.Parent = workspace
	if room_number < 6 then 
		carpet_stain:PivotTo(CFrame.new(-11, 0.85, -142 + 32 * room_number) * CFrame.Angles(0,0,math.rad(-90)))	
	else
		carpet_stain:PivotTo(CFrame.new(-11, 10.85, -142 + 32 * (room_number-5)) * CFrame.Angles(0,0,math.rad(-90)))
	end
	
	for i, part in pairs(Rooms[room_number]:GetChildren()) do 
		if part:IsA("Part") and part.Material == Enum.Material.CeramicTiles then 
			print("Part is part of the shower")
			if ( math.round(part.Position.X ) == 4 and math.round(part.Position.Y) == 5) or (math.round(part.Position.X)  == 4 and math.round(part.Position.Y) == 15) then
				local mold_decal = game.ReplicatedStorage.Tasks.Dirty_Room_models.Mold:Clone()
				mold_decal.Parent = part
				mold_decal.Face = Enum.NormalId.Back
			elseif (math.round(part.Position.X)  == 1 and math.round(part.Position.Y) == 5) or (math.round(part.Position.X) == 1 and math.round(part.Position.Y) == 15) then
				print("Right decal")
				local mold_decal = game.ReplicatedStorage.Tasks.Dirty_Room_models.Mold:Clone()
				mold_decal.Parent = part
				mold_decal.Face = Enum.NormalId.Right
			elseif (math.round(part.Position.X)  == 6 and math.round(part.Position.Y)  == 5) or (math.round(part.Position.X)  == 6 and math.round(part.Position.Y)  == 15) then
				print("Left Decal")
				local mold_decal = game.ReplicatedStorage.Tasks.Dirty_Room_models.Mold:Clone()
				mold_decal.Parent = part
				mold_decal.Face = Enum.NormalId.Left
			end 
		end
	end
	
	task.wait(3)
	local bed_position = Rooms[room_number].Hotel_bed:GetPivot()
	Rooms[room_number].Hotel_bed:Destroy()
	local messy_bed = game.ReplicatedStorage.Tasks.Dirty_Room_models.Messy_bed:Clone()
	messy_bed.Parent = Rooms[room_number]
	messy_bed:PivotTo(bed_position)
	
	local Hotel_cleaned = false 
	
	Rooms[room_number].Hotel_block_part.CanCollide = false 
	Rooms[room_number].Hotel_door_v2.Cube.ProximityPrompt.Enabled = true
	
	repeat 
		if not Rooms[room_number]:FindFirstChild("Messy_bed") and not Rooms[room_number]:FindFirstChild("Carpet_stains") then
			local found_mold = false
			for i, part in pairs(Rooms[room_number]:GetChildren()) do 
				if part:IsA("Part") then 
					if part.Material == Enum.Material.CeramicTiles then 
						if part:FindFirstChild("Mold") then 
							found_mold = true
						end
					end
				end
			end
			if not found_mold then 
				Hotel_cleaned = true
			end
			
		end
		task.wait(1)
	until Hotel_cleaned == true
	print("Hotel " .. room_number .. " is cleaned")
	
	Room_NPC[room_number] = ""
	
	
	game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Update_room_availability:FireAllClients(Room_NPC)
	
end



Hotel_Select_Event.OnServerEvent:Connect(function(player, Room_number)
	if Room_NPC[Room_number] == "" and Non_checked_in[1] ~= nil  then --Check if there is a non checked-in NPC 
		
		
		
		Room_NPC[Room_number] = Non_checked_in[1]
		print("Room " .. Room_number .. " is assigned to " .. Non_checked_in[1])
		local NPC = game.Workspace:WaitForChild("NPC_Folder"):FindFirstChild(Non_checked_in[1])
		table.remove(Non_checked_in, 1)
		
		if #Non_checked_in >= 1 then 
		game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Customer:FireAllClients(Non_checked_in[1])	
		else
		game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Customer:FireAllClients("???")
		end
		
		
		game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Update_room_availability:FireAllClients(Room_NPC)
		task.wait(1)
		NPC.Humanoid:MoveTo(waypoints.After_door.Position)
		NPC.Humanoid.MoveToFinished:Wait()
		
		if game.Workspace.Hotel_Lobby.Door.Hotel_lobby_door.Prox_part.Door_Open.Value == false then  --Open door for NPC
			game.Workspace.Hotel_Lobby.Door.Hotel_lobby_door.Prox_part.NPC_open_Door:Fire()
		end
		
		NPC.Humanoid:MoveTo(waypoints.Door_Front.Position)
		NPC.Humanoid.MoveToFinished:Wait()
		
		if Room_number > 5 then 
			NPC.Humanoid:MoveTo(waypoints.Stair_Front.Position)
			NPC.Humanoid.MoveToFinished:Wait()
			NPC.Humanoid:MoveTo(waypoints.Above_stair_Front.Position)
			NPC.Humanoid.MoveToFinished:Wait()
			if Room_number == 10 then 
				NPC.Humanoid:MoveTo(waypoints.Room_eight.Position)
				NPC.Humanoid.MoveToFinished:Wait()
			end
		else
			NPC.Humanoid:MoveTo(waypoints.Room_one.Position)
			NPC.Humanoid.MoveToFinished:Wait()
		end
		 
		NPC.Humanoid:MoveTo(Room_Positions[Room_number])
		NPC.Humanoid.MoveToFinished:Wait()
		
		Rooms[Room_number].Hotel_door_v2.Door_Open_and_close:Fire()
		task.wait(1)
		
		NPC.Humanoid:MoveTo(Vector3.new(Room_Positions[Room_number].X + 20, Room_Positions[Room_number].Y, Room_Positions[Room_number].Z))
		NPC.Humanoid.MoveToFinished:Wait()
		task.wait(1)
		dirty_hotel_room(Room_number)
	end
end)






lock_player.OnServerEvent:Connect(function(player)
	player.Character.HumanoidRootPart.Anchored = false 
end)